<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register - DigitalBazaar</title>
</head>
<style>
*{ margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', 'Roboto', system-ui, sans-serif; }
/* Body */
body {
    height: 100vh;
    background: #F1F5F9; /* Soft Slate */
    display: flex;
    justify-content: center;
    align-items: center;
    color: #0F172A; /* Deep Navy */
}

/* Container */
.container {
    width: 1000px;
    height: auto;
    min-height: 520px; /* Changed from height: 520px to min-height */
    display: flex;
    border-radius: 4px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    border: 1px solid 
#E2E8F0;
    background: 
#FFFFFF;
}

/* LEFT PANEL (Corporate Branding) */


/* RIGHT PANEL (Form Area) */
.right-panel {
    width: 50%;
    background: 
#FFFFFF;
    color: 
#0F172A;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    overflow-y: auto;
}

.right-panel h2 {
    font-size: 26px;
    margin-bottom: 8px;
    color: 
#0F172A;
}

.subtitle {
    margin-bottom: 30px;
    color: 
#64748B;
    font-size: 14px;
}

/* FORM */
form {
    display: flex;
    flex-direction: column;
}

form input {
    margin-bottom: 18px;
    padding: 14px;
    border: 1px solid 
#E2E8F0;
    border-radius: 4px;
    background: 
#F1F5F9;
    color: 
#0F172A;
    outline: none;
    font-size: 14px;
    transition: border-color 0.2s;
}

form input:focus {
    border-color: 
#3B82F6; /* Sky Blue */
    background: 
#FFFFFF;
}

form input::placeholder {
    color: 
#64748B;
}

/* BUTTON */
button {
    padding: 14px;
    border: none;
    border-radius: 4px;
    background: 
#1E40AF; /* Royal Blue */
    color: 
#FFFFFF;
    font-weight: 600;
    cursor: pointer;
    font-size: 15px;
    transition: background-color 0.2s;
    margin-top: 10px;
}

button:hover {
    background: 
#172554;
}

/* SWITCH */
.switch {
    margin-top: 25px;
    font-size: 14px;
    text-align: center;
    color: 
#64748B;
}

.switch a {
    color: 
#1E40AF;
    text-decoration: none;
    font-weight: 600;
}

.switch a:hover {
    text-decoration: underline;
}

.left-panel {
    width: 50%;
    position: relative;
    overflow: hidden;
    background: url('${pageContext.request.contextPath}/images/registration.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    padding: 60px 40px 44px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}


.left-panel h2 {
    font-size: 42px;
    margin-bottom: 18px;
    font-weight: 700;
    line-height: 1.1;
}

.left-panel .logo,
.left-panel h2 {
    color: 
#FFFFFF;
    text-shadow: 0 2px 16px rgba(0, 0, 0, 0.75), 0 1px 4px rgba(0, 0, 0, 0.5);
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

.left-panel p {
    color: 
#FFFFFF;                              /* changed from rgba(255,255,255,0.72) */
    text-shadow: 0 1px 8px rgba(0, 0, 0, 0.8);  /* stronger shadow */
    line-height: 1.7;
    font-size: 15px;
    max-width: 420px;
    position: relative;
    z-index: 1;                                  /* ensure it sits above the ::after overlay */
}




.logo,
.left-panel h2,
.left-panel p,
.lp-features {
    position: relative;
    z-index: 2;
}

.logo {
    font-size: 11px !important;
    font-weight: 600 !important;
    letter-spacing: 2px !important;
    text-transform: uppercase !important;
    color: rgba(255,255,255,0.45) !important;
    text-shadow: none !important;
    margin-bottom: 12px !important;
}

.left-panel h2 {
    font-size: 36px !important;
    font-weight: 700 !important;
    color: #ffffff !important;
    line-height: 1.15 !important;
    text-shadow: 0 2px 20px rgba(0,0,0,0.5) !important;
    margin-bottom: 12px !important;
}

.left-panel > p {
    color: rgba(255,255,255,0.60) !important;
    font-size: 13px !important;
    line-height: 1.7 !important;
    text-shadow: none !important;
    margin-bottom: 28px !important;
    max-width: 340px;
}

/* Feature cards — identical to login */
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

.lp-feature-icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    background: rgba(0,180,255,0.12);
    border: 1px solid rgba(0,180,255,0.22);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    font-size: 15px;
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
</style>
<body>
	<div class="container">

    <!-- LEFT PANEL -->
    <div class="left-panel">
        <h1 class="logo">DigitalBazaar</h1>
        <h2>Create Your<br>Account</h2>
        <p>Join DigitalBazaar and start your journey today.</p>

        <div class="lp-features">
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Start Building</strong>
                    <span>Create your account and explore powerful tech.</span>
                </div>
            </div>
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Become New Family</strong>
                    <span>Connect with gamers, creators, and PC builders.</span>
                </div>
            </div>
            <div class="lp-feature">
                <div class="lp-feature-text">
                    <strong>Your Setup Starts Here</strong>
                    <span>Find components designed for performance and reliability.</span>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT PANEL -->
    <div class="right-panel">
        <h2>Register</h2>
        <p class="subtitle">Fill in your details to create an account</p>

        <c:if test="${not empty error}">
    <p style="color:red; margin-bottom:15px;">⚠ ${error}</p>
</c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
		    <input type="text"     name="fullname"        placeholder="Full Name"        required>
		    <input type="text"     name="username"        placeholder="Username"         required>
		    <input type="email"    name="email"           placeholder="Email"            required>
		    <input type="password" name="password"        placeholder="Password"         required>
		    <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
		    <button type="submit">Create Account</button>
		</form>

        <p class="switch">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a>
        </p>
    </div>

</div>
</body>
</html>
