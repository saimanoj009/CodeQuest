
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");

    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(contextPath + "/admin-dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Login | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        body {
            background: #f8fafc;
            color: #1e293b;
        }

        .admin-login-container {
            max-width: 430px;
            margin: 75px auto;
            padding: 35px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.05);
        }

        .login-heading {
            text-align: center;
            margin-bottom: 28px;
        }

        .login-heading h1 {
            color: #172554;
            font-size: 28px;
            margin: 12px 0;
        }

        .login-heading p {
            color: #64748b;
            font-size: 14px;
        }

        .admin-icon {
            width: 55px;
            height: 55px;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            font-size: 25px;
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

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 15px;
        }

        .form-group input:focus {
            outline: none;
            border-color: #2563eb;
        }

        .login-button {
            width: 100%;
            padding: 13px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }

        .login-button:hover {
            background: #1d4ed8;
        }

        .error-message {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .back-link {
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
        }

        .back-link a {
            color: #2563eb;
            text-decoration: none;
        }

        .login-footer {
            text-align: center;
            color: #64748b;
            margin-top: 25px;
            font-size: 13px;
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
        </nav>
    </header>

    <main class="admin-login-container">

        <div class="login-heading">

            <div class="admin-icon">🔐</div>

            <h1>Admin Login</h1>

            <p>Sign in to access the CodeQuest administration panel.</p>

        </div>

        <% if (error != null) { %>

            <div class="error-message">
                <%= error %>
            </div>

        <% } %>

        <form action="<%= contextPath %>/admin-login" method="post">

            <div class="form-group">
                <label for="username">Admin Username</label>

                <input type="text"
                       id="username"
                       name="username"
                       placeholder="Enter admin username"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Enter admin password"
                       required>
            </div>

            <button type="submit" class="login-button">
                Login as Admin
            </button>

        </form>

        <div class="back-link">
            <a href="<%= contextPath %>/index.html">
                ← Back to Home
            </a>
        </div>

    </main>

    <footer class="login-footer">
        CodeQuest · Learn · Practice · Level Up
    </footer>

</body>
</html>
