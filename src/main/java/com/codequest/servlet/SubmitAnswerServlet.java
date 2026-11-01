
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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check student login
        if (!WebUtil.requireStudent(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {
            session.invalidate();

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = ((Number) userIdObject).intValue();

        // Get submitted form values
        String missionIdText = request.getParameter("missionId");
        String selectedAnswer = request.getParameter("selected_answer");

        // Validate mission ID
        int missionId;

        try {
            missionId = Integer.parseInt(missionIdText);

            if (missionId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath() + "/missions?error=invalid"
            );
            return;
        }

        // Validate selected answer
        if (selectedAnswer == null ||
            !selectedAnswer.trim().matches("(?i)[ABCD]")) {

            response.sendRedirect(
                request.getContextPath() + "/missions?error=answer"
            );
            return;
        }

        selectedAnswer = selectedAnswer.trim().toUpperCase();

        String missionSql =
            "SELECT correct_answer, xp_reward FROM missions WHERE id = ?";

        String duplicateSql =
            "SELECT id FROM mission_submissions " +
            "WHERE user_id = ? AND mission_id = ?";

        String insertSql =
            "INSERT INTO mission_submissions " +
            "(user_id, mission_id, selected_answer, is_correct, " +
            "xp_awarded, submitted_at) " +
            "VALUES (?, ?, ?, ?, ?, NOW())";

        String updateSql =
            "UPDATE users SET xp = COALESCE(xp, 0) + ? WHERE id = ?";

        // Process submission using a database transaction
        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {

                // Check whether the mission exists
                String correctAnswer;
                int xpReward;

                try (PreparedStatement ps =
                         con.prepareStatement(missionSql)) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();

                            response.sendRedirect(
                                request.getContextPath() +
                                "/missions?error=notfound"
                            );
                            return;
                        }

                        correctAnswer = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    }
                }

                // Check duplicate submission
                try (PreparedStatement ps =
                         con.prepareStatement(duplicateSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {
                            con.rollback();

                            response.sendRedirect(
                                request.getContextPath() +
                                "/missions?error=already"
                            );
                            return;
                        }
                    }
                }

                // Check answer
                boolean isCorrect =
                    correctAnswer != null &&
                    selectedAnswer.equalsIgnoreCase(
                        correctAnswer.trim()
                    );

                int awardedXP = isCorrect ? xpReward : 0;

                // Save submission
                try (PreparedStatement ps =
                         con.prepareStatement(insertSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, selectedAnswer);
                    ps.setBoolean(4, isCorrect);
                    ps.setInt(5, awardedXP);

                    ps.executeUpdate();
                }

                // Award XP only if answer is correct
                if (isCorrect) {

                    try (PreparedStatement ps =
                             con.prepareStatement(updateSql)) {

                        ps.setInt(1, awardedXP);
                        ps.setInt(2, userId);

                        int updatedRows = ps.executeUpdate();

                        if (updatedRows == 0) {
                            throw new SQLException(
                                "Student account was not found."
                            );
                        }
                    }
                }

                // Commit transaction
                con.commit();

                // Redirect to result page
                if (isCorrect) {

                    response.sendRedirect(
                        request.getContextPath() +
                        "/mission-results.jsp?result=correct&xp=" +
                        awardedXP
                    );

                } else {

                    response.sendRedirect(
                        request.getContextPath() +
                        "/mission-results.jsp?result=wrong"
                    );
                }

            } catch (SQLException | RuntimeException e) {

                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;
            }

        } catch (SQLException e) {

            getServletContext().log(
                "Error while submitting mission answer",
                e
            );

            response.sendRedirect(
                request.getContextPath() +
                "/missions?error=database"
            );
        }
    }
}
