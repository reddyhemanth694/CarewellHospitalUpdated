<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%
    /* Friendly error page used for 404 / 403 / 500 (configured in WEB-INF/web.xml).
       Never shows stack traces or server version to visitors. */
    int status = response.getStatus();
    Object code = request.getAttribute("jakarta.servlet.error.status_code");
    if (code instanceof Integer) {
        status = (Integer) code;
    }

    String title;
    String message;
    if (status == 404) {
        title = "Page not found";
        message = "The page you are looking for doesn't exist or may have been moved.";
    } else if (status == 403) {
        title = "Access denied";
        message = "You don't have permission to view this page.";
    } else {
        status = status >= 400 ? status : 500;
        title = "Something went wrong";
        message = "We hit an unexpected problem. Please try again in a moment.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex">
    <title><%= title %> | CareWell Hospital</title>
    <link rel="icon" type="image/svg+xml"
          href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%231266e8'/%3E%3Cpath d='M32 50s-16-9.6-16-21.2C16 22.3 20.7 18 26 18c2.9 0 4.9 1.4 6 3.3 1.1-1.9 3.1-3.3 6-3.3 5.3 0 10 4.3 10 10.8C48 40.4 32 50 32 50z' fill='%23fff'/%3E%3C/svg%3E">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            font-family: "Segoe UI", Arial, sans-serif;
            color: #263852;
            background: linear-gradient(120deg, #f8fbff 0%, #edf5ff 100%);
        }
        .error-card {
            width: 100%;
            max-width: 480px;
            padding: 44px 36px;
            text-align: center;
            background: #fff;
            border: 1px solid #e3ebf5;
            border-radius: 22px;
            box-shadow: 0 14px 40px rgba(24, 59, 105, 0.08);
        }
        .error-code {
            color: #1266e8;
            font-size: 64px;
            font-weight: 800;
            line-height: 1;
            letter-spacing: -2px;
        }
        h1 {
            margin: 14px 0 10px;
            color: #102747;
            font-size: 24px;
        }
        p {
            margin-bottom: 28px;
            color: #6c7b91;
            font-size: 14px;
            line-height: 1.7;
        }
        .actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
        }
        .actions a {
            padding: 12px 20px;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
        }
        .primary { background: #1266e8; color: #fff; }
        .primary:hover { background: #084bb5; }
        .secondary { border: 1px solid #dce5f0; color: #102747; }
        .secondary:hover { border-color: #1266e8; color: #1266e8; }
    </style>
</head>
<body>
    <main class="error-card">
        <div class="error-code"><%= status %></div>
        <h1><%= title %></h1>
        <p><%= message %></p>
        <div class="actions">
            <a class="primary" href="<%= request.getContextPath() %>/index.jsp">Go to Home</a>
            <a class="secondary" href="<%= request.getContextPath() %>/login.jsp">Sign in</a>
        </div>
    </main>
</body>
</html>
