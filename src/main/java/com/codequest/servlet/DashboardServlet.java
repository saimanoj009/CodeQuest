
package com.codequest.servlet;

import com.codequest.util.DBConnection;
import com.codequest.util.WebUtil;

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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether the student is logged in
        if (!WebUtil.requireStudent(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);

        // Safely get student ID from session
        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {
            session.invalidate();
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = ((Number) userIdObject).intValue();

        String userSql =
            "SELECT id, username, xp, level FROM users WHERE id = ?";

        String completedSql =
            "SELECT COUNT(DISTINCT mission_id) AS completed " +
            "FROM mission_submissions " +
            "WHERE user_id = ? AND is_correct = 1";

        try (Connection con = DBConnection.getConnection()) {

            // Get student details
            try (PreparedStatement ps = con.prepareStatement(userSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        request.setAttribute(
                            "username",
                            rs.getString("username")
                        );

                        request.setAttribute(
                            "xp",
                            rs.getInt("xp")
                        );

                        request.setAttribute(
                            "level",
                            rs.getInt("level")
                        );

                    } else {

                        // Student record does not exist
                        session.invalidate();

                        response.sendRedirect(
                            request.getContextPath() + "/login.jsp"
                        );
                        return;
                    }
                }
            }

            // Get completed missions count
            try (PreparedStatement ps =
                     con.prepareStatement(completedSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        request.setAttribute(
                            "completedMissions",
                            rs.getInt("completed")
                        );
                    } else {
                        request.setAttribute("completedMissions", 0);
                    }
                }
            }

            // Forward to dashboard JSP
            request.getRequestDispatcher("/dashboard.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Dashboard database error",
                e
            );

            request.setAttribute(
                "error",
                "Unable to load dashboard. Please try again."
            );

            request.getRequestDispatcher("/dashboard.jsp")
                   .forward(request, response);
        }
    }
}
