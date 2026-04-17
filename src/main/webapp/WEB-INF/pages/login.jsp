<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login - DigitalBazaar</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/styles.css">
</head>
<body>
	<div class="container">

    <!-- LEFT PANEL -->
    <div class="left-panel">
        <h1 class="logo">DigitalBazaar</h1>
        <h2>Welcome Back</h2>
        <p>Login to access your account and continue exploring the marketplace.</p>
    </div>

    <!-- RIGHT PANEL -->
    <div class="right-panel">
        <h2>Login</h2>
        <p class="subtitle">Enter your credentials to continue</p>
        
        <% if ("registered".equals(request.getParameter("success"))) { %>
                <p style="color:#22d3ee; margin-bottom:15px;">
                    ✓ Registered successfully! Please login.
                </p>
            <% } %>

            <!-- ✅ ERROR MESSAGE FROM CONTROLLER -->
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <p style="color:red; margin-bottom:15px;">
                    ⚠ <%= error %>
                </p>
            <% } %>

        <form action="<%=request.getContextPath()%>/login" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit">Login</button>
        </form>

        <p class="switch">
            Don't have an account? <a href="<%=request.getContextPath()%>/register">Register</a>
        </p>
    </div>

</div>
</body>
</html>