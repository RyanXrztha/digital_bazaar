<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register - DigitalBazaar</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/styles.css">
</head>
<body>
	<div class="container">

    <!-- LEFT PANEL -->
    <div class="left-panel">
        <h1 class="logo">DigitalBazaar</h1>
        <h2>Create Your Account</h2>
        <p>Join DigitalBazaar and start your journey today.</p>
    </div>

    <!-- RIGHT PANEL -->
    <div class="right-panel">
        <h2>Register</h2>
        <p class="subtitle">Fill in your details to create an account</p>
        
        <!-- ✅ ERROR MESSAGE FROM CONTROLLER -->
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <p style="color:red; margin-bottom:15px;">
                    ⚠ <%= error %>
                </p>
            <% } %>

        <form action="<%=request.getContextPath()%>/register" method="post">
            <input type="text" name="fullname" placeholder="Full Name" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="confirmPassword" placeholder="Confirm Password" required>

            <button type="submit">Create Account</button>
        </form>

        <p class="switch">
            Already have an account? <a href="<%=request.getContextPath()%>/login">Login</a>
        </p>
    </div>

</div>
</body>
</html>