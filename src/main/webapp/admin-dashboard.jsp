
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.util.WebUtil" %>

<%
    // Check admin session
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    // Get admin username
    String adminUsername =
        (String) adminSession.getAttribute("adminUsername");

    if (adminUsername == null || adminUsername.trim().isEmpty()) {
        adminUsername = "Admin";
    }

    String contextPath = request.getContextPath();
    String initial = adminUsername.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .admin-container {
            max-width: 1150px;
            margin: 50px auto;
            padding: 0 25px;
        }

        .welcome-section {
            margin-bottom: 30px;
        }

        .welcome-section h1 {
            font-size: 34px;
            color: #172554;
            margin: 10px 0;
        }

        .welcome-section p {
            color: #64748b;
        }

        .profile-box {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            margin-bottom: 35px;
        }

        .profile-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
        }

        .profile-details strong {
            color: #172554;
            font-size: 16px;
        }

        .profile-details span {
            display: block;
            color: #64748b;
            font-size: 13px;
            margin-top: 4px;
        }

        .section-title {
            font-size: 22px;
            color: #172554;
            margin-bottom: 20px;
        }

        .admin-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        .dashboard-card {
            background: white;
            padding: 28px;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            transition: 0.2s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
        }

        .card-icon {
            width: 50px;
            height: 50px;
            background: #eff6ff;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .dashboard-card h3 {
            color: #172554;
            font-size: 19px;
            margin-bottom: 10px;
        }

        .dashboard-card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.7;
            min-height: 70px;
        }

        .card-link {
            display: inline-block;
            margin-top: 15px;
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }

        .card-link:hover {
            text-decoration: underline;
        }

        .admin-message {
            margin-top: 30px;
            padding: 22px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 12px;
            color: #1e40af;
            line-height: 1.7;
        }

        .admin-message p {
            margin-top: 8px;
        }

        .logout-form {
            display: inline-flex;
            margin: 0;
        }

        .logout-btn {
            background: transparent;
            border: none;
            color: #dc2626;
            font-size: inherit;
            font-family: inherit;
            font-weight: 500;
            cursor: pointer;
            padding: 8px 12px;
        }

        .logout-btn:hover {
            color: #991b1b;
        }

        .dashboard-footer {
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
        }

        @media(max-width: 750px) {
            .admin-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 520px) {
            .admin-grid {
                grid-template-columns: 1fr;
            }

            .welcome-section h1 {
                font-size: 27px;
            }

            .admin-container {
                margin-top: 30px;
                padding: 0 15px;
            }
        }
    </style>
</head>

<body>

    <!-- Navigation Bar -->
    <header class="navbar">

        <a href="<%= contextPath %>/index.html" class="brand">
            CodeQuest
        </a>

        <nav class="nav-links">

            <a href="<%= contextPath %>/index.html">
                Home
            </a>

            <!-- Admin should use the question-management route -->
            <a href="<%= contextPath %>/view-questions">
                Manage Missions
            </a>

            <a href="<%= contextPath %>/leaderboard">
                Leaderboard
            </a>

            <form action="<%= contextPath %>/admin-logout"
                  method="post"
                  class="logout-form">

                <button type="submit" class="logout-btn">
                    Logout
                </button>

            </form>

        </nav>
    </header>


    <!-- Main Dashboard -->
    <main class="admin-container">

        <!-- Welcome Section -->
        <section class="welcome-section">

            <p class="eyebrow">
                ADMINISTRATION PANEL
            </p>

            <h1>Admin Dashboard</h1>

            <p>
                Manage your CodeQuest programming learning platform.
            </p>

        </section>


        <!-- Admin Profile -->
        <div class="profile-box">

            <div class="profile-icon">
                <%= WebUtil.esc(initial) %>
            </div>

            <div class="profile-details">

                <strong>
                    Welcome, <%= WebUtil.esc(adminUsername) %>
                </strong>

                <span>
                    Administrator Account
                </span>

            </div>

        </div>


        <!-- Management Section -->
        <h2 class="section-title">
            Management
        </h2>


        <section class="admin-grid">

            <!-- Manage Questions -->
            <article class="dashboard-card">

                <div class="card-icon">
                    📝
                </div>

                <h3>Manage Questions</h3>

                <p>
                    Add, view and manage programming questions
                    for students.
                </p>

                <a href="<%= contextPath %>/view-questions"
                   class="card-link">
                    Manage Questions →
                </a>

            </article>


            <!-- Manage Missions -->
            <article class="dashboard-card">

                <div class="card-icon">
                    🎯
                </div>

                <h3>Manage Missions</h3>

                <p>
                    View and manage programming missions
                    available on the learning platform.
                </p>

                <a href="<%= contextPath %>/view-questions"
                   class="card-link">
                    Manage Missions →
                </a>

            </article>


            <!-- Leaderboard -->
            <article class="dashboard-card">

                <div class="card-icon">
                    🏆
                </div>

                <h3>Leaderboard</h3>

                <p>
                    Check student rankings and their
                    earned experience points.
                </p>

                <a href="<%= contextPath %>/leaderboard"
                   class="card-link">
                    View Leaderboard →
                </a>

            </article>

        </section>


        <!-- Admin Information -->
        <div class="admin-message">

            <strong>Administrator Access</strong>

            <p>
                You are successfully logged in to the
                CodeQuest administration panel.
                Use the management sections to maintain
                your programming learning platform.
            </p>

        </div>

    </main>


    <!-- Footer -->
    <footer class="dashboard-footer">
        CodeQuest · Learn · Practice · Level Up
    </footer>

</body>
</html>
