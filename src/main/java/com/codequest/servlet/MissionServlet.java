
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/missions")
public class MissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check student login
        if (!WebUtil.requireStudent(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);

        int userId = ((Number) session.getAttribute("userId")).intValue();

        List<Map<String, Object>> missions = new ArrayList<>();

        String sql =
            "SELECT m.id, m.title, m.description, m.category, " +
            "m.difficulty, m.option_a, m.option_b, m.option_c, " +
            "m.option_d, m.xp_reward " +
            "FROM missions m " +
            "WHERE NOT EXISTS (" +
            " SELECT 1 FROM mission_submissions s " +
            " WHERE s.mission_id = m.id " +
            " AND s.user_id = ?" +
            ") ORDER BY m.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> mission = new HashMap<>();

                    mission.put("id", rs.getInt("id"));
                    mission.put("title", rs.getString("title"));
                    mission.put("description", rs.getString("description"));
                    mission.put("category", rs.getString("category"));
                    mission.put("difficulty", rs.getString("difficulty"));

                    mission.put("option_a", rs.getString("option_a"));
                    mission.put("option_b", rs.getString("option_b"));
                    mission.put("option_c", rs.getString("option_c"));
                    mission.put("option_d", rs.getString("option_d"));

                    mission.put("xp_reward", rs.getInt("xp_reward"));

                    missions.add(mission);
                }
            }

            // Send missions to JSP
            request.setAttribute("missions", missions);

            request.getRequestDispatcher("/missions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute("error",
                    "Unable to load missions. Please check the database.");

            request.getRequestDispatcher("/missions.jsp")
                   .forward(request, response);
        }
    }
}
