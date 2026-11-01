
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get login form values
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        username = (username == null) ? "" : username.trim();
        password = (password == null) ? "" : password;

        // Validate empty fields
        if (username.isEmpty() || password.isEmpty()) {

            request.setAttribute("error",
                    "Please enter both username and password.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
            return;
        }

        // SQL query
        String sql =
            "SELECT id, username FROM users " +
            "WHERE username = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    // Invalidate previous session
                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    // Create new student session
                    HttpSession session = request.getSession(true);

                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("username",
                            rs.getString("username"));

                    // Session timeout: 30 minutes
                    session.setMaxInactiveInterval(30 * 60);

                    // Redirect to student dashboard
                    response.sendRedirect(
                        request.getContextPath() + "/dashboard"
                    );
                    return;
                }
            }

            // Invalid credentials
            request.setAttribute("error",
                    "Invalid username or password.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Student login database error", e);

            request.setAttribute("error",
                    "Unable to connect to the database. Please try again.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
        }
    }
}
