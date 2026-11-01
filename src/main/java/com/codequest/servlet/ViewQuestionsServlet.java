
package com.codequest.servlet;

import com.codequest.util.DBConnection;
import com.codequest.util.WebUtil;

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

@WebServlet("/view-questions")
public class ViewQuestionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!WebUtil.requireAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> questions = new ArrayList<>();

        String sql =
            "SELECT id, title, description, category, difficulty, " +
            "option_a, option_b, option_c, option_d, " +
            "correct_answer, xp_reward " +
            "FROM missions ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> question = new HashMap<>();

                question.put("id", rs.getInt("id"));
                question.put("title", rs.getString("title"));
                question.put("description", rs.getString("description"));
                question.put("category", rs.getString("category"));
                question.put("difficulty", rs.getString("difficulty"));
                question.put("option_a", rs.getString("option_a"));
                question.put("option_b", rs.getString("option_b"));
                question.put("option_c", rs.getString("option_c"));
                question.put("option_d", rs.getString("option_d"));
                question.put("correct_answer", rs.getString("correct_answer"));
                question.put("xp_reward", rs.getInt("xp_reward"));

                questions.add(question);
            }

            request.setAttribute("questions", questions);

            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute("error",
                    "Unable to load questions. Please try again.");

            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);
        }
    }
}
