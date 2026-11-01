
<%@ page import="com.codequest.util.WebUtil" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Student Registration | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <!-- Navigation -->
    <header class="navbar">

        <a href="<%= request.getContextPath() %>/index.html"
           class="brand">

            <span class="brand-icon">&lt;/&gt;</span>
            CodeQuest

        </a>

        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/index.html">Home</a>
            <a href="<%= request.getContextPath() %>/missions">Missions</a>
            <a href="<%= request.getContextPath() %>/leaderboard">Leaderboard</a>
        </nav>

        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/login.jsp"
               class="login-link">Login</a>
        </div>

    </header>

    <!-- Registration Form -->
    <main class="container">

        <div class="auth-container">

            <div style="text-align: center; margin-bottom: 28px;">

                <span class="eyebrow">JOIN CODEQUEST</span>

                <h1 style="color: #172554; margin-top: 12px;">
                    Create Your Account
                </h1>

                <p style="color: #64748b; margin-top: 8px;">
                    Start your programming journey today.
                </p>

            </div>

            <!-- Display error message -->
            <% if (request.getAttribute("error") != null) { %>

                <div class="error">
                    <%= WebUtil.esc(
                        String.valueOf(request.getAttribute("error"))
                    ) %>
                </div>

            <% } %>

            <form action="<%= request.getContextPath() %>/register"
                  method="post">

                <div class="form-group">

                    <label for="username">Username</label>

                    <input type="text"
                           id="username"
                           name="username"
                           placeholder="Choose a username"
                           required>

                </div>

                <div class="form-group">

                    <label for="email">Email Address</label>

                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           required>

                </div>

                <div class="form-group">

                    <label for="password">Password</label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Create a password"
                           minlength="8"
                           required>

                </div>

                <div class="form-group">

                    <label for="confirmPassword">Confirm Password</label>

                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="Re-enter your password"
                           minlength="8"
                           required>

                </div>

                <button type="submit"
                        class="btn btn-primary"
                        style="width: 100%;">

                    Create Account

                </button>

            </form>

            <p style="text-align: center; margin-top: 22px; font-size: 14px;">

                Already have an account?

                <a href="<%= request.getContextPath() %>/login.jsp"
                   style="color: #2563eb; font-weight: 600;">

                    Login here

                </a>

            </p>

        </div>

    </main>

    <!-- Footer -->
    <footer class="footer">

        <div class="container footer-content">

            <a href="<%= request.getContextPath() %>/index.html"
               class="brand">

                <span class="brand-icon">&lt;/&gt;</span>
                CodeQuest

            </a>

            <p>Learn &middot; Practice &middot; Level Up</p>

            <p>&copy; 2026 CodeQuest</p>

        </div>

    </footer>

</body>
</html>
