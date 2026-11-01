
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.util.DBConnection" %>

<%!
    private String escapeHTML(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();

    // Admin session protection
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {

        response.sendRedirect(contextPath + "/admin-login.jsp");
        return;
    }

    String adminUsername =
        (String) adminSession.getAttribute("adminUsername");

    if (adminUsername == null) {
        adminUsername = "Admin";
    }

    String search = request.getParameter("search");

    if (search == null) {
        search = "";
    }

    int totalQuestions = 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>View Questions | CodeQuest</title>

    <!-- Main CSS -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>

        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .page-container {
            max-width: 1200px;
            margin: 45px auto;
            padding: 0 22px;
        }

        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .page-heading h1 {
            color: #172554;
            font-size: 32px;
            margin: 10px 0;
        }

        .page-heading p {
            color: #64748b;
        }

        .questions-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(15, 23, 42, 0.04);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 22px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            flex: 1;
            max-width: 500px;
        }

        .search-form input {
            flex: 1;
            min-width: 0;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
        }

        .search-form button {
            padding: 12px 18px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }

        .question-count {
            color: #64748b;
            font-size: 14px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .questions-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        .questions-table th {
            background: #f1f5f9;
            color: #475569;
            text-align: left;
            padding: 15px;
            font-size: 13px;
            white-space: nowrap;
        }

        .questions-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            font-size: 14px;
            vertical-align: top;
        }

        .questions-table tr:hover td {
            background: #f8fafc;
        }

        .question-title {
            font-weight: 600;
            color: #172554;
            min-width: 160px;
        }

        .description {
            max-width: 220px;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 12px;
            font-weight: 600;
        }

        .difficulty {
            background: #f1f5f9;
            color: #475569;
        }

        .answer {
            min-width: 130px;
            line-height: 1.8;
        }

        .correct-answer {
            color: #15803d;
            font-weight: 700;
        }

        .xp {
            color: #2563eb;
            font-weight: 700;
            white-space: nowrap;
        }

        .empty-message {
            text-align: center;
            padding: 35px;
            color: #64748b;
        }

        .add-button {
            text-decoration: none;
        }

        .clear-link {
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
            align-self: center;
        }

        .page-footer {
            text-align: center;
            padding: 30px;
            margin-top: 45px;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
        }

        @media(max-width: 600px) {
            .page-heading h1 {
                font-size: 26px;
            }

            .questions-card {
                padding: 15px;
            }

            .search-form {
                max-width: 100%;
            }
        }

    </style>

</head>

<body>

    <!-- Navigation -->

    <header class="navbar">

        <a href="<%= contextPath %>/admin-dashboard.jsp"
           class="brand">
            CodeQuest
        </a>

        <nav class="nav-links">

            <a href="<%= contextPath %>/admin-dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= contextPath %>/add-question.jsp">
                Add Question
            </a>

            <a href="<%= contextPath %>/view-questions.jsp">
                View Questions
            </a>

            <a href="<%= contextPath %>/admin-dashboard.jsp?logout=true"
               style="color:#dc2626;">
                Logout
            </a>

        </nav>

    </header>


    <!-- Main Content -->

    <main class="page-container">

        <section class="page-heading">

            <div>
                <p class="eyebrow">QUESTION MANAGEMENT</p>

                <h1>All Questions</h1>

                <p>
                    Welcome, <%= escapeHTML(adminUsername) %>.
                    View all programming questions in CodeQuest.
                </p>
            </div>

            <a href="<%= contextPath %>/add-question.jsp"
               class="btn btn-primary add-button">
                + Add New Question
            </a>

        </section>


        <section class="questions-card">

            <div class="toolbar">

                <form action="<%= contextPath %>/view-questions.jsp"
                      method="get"
                      class="search-form">

                    <input type="text"
                           name="search"
                           placeholder="Search by title or category..."
                           value="<%= escapeHTML(search) %>">

                    <button type="submit">
                        Search
                    </button>

                    <% if (!search.isEmpty()) { %>
                        <a class="clear-link"
                           href="<%= contextPath %>/view-questions.jsp">
                            Clear
                        </a>
                    <% } %>

                </form>

                <span class="question-count">
                    Questions: <span id="questionCount">Loading...</span>
                </span>

            </div>


            <div class="table-wrapper">

                <table class="questions-table">

                    <thead>

                        <tr>
                            <th>ID</th>
                            <th>Question</th>
                            <th>Description</th>
                            <th>Category</th>
                            <th>Difficulty</th>
                            <th>Options</th>
                            <th>Correct Answer</th>
                            <th>XP</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        String sql =
                            "SELECT id, title, description, category, " +
                            "difficulty, option_a, option_b, option_c, " +
                            "option_d, correct_answer, xp_reward " +
                            "FROM missions ";

                        if (!search.trim().isEmpty()) {
                            sql +=
                                "WHERE title LIKE ? OR category LIKE ? ";
                        }

                        sql += "ORDER BY id DESC";

                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement ps =
                                 con.prepareStatement(sql)) {

                            if (!search.trim().isEmpty()) {
                                String searchValue =
                                    "%" + search.trim() + "%";

                                ps.setString(1, searchValue);
                                ps.setString(2, searchValue);
                            }

                            try (ResultSet rs = ps.executeQuery()) {

                                while (rs.next()) {

                                    totalQuestions++;

                                    int id = rs.getInt("id");

                                    String title =
                                        rs.getString("title");

                                    String description =
                                        rs.getString("description");

                                    String category =
                                        rs.getString("category");

                                    String difficulty =
                                        rs.getString("difficulty");

                                    String optionA =
                                        rs.getString("option_a");

                                    String optionB =
                                        rs.getString("option_b");

                                    String optionC =
                                        rs.getString("option_c");

                                    String optionD =
                                        rs.getString("option_d");

                                    String correctAnswer =
                                        rs.getString("correct_answer");

                                    int xp =
                                        rs.getInt("xp_reward");
                    %>

                        <tr>

                            <td><%= id %></td>

                            <td class="question-title">
                                <%= escapeHTML(title) %>
                            </td>

                            <td class="description">
                                <%= escapeHTML(description) %>
                            </td>

                            <td>
                                <span class="badge">
                                    <%= escapeHTML(category) %>
                                </span>
                            </td>

                            <td>
                                <span class="badge difficulty">
                                    <%= escapeHTML(difficulty) %>
                                </span>
                            </td>

                            <td class="answer">
                                A. <%= escapeHTML(optionA) %><br>
                                B. <%= escapeHTML(optionB) %><br>
                                C. <%= escapeHTML(optionC) %><br>
                                D. <%= escapeHTML(optionD) %>
                            </td>

                            <td class="correct-answer">
                                <%= escapeHTML(correctAnswer) %>
                            </td>

                            <td class="xp">
                                <%= xp %> XP
                            </td>

                        </tr>

                    <%
                                }
                            }

                        } catch (SQLException e) {
                            e.printStackTrace();
                    %>

                        <tr>
                            <td colspan="8" class="empty-message">
                                Unable to load questions.
                                Please check your database table and columns.
                            </td>
                        </tr>

                    <%
                        }

                        if (totalQuestions == 0) {
                    %>

                        <tr>
                            <td colspan="8" class="empty-message">
                                No questions found.
                                Add your first programming question!
                            </td>
                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

            <script>
                document.getElementById("questionCount").textContent =
                    "<%= totalQuestions %>";
            </script>

        </section>

    </main>


    <!-- Footer -->

    <footer class="page-footer">
        CodeQuest · Learn · Practice · Level Up
    </footer>

</body>
</html>
