
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
import java.sql.SQLException;
import java.util.Locale;

@WebServlet("/add-question")
public class AddQuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!WebUtil.requireAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = val(request, "title");
        String description = val(request, "description");
        String category = val(request, "category");
        String difficulty = val(request, "difficulty");

        String optionA = val(request, "option_a");
        String optionB = val(request, "option_b");
        String optionC = val(request, "option_c");
        String optionD = val(request, "option_d");

        String correctAnswer = val(request, "correct_answer")
                .toUpperCase(Locale.ROOT);

        String xpValue = val(request, "xp_reward");

        // Validate required text fields
        if (title.isEmpty() || description.isEmpty()
                || optionA.isEmpty() || optionB.isEmpty()
                || optionC.isEmpty() || optionD.isEmpty()
                || category.isEmpty() || difficulty.isEmpty()
                || correctAnswer.isEmpty()) {

            showError(request, response,
                    "Please complete all required fields.");
            return;
        }

        // Accept all categories used by the form
        if (!category.matches("Java|Python|SQL|DSA|Web")) {
            showError(request, response,
                    "Please select a valid question category.");
            return;
        }

        if (!difficulty.matches("Easy|Medium|Hard")) {
            showError(request, response,
                    "Please select a valid difficulty.");
            return;
        }

        if (!correctAnswer.matches("[ABCD]")) {
            showError(request, response,
                    "Please select the correct answer (A, B, C or D).");
            return;
        }

        // Validate XP separately
        int xpReward;

        try {
            xpReward = Integer.parseInt(xpValue);
        } catch (NumberFormatException e) {
            showError(request, response,
                    "Please enter a valid XP number.");
            return;
        }

        if (xpReward < 1 || xpReward > 1000) {
            showError(request, response,
                    "XP reward must be between 1 and 1000.");
            return;
        }

        String sql = "INSERT INTO missions "
                + "(title, description, category, difficulty, "
                + "option_a, option_b, option_c, option_d, "
                + "correct_answer, xp_reward) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, optionA);
            ps.setString(6, optionB);
            ps.setString(7, optionC);
            ps.setString(8, optionD);
            ps.setString(9, correctAnswer);
            ps.setInt(10, xpReward);

            ps.executeUpdate();

            response.sendRedirect(
                    request.getContextPath() + "/view-questions?added=1"
            );

        } catch (SQLException e) {

            getServletContext().log("Error adding question", e);

            showError(request, response,
                    "Could not save the question. Please check the database.");
        }
    }

    private String val(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);

        request.getRequestDispatcher("/add-question.jsp")
                .forward(request, response);
    }
}
