<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
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

body {
    height: 100vh;
    background: #f1f5f9;
    display: flex;
    justify-content: center;
    align-items: center;
}

.container {
    width: 950px;
    height: 520px;
    display: flex;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 20px 40px rgba(0,0,0,0.6);
}

/* LEFT PANEL */
.left-panel {
    position: relative;
    background: url('${pageContext.request.contextPath}/images/adminlogin.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    width: 50%;
    color: #fff;
    padding: 44px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.left-panel::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(
        to top,
        rgba(6, 13, 31, 0.92) 0%,
        rgba(6, 13, 31, 0.60) 50%,
        rgba(6, 13, 31, 0.25) 100%
    );
}

.left-panel h1,
.left-panel h2,
.left-panel p,
.lp-features {
    position: relative;
    z-index: 2;
}

.left-panel h1 {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: rgba(255,255,255,0.45);
    margin-bottom: 12px;
}

.left-panel h2 {
    font-size: 36px;
    font-weight: 700;
    color: #ffffff;
    line-height: 1.15;
    text-shadow: 0 2px 20px rgba(0,0,0,0.5);
    margin-bottom: 12px;
}

.left-panel > p {
    color: rgba(255,255,255,0.60);
    font-size: 13px;
    line-height: 1.7;
    margin-bottom: 28px;
    max-width: 340px;
}

.lp-features {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.lp-feature {
    display: flex;
    align-items: center;
    gap: 12px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 10px;
    padding: 10px 14px;
    backdrop-filter: blur(4px);
}

.lp-feature-text strong {
    display: block;
    font-size: 12px;
    font-weight: 600;
    color: #ffffff;
    margin-bottom: 1px;
}

.lp-feature-text span {
    font-size: 11px;
    color: rgba(255,255,255,0.42);
}

/* RIGHT PANEL */
.right-panel {
    width: 50%;
    background: #ffffff;
    color: #111827;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.right-panel h2 {
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 8px;
    color: #0f172a;
}

.subtitle {
    margin-bottom: 30px;
    color: #6b7280;
    font-size: 14px;
}

form {
    display: flex;
    flex-direction: column;
}

form input {
    margin-bottom: 18px;
    padding: 14px;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    background: #f3f4f6;
    color: #111827;
    outline: none;
    font-size: 14px;
}

form input::placeholder {
    color: #9ca3af;
}

button {
    padding: 14px;
    border: none;
    border-radius: 8px;
    background: #1d4ed8;
    color: white;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
    font-size: 15px;
}

button:hover {
    background: #1e40af;
}

.footer-text {
    margin-top: 15px;
    font-size: 12px;
    color: #9ca3af;
    text-align: center;
}
</style>


<body>
	<div class="container">

    <!-- LEFT -->
    <div class="left-panel">
    <h1 class="logo">DigitalBazaar</h1>
    <h2>Admin<br>Control</h2>
    <p>Restricted system access. Only authorized administrators can proceed.</p>

    <div class="lp-features">
        <div class="lp-feature">
            <div class="lp-feature-text">
                <strong>Secure Access</strong>
                <span>Protected by role-based authentication.</span>
            </div>
        </div>
        <div class="lp-feature">
            <div class="lp-feature-text">
                <strong>Full Control</strong>
                <span>Manage users, orders, and inventory.</span>
            </div>
        </div>
        <div class="lp-feature">
            <div class="lp-feature-text">
                <strong>Admin Only</strong>
                <span>Unauthorized access is strictly prohibited.</span>
            </div>
        </div>
    </div>
</div>

    <!-- RIGHT -->
    <div class="right-panel">
        <h2>Login</h2>
        <p class="subtitle">Enter admin credentials</p>

        <c:if test="${not empty error}">
		    <p style="color:red; margin-bottom:15px;">⚠ ${error}</p>
		</c:if>

        <form action="${pageContext.request.contextPath}/admin-login" method="post">
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