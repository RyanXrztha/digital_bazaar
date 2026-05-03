<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Access Line - DigitalBazaar</title>
</head>
<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', sans-serif;
}

/* BODY */
body {
    height: 100vh;
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    display: flex;
    justify-content: center;
    align-items: center;
}

/* CONTAINER (THIS WAS MISSING ❗) */
.container {
    width: 950px;
    height: 520px;
    display: flex;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 20px 40px rgba(0,0,0,0.6);
}

/* LEFT PANEL */
.left-panel {
    width: 50%;
    background: linear-gradient(135deg,#0f172a,#1e293b);
    color: #fff;
    padding: 60px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.left-panel h1 {
    color: #22d3ee;
    margin-bottom: 20px;
}

.left-panel h2 {
    font-size: 30px;
    margin-bottom: 15px;
}

.left-panel p {
    color: #cbd5f5;
    line-height: 1.6;
}

/* RIGHT PANEL */
.right-panel {
    width: 50%;
    background: #111827;
    color: white;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.right-panel h2 {
    font-size: 26px;
    margin-bottom: 8px;
    color: #22d3ee;
}

.subtitle {
    margin-bottom: 30px;
    color: #9ca3af;
}

/* FORM */
form {
    display: flex;
    flex-direction: column;
}

form input {
    margin-bottom: 18px;
    padding: 14px;
    border: none;
    border-radius: 8px;
    background: #1f2937;
    color: white;
    outline: none;
}

form input::placeholder {
    color: #6b7280;
}

/* BUTTON */
button {
    padding: 14px;
    border: none;
    border-radius: 8px;
    background: #22d3ee;
    color: black;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    background: #06b6d4;
}

.footer-text {
    margin-top: 15px;
    font-size: 12px;
    color: #6b7280;
    text-align: center;
}

</style>


<body>
	<div class="container">

    <!-- LEFT -->
    <div class="left-panel">
        <h1>DigitalBazaar</h1>
        <h2>Admin Control</h2>
        <p>Restricted system access. Only authorized administrators can proceed.</p>
    </div>

    <!-- RIGHT -->
    <div class="right-panel">
        <h2>Login</h2>
        <p class="subtitle">Enter admin credentials</p>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <p style="color:red; margin-bottom:15px;">⚠ <%= error %></p>
        <% } %>

        <form action="<%=request.getContextPath()%>/adminLogin" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>

        <div class="footer-text">
            Authorized Login
        </div>
    </div>

</div>
</body>
</html>