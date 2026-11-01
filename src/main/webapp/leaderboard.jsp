
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.codequest.util.WebUtil" %>

<%
    String contextPath = request.getContextPath();

    List<Map<String, Object>> leaderboard =
        (List<Map<String, Object>>) request.getAttribute("leaderboard");

    String error = (String) request.getAttribute("error");

    if (leaderboard == null) {
        leaderboard = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Leaderboard | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        .leaderboard-container {
            max-width: 1000px;
            margin: 60px auto;
            padding: 0 24px;
        }

        .leaderboard-heading {
            text-align: center;
            margin-bottom: 35px;
        }

        .leaderboard-heading h1 {
            font-size: 36px;
            color: #172554;
            margin-bottom: 10px;
        }

        .leaderboard-heading p {
            color: #64748b;
            font-size: 16px;
        }

        .leaderboard-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.05);
        }

        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
        }

        .leaderboard-table th {
            background: #f1f5f9;
            color: #475569;
            text-align: left;
            padding: 16px;
            font-size: 14px;
        }

        .leaderboard-table td {
            padding: 17px 16px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
        }

        .leaderboard-table tr:last-child td {
            border-bottom: none;
        }

        .rank-number {
            font-weight: 700;
            color: #2563eb;
        }

        .xp-badge {
            background: #eff6ff;
            color: #2563eb;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
        }

        .empty-message {
            text-align: center;
            padding: 35px;
            color: #64748b;
        }

        .error-message {
            text-align: center;
            padding: 15px;
            color: #b91c1c;
        }

        .page-footer {
            text-align: center;
            padding: 25px;
            color: #64748b;
            margin-top: 60px;
        }

        @media (max-width: 600px) {
            .leaderboard-card {
                padding: 10px;
                overflow-x: auto;
            }

            .leaderboard-heading h1 {
                font-size: 28px;
            }

            .leaderboard-table th,
            .leaderboard-table td {
                padding: 12px 10px;
                white-space: nowrap;
            }
        }
    </style>
</head>

<body>

    <header class="navbar">

        <a href="<%= contextPath %>/index.html" class="brand">
            CodeQuest
        </a>

        <nav class="nav-links">
            <a href="<%= contextPath %>/index.html">Home</a>
            <a href="<%= contextPath %>/missions">Missions</a>
            <a href="<%= contextPath %>/leaderboard">Leaderboard</a>
            <a href="<%= contextPath %>/login.jsp">Login</a>
        </nav>

    </header>

    <main class="leaderboard-container">

        <div class="leaderboard-heading">
            <p class="eyebrow">CODEQUEST COMMUNITY</p>

            <h1>Leaderboard</h1>

            <p>See who's leading the coding journey.</p>
        </div>

        <div class="leaderboard-card">

            <table class="leaderboard-table">

                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Student</th>
                        <th>Total XP</th>
                        <th>Level</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (error != null) { %>

                        <tr>
                            <td colspan="4" class="error-message">
                                <%= WebUtil.esc(error) %>
                            </td>
                        </tr>

                    <% } else if (leaderboard.isEmpty()) { %>

                        <tr>
                            <td colspan="4" class="empty-message">
                                No students found yet. Start solving missions!
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Map<String, Object> student : leaderboard) { %>

                            <tr>

                                <td class="rank-number">
                                    #<%= student.get("rank") %>
                                </td>

                                <td>
                                    <strong>
                                        <%= WebUtil.esc(
                                            String.valueOf(student.get("username"))
                                        ) %>
                                    </strong>
                                </td>

                                <td>
                                    <span class="xp-badge">
                                        <%= student.get("xp") %> XP
                                    </span>
                                </td>

                                <td>
                                    Level <%= student.get("level") %>
                                </td>

                            </tr>

                        <% } %>

                    <% } %>

                </tbody>

            </table>

        </div>

    </main>

    <footer class="page-footer">
        CodeQuest &middot; Learn &middot; Practice &middot; Level Up
    </footer>

</body>
</html>
