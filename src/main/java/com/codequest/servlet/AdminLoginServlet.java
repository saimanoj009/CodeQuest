
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

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        username = (username == null) ? "" : username.trim();
        password = (password == null) ? "" : password;

        // Validate input fields
        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute(
                "error",
                "Please enter both username and password."
            );

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "SELECT id, username FROM admins "
                   + "WHERE username = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    // Invalidate any existing session
                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    // Create a new admin session
                    HttpSession session = request.getSession(true);

                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute(
                        "adminUsername",
                        rs.getString("username")
                    );

                    session.setMaxInactiveInterval(30 * 60);

                    // Redirect to admin dashboard
                    response.sendRedirect(
                        request.getContextPath() + "/admin-dashboard.jsp"
                    );
                    return;
                }
            }

            // Invalid credentials
            request.setAttribute(
                "error",
                "Invalid administrator username or password."
            );

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Error occurred during admin login.",
                e
            );

            request.setAttribute(
                "error",
                "Database error. Please try again later."
            );

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);
        }
    }
}
