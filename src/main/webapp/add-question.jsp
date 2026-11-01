
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Add Question | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .page-container {
            max-width: 850px;
            margin: 45px auto;
            padding: 0 20px;
        }

        .page-heading {
            margin-bottom: 25px;
        }

        .page-heading h1 {
            color: #172554;
            font-size: 30px;
            margin: 10px 0;
        }

        .page-heading p {
            color: #64748b;
        }

        .question-card {
            background: #ffffff;
            padding: 32px;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: 0 6px 22px rgba(15, 23, 42, 0.05);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #334155;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            background: white;
            color: #1e293b;
            box-sizing: border-box;
        }

        .form-group textarea {
            min-height: 110px;
            resize: vertical;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.10);
        }

        .form-section-title {
            color: #172554;
            font-size: 18px;
            margin: 25px 0 18px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        .message {
            padding: 13px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .error-message {
            background: #fef2f2;
            color: #b91c1c;
        }

        .success-message {
            background: #f0fdf4;
            color: #15803d;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .cancel-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 20px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            text-decoration: none;
            color: #334155;
            font-weight: 600;
        }

        @media(max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .question-card {
                padding: 20px;
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
            <a href="<%= contextPath %>/admin-dashboard.jsp">Dashboard</a>
            <a href="<%= contextPath %>/missions">Missions</a>
            <a href="<%= contextPath %>/leaderboard">Leaderboard</a>
        </nav>

    </header>

    <!-- Main Content -->
    <main class="page-container">

        <section class="page-heading">
            <p class="eyebrow">QUESTION MANAGEMENT</p>
            <h1>Add New Question</h1>
            <p>Create a multiple-choice programming question for students.</p>
        </section>

        <div class="question-card">

            <% if (error != null) { %>
                <div class="message error-message">
                    <%= error %>
                </div>
            <% } %>

            <% if (success != null) { %>
                <div class="message success-message">
                    <%= success %>
                </div>
            <% } %>

            <!-- Form -->
            <form action="<%= contextPath %>/add-question"
                  method="post">

                <h2 class="form-section-title">Question Details</h2>

                <div class="form-group">
                    <label for="title">Question Title</label>
                    <input type="text"
                           id="title"
                           name="title"
                           placeholder="Enter question title"
                           maxlength="150"
                           required>
                </div>

                <div class="form-group">
                    <label for="description">Question Description</label>
                    <textarea id="description"
                              name="description"
                              placeholder="Enter the question details..."
                              required></textarea>
                </div>

                <div class="form-row">

                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select Category</option>
                            <option value="Java">Java</option>
                            <option value="Python">Python</option>
                            <option value="SQL">SQL</option>
                            <option value="DSA">Data Structures</option>
                            <option value="Web">Web Development</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="difficulty">Difficulty</label>
                        <select id="difficulty"
                                name="difficulty"
                                required>
                            <option value="">Select Difficulty</option>
                            <option value="Easy">Easy</option>
                            <option value="Medium">Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>

                </div>

                <h2 class="form-section-title">Answer Options</h2>

                <div class="form-group">
                    <label for="option_a">Option A</label>
                    <input type="text"
                           id="option_a"
                           name="option_a"
                           placeholder="Enter option A"
                           maxlength="255"
                           required>
                </div>

                <div class="form-group">
                    <label for="option_b">Option B</label>
                    <input type="text"
                           id="option_b"
                           name="option_b"
                           placeholder="Enter option B"
                           maxlength="255"
                           required>
                </div>

                <div class="form-group">
                    <label for="option_c">Option C</label>
                    <input type="text"
                           id="option_c"
                           name="option_c"
                           placeholder="Enter option C"
                           maxlength="255"
                           required>
                </div>

                <div class="form-group">
                    <label for="option_d">Option D</label>
                    <input type="text"
                           id="option_d"
                           name="option_d"
                           placeholder="Enter option D"
                           maxlength="255"
                           required>
                </div>

                <div class="form-row">

                    <div class="form-group">
                        <label for="correct_answer">
                            Correct Answer
                        </label>

                        <select id="correct_answer"
                                name="correct_answer"
                                required>
                            <option value="">Select Correct Answer</option>
                            <option value="A">Option A</option>
                            <option value="B">Option B</option>
                            <option value="C">Option C</option>
                            <option value="D">Option D</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="xp_reward">XP Reward</label>
                        <input type="number"
                               id="xp_reward"
                               name="xp_reward"
                               min="1"
                               max="1000"
                               value="10"
                               required>
                    </div>

                </div>

                <div class="form-actions">

                    <button type="submit"
                            class="btn btn-primary">
                        Add Question
                    </button>

                    <a href="<%= contextPath %>/admin-dashboard.jsp"
                       class="cancel-link">
                        Cancel
                    </a>

                </div>

            </form>

        </div>

    </main>

    <footer class="footer">
        <div class="footer-content">
            CodeQuest · Learn · Practice · Level Up
        </div>
    </footer>

</body>
</html>
