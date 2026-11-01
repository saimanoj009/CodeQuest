
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.util.DBConnection" %>
<%@ page import="com.codequest.util.WebUtil" %>

<%
    String contextPath = request.getContextPath();

    if (!WebUtil.requireStudent(request, response)) {
        return;
    }

    Object userObject = session.getAttribute("userId");

    if (!(userObject instanceof Number)) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    int userId = ((Number) userObject).intValue();

    String username = (String) session.getAttribute("username");
    if (username == null) {
        username = "Student";
    }

    int totalAttempts = 0;
    int correctAnswers = 0;
    int totalXP = 0;

    String error = null;
    boolean hasResults = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Mission Results | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .results-container {
            max-width: 1050px;
            margin: 45px auto;
            padding: 0 22px;
        }

        .page-heading {
            margin-bottom: 30px;
        }

        .page-heading h1 {
            color: #172554;
            font-size: 34px;
            margin: 10px 0;
        }

        .page-heading p {
            color: #64748b;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-bottom: 35px;
        }

        .stat-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 23px;
        }

        .stat-card h3 {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .stat-value {
            font-size: 28px;
            color: #172554;
            font-weight: 700;
        }

        .result-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 18px;
        }

        .result-card h2 {
            color: #172554;
            font-size: 19px;
            margin-bottom: 15px;
        }

        .result-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 9px 0;
            color: #475569;
            flex-wrap: wrap;
        }

        .result-row strong {
            color: #1e293b;
        }

        .correct-badge {
            background: #dcfce7;
            color: #15803d;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .wrong-badge {
            background: #fee2e2;
            color: #b91c1c;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .empty-message {
            background: white;
            text-align: center;
            padding: 35px;
            border-radius: 12px;
            color: #64748b;
        }

        .error-message {
            background: #fef2f2;
            color: #b91c1c;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin: 25px 0;
        }

        .action-buttons a {
            text-decoration: none;
        }

        @media (max-width: 650px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .page-heading h1 {
                font-size: 27px;
            }
        }
    </style>
</head>

<body>

<header class="navbar">

    <a href="<%= contextPath %>/dashboard.jsp" class="brand">
        CodeQuest
    </a>

    <nav class="nav-links">
        <a href="<%= contextPath %>/dashboard.jsp">Dashboard</a>
        <a href="<%= contextPath %>/missions">Missions</a>
        <a href="<%= contextPath %>/leaderboard">Leaderboard</a>
    </nav>

</header>

<main class="results-container">

    <section class="page-heading">
        <p class="eyebrow">YOUR PERFORMANCE</p>

        <h1>Mission Results</h1>

        <p>
            Keep practicing, <%= WebUtil.esc(username) %>!
            Track your progress here.
        </p>
    </section>

    <%
        String statsSql =
            "SELECT COUNT(*) AS total_attempts, " +
            "COALESCE(SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END), 0) AS correct_answers, " +
            "COALESCE(SUM(xp_awarded), 0) AS total_xp " +
            "FROM mission_submissions WHERE user_id = ?";

        String resultSql =
            "SELECT m.title, m.category, m.difficulty, " +
            "m.correct_answer, s.selected_answer, " +
            "s.is_correct, s.xp_awarded, s.submitted_at " +
            "FROM mission_submissions s " +
            "INNER JOIN missions m ON s.mission_id = m.id " +
            "WHERE s.user_id = ? " +
            "ORDER BY s.submitted_at DESC";

        try (Connection con = DBConnection.getConnection()) {

            // Load summary statistics
            try (PreparedStatement ps = con.prepareStatement(statsSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalAttempts = rs.getInt("total_attempts");
                        correctAnswers = rs.getInt("correct_answers");
                        totalXP = rs.getInt("total_xp");
                    }
                }
            }

            // Load submitted answers
            try (PreparedStatement ps = con.prepareStatement(resultSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
    %>

    <section class="stats-grid">

        <div class="stat-card">
            <h3>Total Attempts</h3>
            <div class="stat-value"><%= totalAttempts %></div>
        </div>

        <div class="stat-card">
            <h3>Correct Answers</h3>
            <div class="stat-value"><%= correctAnswers %></div>
        </div>

        <div class="stat-card">
            <h3>XP Earned</h3>
            <div class="stat-value"><%= totalXP %></div>
        </div>

    </section>

    <div class="action-buttons">

        <a href="<%= contextPath %>/missions"
           class="btn btn-primary">
            Explore More Missions
        </a>

        <a href="<%= contextPath %>/dashboard.jsp"
           class="btn btn-outline">
            Back to Dashboard
        </a>

    </div>

    <h2 class="section-title">Your Submitted Answers</h2>

    <%
                    while (rs.next()) {

                        hasResults = true;

                        String title = rs.getString("title");
                        String category = rs.getString("category");
                        String difficulty = rs.getString("difficulty");
                        String selectedAnswer = rs.getString("selected_answer");
                        String correctAnswer = rs.getString("correct_answer");

                        boolean isCorrect = rs.getBoolean("is_correct");
                        int xp = rs.getInt("xp_awarded");

                        Timestamp submittedAt =
                            rs.getTimestamp("submitted_at");
    %>

    <article class="result-card">

        <h2><%= WebUtil.esc(title) %></h2>

        <div class="result-row">
            <span>Category</span>
            <strong><%= WebUtil.esc(category) %></strong>
        </div>

        <div class="result-row">
            <span>Difficulty</span>
            <strong><%= WebUtil.esc(difficulty) %></strong>
        </div>

        <div class="result-row">
            <span>Your Answer</span>
            <strong><%= WebUtil.esc(selectedAnswer) %></strong>
        </div>

        <div class="result-row">
            <span>Correct Answer</span>
            <strong><%= WebUtil.esc(correctAnswer) %></strong>
        </div>

        <div class="result-row">
            <span>Result</span>

            <% if (isCorrect) { %>
                <span class="correct-badge">Correct</span>
            <% } else { %>
                <span class="wrong-badge">Incorrect</span>
            <% } %>
        </div>

        <div class="result-row">
            <span>XP Earned</span>
            <strong><%= xp %> XP</strong>
        </div>

        <div class="result-row">
            <span>Submitted At</span>
            <strong>
                <%= submittedAt == null ? "-" : submittedAt %>
            </strong>
        </div>

    </article>

    <%
                    }

                    if (!hasResults) {
    %>

        <div class="empty-message">
            <h2>No results yet!</h2>
            <p>Complete your first programming mission to see your results.</p>
        </div>

    <%
                    }
                }
            }

        } catch (SQLException e) {
            application.log("Unable to load mission results", e);
            error = "Unable to load your results. Please check the database.";
        }

        if (error != null) {
    %>

        <div class="error-message">
            <%= WebUtil.esc(error) %>
        </div>

    <%
        }
    %>

</main>

<footer class="footer">
    <div class="footer-content">
        CodeQuest · Learn · Practice · Level Up
    </div>
</footer>

</body>
</html>
