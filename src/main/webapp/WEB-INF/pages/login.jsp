<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - DigitalBazaar</title>
</head>
<style>
* {
    margin: 0; padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', 'Roboto', system-ui, sans-serif;
}

body {
    height: 100vh;
    background: #F1F5F9;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #0F172A;
}

.container {
    width: 1000px;
    height: auto;
    min-height: 520px;
    display: flex;
    border-radius: 4px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    border: 1px solid #E2E8F0;
    background: #FFFFFF;
}

/* LEFT PANEL */
.left-panel {
    width: 50%;
    position: relative;
    overflow: hidden;
    background: url('${pageContext.request.contextPath}/images/login.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    padding: 60px 40px 44px;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
}

.left-panel::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(
        to top,
        rgba(6, 13, 31, 0.92) 0%,
        rgba(6, 13, 31, 0.60) 50%,
        rgba(6, 13, 31, 0.25) 100%
    );
    pointer-events: none;
}

.logo,
.left-panel h2,
.left-panel p,
.lp-features {
    position: relative;
    z-index: 2;
}

.logo {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: rgba(255,255,255,0.45);
    text-shadow: none;
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
    text-shadow: none;
    margin-bottom: 28px;
    max-width: 340px;
    position: relative;
    z-index: 2;
}

/* Feature cards */
.lp-features { display: flex; flex-direction: column; gap: 10px; }

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

.lp-feature-icon {
    width: 32px; height: 32px;
    border-radius: 8px;
    background: rgba(0,180,255,0.12);
    border: 1px solid rgba(0,180,255,0.22);
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; font-size: 15px;
}

.lp-feature-text strong {
    display: block; font-size: 12px;
    font-weight: 600; color: #ffffff; margin-bottom: 1px;
}

.lp-feature-text span { font-size: 11px; color: rgba(255,255,255,0.42); }

/* RIGHT PANEL */
.right-panel {
    width: 50%;
    background: #FFFFFF;
    color: #0F172A;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    overflow-y: auto;
}

.right-panel h2 { font-size: 26px; margin-bottom: 8px; color: #0F172A; }

.subtitle { margin-bottom: 30px; color: #64748B; font-size: 14px; }

/* FORM */
form { display: flex; flex-direction: column; }

form input {
    margin-bottom: 18px;
    padding: 14px;
    border: 1px solid #E2E8F0;
    border-radius: 4px;
    background: #F1F5F9;
    color: #0F172A;
    outline: none;
    font-size: 14px;
    transition: border-color 0.2s;
}

form input:focus { border-color: #3B82F6; background: #FFFFFF; }
form input::placeholder { color: #64748B; }

/* BUTTON */
button {
    padding: 14px; border: none; border-radius: 4px;
    background: #1E40AF; color: #FFFFFF;
    font-weight: 600; cursor: pointer; font-size: 15px;
    transition: background-color 0.2s; margin-top: 10px;
}

button:hover { background: #172554; }

/* SWITCH */
.switch { margin-top: 25px; font-size: 14px; text-align: center; color: #64748B; }
.switch a { color: #1E40AF; text-decoration: none; font-weight: 600; }
.switch a:hover { text-decoration: underline; }
</style>
<body>
    <div class="container">

    <!-- LEFT PANEL -->
    <div class="left-panel">
        <h1 class="logo">DigitalBazaar</h1>
        <h2>Build Your<br>Digital World</h2>
        <p>Access powerful hardware, next-gen components, and a marketplace built for creators, gamers, and innovators.</p>

        <div class="lp-features">
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Next-Gen Hardware</strong>
                    <span>Built for speed and smooth performance.</span>
                </div>
            </div>
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Trusted Components</strong>
                    <span>Shop CPUs, GPUs, RAM, motherboards, and more.</span>
                </div>
            </div>
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Made For Builders</strong>
                    <span>Perfect for data scientists, ML engineers, and developers.</span>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT PANEL -->
    <div class="right-panel">
        <h2>Login</h2>
        <p class="subtitle">Enter your credentials to continue</p>

        <c:if test="${param.success == 'registered'}">
    <p style="color:#22d3ee; margin-bottom:15px;">✓ Registered successfully! Please login.</p>
</c:if>

        <c:if test="${not empty error}">
    <p style="color:red; margin-bottom:15px;">⚠ ${error}</p>
</c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="text" name="username" placeholder="Username" required
       value="${not empty savedUsername ? savedUsername : ''}">
            <input type="password" name="password" placeholder="Password" required>
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:10px;">
			    <input type="checkbox" name="rememberMe" id="rememberMe"
			           style="width:16px; height:16px; accent-color:#1E40AF; cursor:pointer; margin:0;">
			    <label for="rememberMe" style="color:#64748B; font-size:13px; cursor:pointer;">Remember me</label>
			</div>
            <button type="submit">Login</button>
        </form>

        <p class="switch">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a>
        </p>
    </div>

    </div>
</body>
</html>