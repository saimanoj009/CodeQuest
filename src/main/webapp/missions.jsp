
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.codequest.util.WebUtil" %>

<%
    String contextPath = request.getContextPath();

    // Check student login
    if (!WebUtil.requireStudent(request, response)) {
        return;
    }

    String username = (String) session.getAttribute("username");
    if (username == null) {
        username = "Student";
    }

    // Get missions loaded by MissionServlet
    List<Map<String, Object>> missions =
        (List<Map<String, Object>>) request.getAttribute("missions");

    String error = (String) request.getAttribute("error");

    String[] letters = {"A", "B", "C", "D"};
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Missions | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .missions-container {
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

        .question-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 28px;
            margin-bottom: 22px;
            box-shadow: 0 5px 18px rgba(15, 23, 42, 0.04);
        }

        .question-top {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .category-badge,
        .difficulty-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #eff6ff;
            color: #2563eb;
        }

        .difficulty-badge {
            background: #f1f5f9;
            color: #475569;
        }

        .question-card h2 {
            color: #172554;
            font-size: 21px;
            margin-bottom: 12px;
        }

        .question-description {
            color: #64748b;
            line-height: 1.7;
            margin-bottom: 22px;
            white-space: pre-wrap;
        }

        .option-label {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 9px;
            margin-bottom: 11px;
            cursor: pointer;
            transition: 0.2s;
        }

        .option-label:hover {
            background: #eff6ff;
            border-color: #93c5fd;
        }

        .option-label input {
            margin-top: 4px;
            accent-color: #2563eb;
        }

        .xp-info {
            color: #2563eb;
            font-weight: 600;
            margin: 17px 0;
        }

        .submit-answer {
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 22px;
            font-weight: 600;
            cursor: pointer;
        }

        .submit-answer:hover {
            background: #1d4ed8;
        }

        .message {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 22px;
        }

        .error-message {
            background: #fef2f2;
            color: #b91c1c;
        }

        .empty-message {
            background: white;
            padding: 35px;
            text-align: center;
            border-radius: 12px;
            color: #64748b;
        }

        @media (max-width: 600px) {
            .question-card {
                padding: 20px;
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
        <a href="<%= contextPath %>/mission-results.jsp">My Results</a>
        <a href="<%= contextPath %>/leaderboard">Leaderboard</a>
    </nav>

</header>

<main class="missions-container">

    <section class="page-heading">
        <p class="eyebrow">LEARN · PRACTICE · LEVEL UP</p>

        <h1>Programming Missions</h1>

        <p>
            Welcome, <%= WebUtil.esc(username) %>!
            Choose the correct answer, complete missions and earn XP.
        </p>
    </section>

    <% if (error != null) { %>

        <div class="message error-message">
            <%= WebUtil.esc(error) %>
        </div>

    <% } %>

    <% if (missions == null || missions.isEmpty()) { %>

        <div class="empty-message">
            <h2>All missions completed!</h2>
            <p>Great work! Check back later for more programming missions.</p>
        </div>

    <% } else { %>

        <% for (Map<String, Object> mission : missions) {

            Object id = mission.get("id");
            String title = String.valueOf(mission.get("title"));
            String description = String.valueOf(mission.get("description"));
            String category = String.valueOf(mission.get("category"));
            String difficulty = String.valueOf(mission.get("difficulty"));

            String[] options = {
                String.valueOf(mission.get("option_a")),
                String.valueOf(mission.get("option_b")),
                String.valueOf(mission.get("option_c")),
                String.valueOf(mission.get("option_d"))
            };

            Object xpObject = mission.get("xp_reward");
            int xp = xpObject instanceof Number
                ? ((Number) xpObject).intValue()
                : 0;
        %>

        <article class="question-card">

            <div class="question-top">

                <span class="category-badge">
                    <%= WebUtil.esc(category) %>
                </span>

                <span class="difficulty-badge">
                    <%= WebUtil.esc(difficulty) %>
                </span>

            </div>

            <h2><%= WebUtil.esc(title) %></h2>

            <p class="question-description">
                <%= WebUtil.esc(description) %>
            </p>

            <!-- Submit answer to SubmitAnswerServlet -->
            <form action="<%= contextPath %>/submit-answer"
                  method="post">

                <input type="hidden"
                       name="missionId"
                       value="<%= id %>">

                <% for (int i = 0; i < options.length; i++) { %>

                    <label class="option-label">

                        <input type="radio"
                               name="selected_answer"
                               value="<%= letters[i] %>"
                               required>

                        <span>
                            <strong><%= letters[i] %>.</strong>
                            <%= WebUtil.esc(options[i]) %>
                        </span>

                    </label>

                <% } %>

                <div class="xp-info">
                    Reward: <%= xp %> XP
                </div>

                <button type="submit" class="submit-answer">
                    Submit Answer
                </button>

            </form>

        </article>

        <% } %>

    <% } %>

</main>

<footer class="footer">
    <div class="footer-content">
        CodeQuest · Learn · Practice · Level Up
    </div>
</footer>

</body>
</html>
