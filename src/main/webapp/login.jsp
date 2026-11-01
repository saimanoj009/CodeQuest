
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.codequest.util.WebUtil" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Student Login | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <!-- Navigation Bar -->
    <header class="navbar">

        <a href="<%= request.getContextPath() %>/index.html"
           class="brand">

            <span class="brand-icon">&lt;/&gt;</span>
            CodeQuest

        </a>

        <nav class="nav-links">

            <a href="<%= request.getContextPath() %>/index.html">
                Home
            </a>

            <a href="<%= request.getContextPath() %>/missions">
                Missions
            </a>

            <a href="<%= request.getContextPath() %>/leaderboard">
                Leaderboard
            </a>

        </nav>

        <div class="nav-actions">

            <a href="<%= request.getContextPath() %>/register.jsp"
               class="btn btn-primary">
                Register
            </a>

        </div>

    </header>


    <!-- Login Section -->
    <main class="container">

        <div class="auth-container">

            <h1 style="color:#172554; margin-bottom:8px;">
                Welcome Back!
            </h1>

            <p style="color:#64748b; margin-bottom:28px;">
                Login to continue your coding journey.
            </p>


            <!-- Error Message -->
            <%
                String error = (String) request.getAttribute("error");

                if (error != null) {
            %>

                <div class="error">
                    <%= WebUtil.esc(error) %>
                </div>

            <%
                }
            %>


            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/login"
                  method="post">

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        required>

                </div>


                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>


                <button type="submit"
                        class="btn btn-primary"
                        style="width:100%;">

                    Login

                </button>

            </form>


            <!-- Register Link -->
            <p style="text-align:center; margin-top:22px; font-size:14px;">

                Don't have an account?

                <a href="<%= request.getContextPath() %>/register.jsp"
                   style="color:#2563eb; font-weight:600;">

                    Register here

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

            <p>Learn · Practice · Level Up</p>

            <p>© 2026 CodeQuest</p>

        </div>

    </footer>

</body>
</html>
