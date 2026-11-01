
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        // Validate required fields
        if (username.isEmpty()
                || email.isEmpty()
                || password == null
                || password.isEmpty()
                || confirm == null
                || confirm.isEmpty()) {

            request.setAttribute("error",
                    "Please fill in every field.");

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // Validate email
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            request.setAttribute("error",
                    "Enter a valid email address.");

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // Validate password confirmation
        if (!password.equals(confirm)) {

            request.setAttribute("error",
                    "Passwords do not match.");

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 8) {

            request.setAttribute("error",
                    "Use a password with at least 8 characters.");

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // Database operations
        try (Connection con = DBConnection.getConnection()) {

            // Check whether username or email already exists
            String checkSql =
                    "SELECT id FROM users WHERE username = ? OR email = ?";

            try (PreparedStatement check =
                         con.prepareStatement(checkSql)) {

                check.setString(1, username);
                check.setString(2, email);

                try (ResultSet rs = check.executeQuery()) {

                    if (rs.next()) {

                        request.setAttribute("error",
                                "That username or email is already registered.");

                        request.getRequestDispatcher("/register.jsp")
                               .forward(request, response);
                        return;
                    }
                }
            }

            // Insert new user
            String insertSql =
                    "INSERT INTO users " +
                    "(username, email, password, xp, level) " +
                    "VALUES (?, ?, ?, 0, 1)";

            try (PreparedStatement ps =
                         con.prepareStatement(insertSql)) {

                ps.setString(1, username);
                ps.setString(2, email);

                // Demo only: use a secure password hash in production.
                ps.setString(3, password);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/login.jsp?registered=1");
                    return;
                }
            }

            request.setAttribute("error",
                    "Registration could not be completed.");

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);

        } catch (SQLException ex) {

            // Print the actual database error in Eclipse Console
            ex.printStackTrace();

            request.setAttribute("error",
                    "Registration failed: " + ex.getMessage());

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
