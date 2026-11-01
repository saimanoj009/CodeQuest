
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> leaderboard = new ArrayList<>();

        String sql =
            "SELECT username, xp, level " +
            "FROM users " +
            "ORDER BY xp DESC, level DESC, username ASC " +
            "LIMIT 100";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int rank = 1;

            while (rs.next()) {

                Map<String, Object> student = new HashMap<>();

                student.put("rank", rank++);
                student.put("username", rs.getString("username"));
                student.put("xp", rs.getInt("xp"));
                student.put("level", rs.getInt("level"));

                leaderboard.add(student);
            }

            request.setAttribute("leaderboard", leaderboard);

        } catch (SQLException e) {

            getServletContext().log(
                "Leaderboard database error",
                e
            );

            request.setAttribute(
                "error",
                "Unable to load leaderboard. Please try again."
            );

            request.setAttribute("leaderboard", leaderboard);
        }

        // Forward to leaderboard JSP
        request.getRequestDispatcher("/leaderboard.jsp")
               .forward(request, response);
    }
}
