
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.util.DBConnection" %>

<%
    String contextPath = request.getContextPath();

    // Check student session
    HttpSession studentSession = request.getSession(false);

    if (studentSession == null ||
        studentSession.getAttribute("userId") == null) {

        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    int studentId = (Integer) studentSession.getAttribute("userId");

    String username =
        (String) studentSession.getAttribute("username");

    if (username == null) {
        username = "Student";
    }

    // Logout
    if ("true".equals(request.getParameter("logout"))) {
        studentSession.invalidate();
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    int totalXP = 0;
    int currentLevel = 1;
    int completedMissions = 0;

    // Load student information
    try (Connection con = DBConnection.getConnection()) {

        String userSql =
            "SELECT xp, level FROM users WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(userSql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalXP = rs.getInt("xp");
                    currentLevel = rs.getInt("level");
                } else {
                    studentSession.invalidate();
                    response.sendRedirect(contextPath + "/login.jsp");
                    return;
                }
            }
        }

        // Count completed missions
        String missionSql =
            "SELECT COUNT(*) FROM mission_submissions " +
            "WHERE user_id = ? AND is_correct = 1";

        try (PreparedStatement ps = con.prepareStatement(missionSql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    completedMissions = rs.getInt(1);
                }
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("dashboardError",
            "Unable to load dashboard information.");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard | CodeQuest</title>

    <!-- Main CSS -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>

        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .dashboard-container {
            max-width: 1150px;
            margin: 45px auto;
            padding: 0 24px;
        }

        .welcome-section {
            margin-bottom: 30px;
        }

        .welcome-section h1 {
            font-size: 34px;
            color: #172554;
            margin: 12px 0;
        }

        .welcome-section p {
            color: #64748b;
        }

        .student-profile {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            margin-bottom: 35px;
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 21px;
            font-weight: bold;
        }

        .student-details strong {
            color: #172554;
            font-size: 17px;
        }

        .student-details span {
            display: block;
            color: #64748b;
            font-size: 13px;
            margin-top: 5px;
        }

        .section-title {
            font-size: 22px;
            color: #172554;
            margin-bottom: 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border: 1px solid #e2e8f0;
            border-radius: 13px;
            box-shadow: 0 5px 18px rgba(15, 23, 42, 0.04);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eff6ff;
            border-radius: 12px;
            font-size: 23px;
            margin-bottom: 18px;
        }

        .stat-card h3 {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 30px;
            font-weight: 700;
            color: #172554;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .action-card {
            background: white;
            padding: 27px;
            border: 1px solid #e2e8f0;
            border-radius: 13px;
            transition: 0.2s ease;
        }

        .action-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.07);
        }

        .action-card h3 {
            color: #172554;
            margin-bottom: 10px;
        }

        .action-card p {
            color: #64748b;
            line-height: 1.6;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .action-link {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .dashboard-error {
            background: #fef2f2;
            color: #b91c1c;
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .logout-link {
            color: #dc2626 !important;
        }

        .dashboard-footer {
            text-align: center;
            padding: 30px;
            margin-top: 55px;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
        }

        @media(max-width: 750px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 520px) {
            .stats-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }

            .welcome-section h1 {
                font-size: 27px;
            }
        }

    </style>

</head>

<body>

    <!-- Navigation -->

    <header class="navbar">

        <a href="<%= contextPath %>/index.html"
           class="brand">
            CodeQuest
        </a>

        <nav class="nav-links">

            <a href="<%= contextPath %>/index.html">
                Home
            </a>

            <a href="<%= contextPath %>/missions">
                Missions
            </a>

            <a href="<%= contextPath %>/leaderboard">
                Leaderboard
            </a>

            <a href="<%= contextPath %>/dashboard.jsp?logout=true"
               class="logout-link">
                Logout
            </a>

        </nav>

    </header>


    <!-- Dashboard Content -->

    <main class="dashboard-container">

        <section class="welcome-section">

            <p class="eyebrow">
                STUDENT DASHBOARD
            </p>

            <h1>
                Welcome back, <%= username %>!
            </h1>

            <p>
                Keep learning, solve questions and improve your coding skills.
            </p>

        </section>


        <!-- Student Profile -->

        <div class="student-profile">

            <div class="student-avatar">
                <%= username.substring(0, 1).toUpperCase() %>
            </div>

            <div class="student-details">

                <strong>
                    <%= username %>
                </strong>

                <span>
                    CodeQuest Student
                </span>

            </div>

        </div>


        <% if (request.getAttribute("dashboardError") != null) { %>

            <div class="dashboard-error">
                <%= request.getAttribute("dashboardError") %>
            </div>

        <% } %>


        <!-- Statistics -->

        <h2 class="section-title">
            Your Progress
        </h2>

        <section class="stats-grid">


            <div class="stat-card">

                <div class="stat-icon">⭐</div>

                <h3>Total Experience Points</h3>

                <div class="stat-value">
                    <%= totalXP %>
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">🏆</div>

                <h3>Current Level</h3>

                <div class="stat-value">
                    <%= currentLevel %>
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">✅</div>

                <h3>Completed Missions</h3>

                <div class="stat-value">
                    <%= completedMissions %>
                </div>

            </div>


        </section>


        <!-- Student Actions -->

        <h2 class="section-title">
            Continue Learning
        </h2>

        <section class="actions-grid">


            <article class="action-card">

                <h3>🎯 Explore Missions</h3>

                <p>
                    Practice programming through exciting
                    coding questions and missions.
                </p>

                <a href="<%= contextPath %>/missions"
                   class="action-link">
                    Start Practicing →
                </a>

            </article>


            <article class="action-card">

                <h3>🏅 Leaderboard</h3>

                <p>
                    Check your ranking and compare your
                    XP with other students.
                </p>

                <a href="<%= contextPath %>/leaderboard"
                   class="action-link">
                    View Rankings →
                </a>

            </article>


        </section>

    </main>


    <!-- Footer -->

    <footer class="dashboard-footer">

        CodeQuest · Learn · Practice · Level Up

    </footer>

</body>

</html>
