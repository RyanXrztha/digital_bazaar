<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.DigitalBazaar.model.User" %>
<%
Boolean loggedIn = (Boolean) request.getAttribute("isLoggedIn");
User userObj = (User) session.getAttribute("user");
String sessionUsername = (userObj != null) ? userObj.getUsername() : null;
String initials = "";
if (sessionUsername != null && !sessionUsername.isEmpty()) {
    String[] parts = sessionUsername.trim().split("\\s+");
    if (parts.length >= 2) {
        initials = ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
    } else {
        initials = String.valueOf(parts[0].charAt(0)).toUpperCase();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About Us & Contact — TechForge</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;0,9..40,800;1,9..40,300&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
:root {
  --white:        #ffffff;
  --off-white:    #FAFAFA;
  --gray-50:      #F5F5F5;
  --gray-100:     #EBEBEB;
  --gray-200:     #D4D4D4;
  --gray-400:     #A3A3A3;
  --gray-600:     #525252;
  --gray-800:     #262626;
  --black:        #0A0A0A;
  --blue:         #2563EB;
  --blue-light:   #EFF6FF;
  --blue-mid:     rgba(37,99,235,0.12);
  --sh-sm:        0 1px 3px rgba(0,0,0,0.06),0 1px 2px rgba(0,0,0,0.04);
  --sh-md:        0 4px 20px rgba(0,0,0,0.08),0 2px 6px rgba(0,0,0,0.04);
  --sh-lg:        0 12px 48px rgba(0,0,0,0.10),0 4px 16px rgba(0,0,0,0.05);
  --r-sm:  10px;
  --r-md:  16px;
  --r-lg:  24px;
  --font-display: 'DM Sans', sans-serif;
  --font-body:    'DM Sans', sans-serif;
}
html { scroll-behavior: smooth; }
body {
  font-family: var(--font-body);
  background: var(--white);
  color: var(--black);
  line-height: 1.6;
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
}

.profile-wrapper { position: relative; }
.profile-btn {
    cursor: pointer; width: 32px; height: 32px;
    display: flex; align-items: center; justify-content: center;
    border-radius: 50%; border: 1.5px solid var(--gray-200);
    background: var(--white); transition: all 0.2s ease;
    padding: 0; overflow: hidden;
}
.profile-btn:hover { border-color: var(--blue); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.profile-btn.open  { border-color: var(--blue); box-shadow: 0 0 0 3px rgba(37,99,235,0.15); }
.profile-btn-avatar {
    width: 100%; height: 100%;
    display: flex; align-items: center; justify-content: center;
    font-size: 11px; font-weight: 700; color: var(--blue);
    background: var(--blue-light); letter-spacing: 0.5px;
}
.profile-dropdown {
    position: absolute; top: calc(100% + 10px); right: 0;
    width: 220px; background: var(--white);
    border-radius: 12px; border: 1px solid var(--gray-100);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,0.15);
    z-index: 1100; opacity: 0; visibility: hidden;
    transform: translateY(8px);
    transition: all 0.25s cubic-bezier(0.16,1,0.3,1); overflow: hidden;
}
.profile-dropdown.open { opacity: 1; visibility: visible; transform: translateY(0); }
.pd-header { padding: 16px 20px; border-bottom: 1px solid var(--gray-100); background: #FAFAFB; }
.pd-username { font-size: 14px; font-weight: 600; color: var(--black); }
.pd-status { font-size: 11px; color: var(--gray-400); margin-top: 4px; }
.pd-nav { padding: 8px; }
.pd-item, .pd-logout {
    display: block; width: 100%; padding: 10px 14px;
    font-size: 13px; font-weight: 500; color: var(--gray-600);
    text-decoration: none; border-radius: 8px;
    transition: all 0.15s; border: none; background: transparent;
    text-align: left; cursor: pointer;
}
.pd-item:hover { background: var(--gray-50); color: var(--blue); }
.pd-footer { padding: 8px; border-top: 1px solid var(--gray-100); }
.pd-logout { color: #DC2626; }
.pd-logout:hover { background: #FEF2F2; color: #991B1B; }
.nav-icons { display: flex; align-items: center; gap: 8px; }

section { padding: 96px 56px; }
.label {
  display: inline-block;
  font-size: 0.72rem; font-weight: 700;
  letter-spacing: 0.1em; text-transform: uppercase;
  color: var(--blue); margin-bottom: 14px;
}
.section-title {
  font-family: var(--font-display);
  font-size: clamp(2rem, 3.5vw, 2.9rem);
  font-weight: 800; letter-spacing: -0.025em;
  line-height: 1.1; color: var(--black); margin-bottom: 16px;
}
.section-sub {
  font-size: 1rem; color: var(--gray-600);
  line-height: 1.75; font-weight: 300;
}

#hero {
  min-height: 100vh;
  padding: 120px 56px 80px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 64px; align-items: center;
  position: relative; overflow: hidden;
}
.hero-glow {
  position: absolute; inset: 0; pointer-events: none;
  background:
    radial-gradient(ellipse 55% 45% at 78% 38%, rgba(37,99,235,0.06) 0%, transparent 70%),
    radial-gradient(ellipse 35% 30% at 8%  72%, rgba(99,102,241,0.04) 0%, transparent 65%);
}
.hero-grid-bg {
  position: absolute; inset: 0; pointer-events: none;
  background-image:
    linear-gradient(var(--gray-100) 1px, transparent 1px),
    linear-gradient(90deg, var(--gray-100) 1px, transparent 1px);
  background-size: 52px 52px;
  opacity: 0.45;
  mask-image: radial-gradient(ellipse at 50% 50%, black 25%, transparent 72%);
  -webkit-mask-image: radial-gradient(ellipse at 50% 50%, black 25%, transparent 72%);
}
.hero-left { position: relative; z-index: 2; }
.hero-tag {
  display: inline-flex; align-items: center; gap: 8px;
  background: var(--blue-light); color: var(--blue);
  padding: 6px 14px; border-radius: 100px;
  font-size: 0.72rem; font-weight: 700;
  letter-spacing: 0.06em; text-transform: uppercase;
  margin-bottom: 28px;
  border: 1px solid rgba(37,99,235,0.18);
}
.hero-tag::before {
  content: ''; width: 6px; height: 6px;
  background: var(--blue); border-radius: 50%;
}
h1.hero-h1 {
  font-family: var(--font-body);
  font-size: clamp(2.8rem, 5vw, 4rem);
  font-weight: 700; letter-spacing: -0.01em;
  line-height: 1.07; color: var(--black); margin-bottom: 24px;
}
h1.hero-h1 em { font-style: normal; color: var(--blue); }
.hero-p {
  font-size: 1.05rem; color: var(--gray-600);
  line-height: 1.75; max-width: 490px;
  font-weight: 300; margin-bottom: 40px;
}
.btn-row { display: flex; gap: 12px; flex-wrap: wrap; }
.btn-dark {
  background: var(--black); color: var(--white);
  padding: 14px 28px; border-radius: var(--r-sm);
  font-size: 0.9rem; font-weight: 600;
  text-decoration: none; transition: all 0.25s;
  display: inline-flex; align-items: center; gap: 8px;
}
.btn-dark:hover { background: var(--blue); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(37,99,235,0.28); }
.btn-outline {
  background: var(--white); color: var(--black);
  padding: 14px 28px; border-radius: var(--r-sm);
  font-size: 0.9rem; font-weight: 600;
  text-decoration: none; transition: all 0.25s;
  border: 1.5px solid var(--gray-200);
  display: inline-flex; align-items: center; gap: 8px;
}
.btn-outline:hover { border-color: var(--gray-400); transform: translateY(-2px); box-shadow: var(--sh-sm); }

.hero-right {
  position: relative; z-index: 2;
  display: grid; grid-template-columns: 1fr 1fr;
  gap: 16px; padding: 16px;
}
.pc-card {
  background: var(--white);
  border: 1px solid var(--gray-100);
  border-radius: var(--r-md);
  padding: 22px 18px;
  box-shadow: var(--sh-md);
  display: flex; flex-direction: column; gap: 10px;
  position: relative; overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.pc-card::before {
  content: ''; position: absolute;
  top: 0; left: 0; right: 0; height: 2px;
  background: linear-gradient(90deg, var(--blue), transparent);
}
.pc-card:hover { transform: translateY(-5px); box-shadow: var(--sh-lg); }
.pc-icon {
  width: 42px; height: 42px; background: var(--gray-50);
  border-radius: 10px; display: flex;
  align-items: center; justify-content: center; font-size: 1.25rem;
}
.pc-name { font-family: var(--font-display); font-size: 0.9rem; font-weight: 700; color: var(--black); }
.pc-sub  { font-size: 0.75rem; color: var(--gray-400); }
.pc-badge {
  align-self: flex-start;
  background: var(--blue-light); color: var(--blue);
  font-size: 0.68rem; font-weight: 700;
  padding: 3px 9px; border-radius: 100px;
  letter-spacing: 0.02em;
}

#about { background: var(--off-white); }
.about-grid {
  display: grid; grid-template-columns: 1fr 1fr;
  gap: 80px; align-items: center;
}
.about-visual {
  border-radius: var(--r-lg); overflow: hidden;
  aspect-ratio: 4/3;
  background: linear-gradient(150deg, #0f172a 0%, #1e3a5f 55%, #0c2340 100%);
  box-shadow: var(--sh-lg);
  display: flex; align-items: center; justify-content: center;
}
.about-right { display: flex; flex-direction: column; gap: 28px; }
.about-body p { font-size: 0.97rem; color: var(--gray-600); line-height: 1.82; font-weight: 300; }
.about-body p+p { margin-top: 14px; }

#founder { background: var(--white); }
.founder-wrap { max-width: 820px; margin: 0 auto; }
.founder-card {
  background: var(--white);
  border: 1px solid var(--gray-100);
  border-radius: var(--r-lg);
  box-shadow: var(--sh-lg); overflow: hidden;
  display: grid; grid-template-columns: 260px 1fr;
}
.founder-panel {
  background: linear-gradient(165deg, #0c1a35 0%, #1a3a6b 100%);
  padding: 48px 28px 40px;
  display: flex; flex-direction: column;
  align-items: center; gap: 18px; text-align: center;
}
.founder-av {
  width: 96px; height: 96px; border-radius: 50%;
  border: 2px solid rgba(255,255,255,0.2);
  overflow: hidden;
  background-color: #1e3a6b;
}
.founder-name { font-family: var(--font-display); font-size: 1.1rem; font-weight: 800; color: #fff; letter-spacing: -0.01em; }
.founder-role { font-size: 0.78rem; color: rgba(255,255,255,0.5); line-height: 1.5; }
.s-links { display: flex; gap: 9px; margin-top: 6px; }
.s-btn {
  width: 35px; height: 35px;
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.14);
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  text-decoration: none; color: rgba(255,255,255,0.65); font-size: 0.85rem;
  transition: all 0.2s;
}
.s-btn:hover { background: rgba(255,255,255,0.18); color: #fff; }
.s-btn svg { width: 14px; height: 14px; fill: currentColor; }

.founder-body { padding: 44px 40px; display: flex; flex-direction: column; gap: 22px; }
.founder-bio { font-size: 0.97rem; color: var(--gray-600); line-height: 1.85; font-weight: 300; }
.f-tags { display: flex; flex-wrap: wrap; gap: 8px; }
.f-tag {
  background: var(--gray-50); border: 1px solid var(--gray-100);
  border-radius: 100px; padding: 4px 13px;
  font-size: 0.73rem; font-weight: 600; color: var(--gray-600);
}
.f-cta { display: flex; gap: 10px; flex-wrap: wrap; }
.f-link {
  display: inline-flex; align-items: center; gap: 7px;
  padding: 10px 18px; border-radius: 8px;
  font-size: 0.83rem; font-weight: 600;
  text-decoration: none; border: 1.5px solid var(--gray-200);
  color: var(--black); background: var(--white); transition: all 0.2s;
}
.f-link:hover { border-color: var(--blue); color: var(--blue); transform: translateY(-1px); }
.f-link svg { width: 13px; height: 13px; fill: currentColor; }

#faq { background: var(--white); }
.faq-hd { text-align: center; margin-bottom: 52px; }
.faq-wrap { max-width: 700px; margin: 0 auto; }
.faq-item {
  border: 1px solid var(--gray-100);
  border-radius: var(--r-md); margin-bottom: 10px;
  overflow: hidden; transition: box-shadow 0.2s;
}
.faq-item:hover { box-shadow: var(--sh-sm); }
.faq-q {
  width: 100%; display: flex; justify-content: space-between;
  align-items: center; padding: 20px 22px;
  background: var(--white); border: none; cursor: pointer;
  font-family: var(--font-body); font-size: 0.93rem;
  font-weight: 600; color: var(--black); text-align: left;
  gap: 14px; transition: background 0.2s;
}
.faq-q:hover { background: var(--gray-50); }
.faq-chev {
  flex-shrink: 0; width: 26px; height: 26px;
  background: var(--gray-50); border-radius: 7px;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.65rem; color: var(--gray-400);
  transition: transform 0.3s, background 0.2s, color 0.2s;
}
.faq-item.open .faq-chev { transform: rotate(180deg); background: var(--blue-light); color: var(--blue); }
.faq-a {
  max-height: 0; overflow: hidden;
  transition: max-height 0.35s ease, padding 0.35s ease;
  padding: 0 22px;
  font-size: 0.88rem; color: var(--gray-600); line-height: 1.78; font-weight: 300;
}
.faq-item.open .faq-a { max-height: 300px; padding: 0 22px 20px; }

#contact { background: var(--gray-50); }
.contact-grid { display: grid; grid-template-columns: 1fr 1.45fr; gap: 64px; align-items: start; }
.contact-left { display: flex; flex-direction: column; gap: 28px; }
.contact-cards { display: flex; flex-direction: column; gap: 12px; }
.c-card {
  background: var(--white); border: 1px solid var(--gray-100);
  border-radius: var(--r-md); padding: 18px 22px;
  box-shadow: var(--sh-sm); transition: box-shadow 0.2s;
}
.c-card:hover { box-shadow: var(--sh-md); }
.c-lbl { font-size: 0.7rem; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase; color: var(--gray-400); margin-bottom: 3px; }
.c-val { font-size: 0.9rem; font-weight: 500; color: var(--black); }

.form-box {
  background: var(--white); border: 1px solid var(--gray-100);
  border-radius: var(--r-lg); padding: 40px;
  box-shadow: var(--sh-md);
}
.form-ttl {
  font-family: var(--font-display); font-size: 1.25rem;
  font-weight: 800; letter-spacing: -0.02em;
  color: var(--black); margin-bottom: 28px;
}
.form-row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.fg { display: flex; flex-direction: column; gap: 7px; margin-bottom: 14px; }
.fg label { font-size: 0.77rem; font-weight: 700; color: var(--gray-600); letter-spacing: 0.03em; }
.fg input, .fg select, .fg textarea {
  border: 1.5px solid var(--gray-100); border-radius: var(--r-sm);
  padding: 12px 15px; font-size: 0.88rem;
  font-family: var(--font-body); color: var(--black);
  background: var(--white); outline: none; width: 100%;
  transition: border-color 0.2s, box-shadow 0.2s;
  appearance: none; -webkit-appearance: none;
}
.fg input:focus, .fg select:focus, .fg textarea:focus {
  border-color: var(--blue);
  box-shadow: 0 0 0 3px rgba(37,99,235,0.09);
}
.fg input::placeholder, .fg textarea::placeholder { color: var(--gray-200); }
.fg textarea { min-height: 118px; resize: vertical; }
.upload-area {
  border: 1.5px dashed var(--gray-200); border-radius: var(--r-sm);
  padding: 18px; background: var(--gray-50);
  display: flex; align-items: center; justify-content: center;
  gap: 9px; cursor: pointer; font-size: 0.83rem;
  color: var(--gray-400); font-weight: 500;
  transition: all 0.2s; margin-bottom: 14px;
}
.upload-area:hover { border-color: var(--blue); color: var(--blue); background: var(--blue-light); }
.submit-btn {
  width: 100%; background: var(--black); color: var(--white);
  border: none; border-radius: var(--r-sm); padding: 16px;
  font-size: 0.93rem; font-weight: 700; font-family: var(--font-display);
  cursor: pointer; transition: all 0.25s; letter-spacing: 0.01em;
  display: flex; align-items: center; justify-content: center; gap: 10px;
}
.submit-btn:hover {
  background: var(--blue); transform: translateY(-2px);
  box-shadow: 0 8px 28px rgba(37,99,235,0.28);
}
.submit-btn .arr { display: inline-block; transition: transform 0.2s; }
.submit-btn:hover .arr { transform: translateX(5px); }


.newsletter { display: flex; gap: 8px; margin-top: 18px; }
.newsletter input {
  flex: 1; border: 1.5px solid var(--gray-100); border-radius: 8px;
  padding: 9px 13px; font-size: 0.82rem;
  font-family: var(--font-body); outline: none;
  transition: border-color 0.2s;
}
.newsletter input:focus { border-color: var(--blue); }
.newsletter button {
  background: var(--black); color: var(--white); border: none;
  border-radius: 8px; padding: 9px 15px; font-size: 0.82rem;
  font-weight: 600; cursor: pointer; font-family: var(--font-body);
  transition: background 0.2s; white-space: nowrap;
}
.newsletter button:hover { background: var(--blue); }


@media (max-width: 1080px) {
  section { padding: 72px 32px; }
  nav { padding: 0 32px; }
  #hero { padding: 110px 32px 72px; }
  .about-grid, .contact-grid { grid-template-columns: 1fr; gap: 48px; }
  .founder-card { grid-template-columns: 1fr; }
  .founder-panel { padding: 36px 28px; flex-direction: row; flex-wrap: wrap; justify-content: center; }
  .footer-top { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 768px) {
  section { padding: 56px 20px; }
  nav { padding: 0 20px; }
  .nav-links { display: none; }
  #hero { grid-template-columns: 1fr; padding: 96px 20px 56px; gap: 40px; }
  .hero-right { display: none; }
  .form-row2 { grid-template-columns: 1fr; }
  .footer-top { grid-template-columns: 1fr; }
  .footer-bottom { flex-direction: column; align-items: flex-start; }
}
</style>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">Digital<span>_</span>Bazaar</div>
    <c:set var="uri" value="${pageContext.request.requestURI}" />
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/dashboard"
               class="${fn:contains(uri, '/dashboard') ? 'active' : ''}">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/shop"
               class="${fn:contains(uri, '/shop') ? 'active' : ''}">Shop</a></li>
        <li><a href="${pageContext.request.contextPath}/build-pc"
               class="${fn:contains(uri, '/build-pc') ? 'active' : ''}">PC Builder</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us"
               id="aboutNavLink"
               class="${fn:contains(uri, '/about-us') ? 'active' : ''}">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us#contact"
               id="contactNavLink">Contact Us</a></li>
    </ul>
    <div class="nav-icons">
        <div class="profile-wrapper" id="profileWrapper">
            <button class="profile-btn" id="profileBtn" onclick="toggleProfile()" aria-label="Profile">
                <div class="profile-btn-avatar">
                    <% if (initials.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/images/profile.png"
                             alt="Profile"
                             style="width:100%;height:100%;object-fit:cover;filter:invert(30%) sepia(80%) saturate(500%) hue-rotate(200deg);">
                    <% } else { %>
                        <%= initials %>
                    <% } %>
                </div>
            </button>
            <div class="profile-dropdown" id="profileDropdown">
                <% if (Boolean.TRUE.equals(loggedIn) && sessionUsername != null) { %>
                    <div class="pd-header">
                        <div class="pd-username"><%= sessionUsername %></div>
                        <div class="pd-status">Account Active</div>
                    </div>
                    <nav class="pd-nav">
                        <a href="${pageContext.request.contextPath}/dashboard" class="pd-item">Home</a>
                        <a href="${pageContext.request.contextPath}/shop" class="pd-item">Shop Products</a>
                        <a href="${pageContext.request.contextPath}/dashboard#track" class="pd-item">My Orders</a>
                    </nav>
                    <div class="pd-footer">
                        <a href="${pageContext.request.contextPath}/logout" class="pd-logout">Sign Out</a>
                    </div>
                <% } else { %>
                    <div class="pd-header">
                        <div class="pd-username">Guest User</div>
                        <div class="pd-status">Please sign in</div>
                    </div>
                    <nav class="pd-nav">
                        <a href="${pageContext.request.contextPath}/login" class="pd-item">Log In</a>
                        <a href="${pageContext.request.contextPath}/register" class="pd-item">Create Account</a>
                    </nav>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<section id="hero">
  <div class="hero-glow"></div>
  <div class="hero-grid-bg"></div>

  <div class="hero-left">
    <div class="hero-tag">Premium Tech Commerce · Nepal</div>
    <h1 class="hero-h1">Building Technology<br>Experiences<br>That <em>Matter</em></h1>
    <p class="hero-p">We deliver high-performance PC components and hardware solutions designed for gamers, developers, streamers, ML engineers, and creators who demand nothing but excellence.</p>
    <div class="btn-row">
      <a href="#contact" class="btn-dark">Contact Us <span>&#8594;</span></a>
      <a href="${pageContext.request.contextPath}/shop" class="btn-outline">Explore Products</a>
    </div>
  </div>

  <div class="hero-right">
    <div class="pc-card">
      <div class="pc-name">RTX 5090</div>
      <div class="pc-sub">NVIDIA Graphics Card</div>
      <div class="pc-badge">In Stock</div>
    </div>
    <div class="pc-card">
      <div class="pc-name">Ryzen 9 9950X</div>
      <div class="pc-sub">AMD Processor</div>
      <div class="pc-badge">New</div>
    </div>
    <div class="pc-card">
      <div class="pc-name">ROG Maximus Z890</div>
      <div class="pc-sub">ASUS Motherboard</div>
      <div class="pc-badge">Trending</div>
    </div>
    <div class="pc-card">
      <div class="pc-name">DDR5 64GB Kit</div>
      <div class="pc-sub">G.Skill Trident Z5</div>
      <div class="pc-badge">Hot Deal</div>
    </div>
  </div>
</section>

<section id="about">
  <div class="about-grid">
    <div class="about-visual">
      <div style="text-align:center; padding: 48px 36px; color: #fff;">
        <div style="font-size:0.72rem; letter-spacing:0.14em; text-transform:uppercase; color:rgba(255,255,255,0.4); margin-bottom:16px;">Est. 2023 · Kathmandu, Nepal</div>
        <div style="font-family:var(--font-body); font-size:2.4rem; font-weight:700; line-height:1.2; letter-spacing:-0.02em; margin-bottom:20px;">10,000+<br>Customers Served</div>
        <div style="width:40px; height:2px; background:rgba(37,99,235,0.6); margin:0 auto 20px;"></div>
        <div style="font-size:0.88rem; color:rgba(255,255,255,0.45); line-height:1.8; font-weight:300; max-width:260px; margin:0 auto;">Genuine components. Expert support. Delivered fast across Nepal.</div>
      </div>
    </div>

    <div class="about-right">
      <div>
        <div class="label">Our Story</div>
        <h2 class="section-title">Built for Performance.<br>Driven by Passion.</h2>
      </div>
      <div class="about-body">
        <p>TechForge was born from a simple frustration: finding reliable, genuine PC components shouldn't require expertise, luck, or compromise. We set out to build an ecommerce experience where trust, quality, and expert knowledge come standard.</p>
        <p>Whether you're a competitive gamer pushing frame rates, a developer compiling code, an ML engineer training models, or a creator rendering timelines — we understand what performance means to you. Every product on our platform is curated, verified, and backed by our dedicated support team.</p>
      </div>
    </div>
  </div>
</section>

<section id="founder">
  <div style="text-align:center;margin-bottom:52px;">
    <div class="label">The Person Behind It</div>
    <h2 class="section-title">Meet the Founder</h2>
  </div>
  <div class="founder-wrap">
    <div class="founder-card">
      <div class="founder-panel">
        <div class="founder-av">
  <img src="${pageContext.request.contextPath}/images/photo.png" alt="Aryan Shrestha" style="width:100%; height:100%; object-fit:cover; object-position:center top; display:block;">
</div>
        <div>
          <div class="founder-name">Aryan Shrestha</div>
          <div class="founder-role">Founder &amp; Technology Enthusiast</div>
        </div>
        <div class="s-links">
          <a href="https://www.linkedin.com/in/aryan-shrestha-823863371/" target="_blank" rel="noopener" class="s-btn" title="LinkedIn">
            <svg viewBox="0 0 24 24"><path d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"/><circle cx="4" cy="4" r="2"/></svg>
          </a>
          <a href="https://github.com/RyanXrztha" target="_blank" rel="noopener" class="s-btn" title="GitHub">
            <svg viewBox="0 0 24 24"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 00-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0020 4.77 5.07 5.07 0 0019.91 1S18.73.65 16 2.48a13.38 13.38 0 00-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 005 4.77a5.44 5.44 0 00-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 009 18.13V22"/></svg>
          </a>
          <a href="https://www.instagram.com/_aaryan_sht/" target="_blank" rel="noopener" class="s-btn" title="Instagram">
		    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
		</a>
        </div>
      </div>	
      <div class="founder-body">
        <div>
          <div class="label" style="margin-bottom:10px;">About Aryan</div>
          <h3 style="font-family:var(--font-display);font-size:1.3rem;font-weight:800;letter-spacing:-0.02em;margin-bottom:16px;color:var(--black);">Passionate about technology,<br>hardware &amp; digital experiences.</h3>
          <p class="founder-bio">Aryan Shrestha is passionate about technology, hardware systems, and creating high-quality digital shopping experiences. With a strong interest in modern computing and user-centered design, he focuses on building a platform that makes choosing PC components simpler, smarter, and more accessible for everyone.<br><br>From sourcing the finest components to ensuring every customer interaction feels effortless, Aryan brings a meticulous approach to both the technical and human sides of TechForge.</p>
        </div>
        <div class="f-tags">
          <span class="f-tag">PC Hardware</span>
          <span class="f-tag">UI/UX Design</span>
          <span class="f-tag">Machine Learning</span>
          <span class="f-tag">Gaming</span>
          <span class="f-tag">Ecommerce</span>
        </div>
        
      </div>
    </div>
  </div>
</section>

<section id="faq">
  <div class="faq-hd">
    <div class="label">FAQ</div>
    <h2 class="section-title">Common Questions</h2>
    <p class="section-sub">Quick answers to what customers ask most.</p>
  </div>
  <div class="faq-wrap">
    <div class="faq-item open">
      <button class="faq-q" onclick="toggleFaq(this)">
        Are all products genuine and authentic?
        <span class="faq-chev">&#9660;</span>
      </button>
      <div class="faq-a">Absolutely. We source exclusively from authorized distributors and brand-certified channels. Every product arrives in its original manufacturer packaging, complete with warranty card and serial number. We operate a strict zero-tolerance policy on counterfeit or grey-market goods.</div>
    </div>
    <div class="faq-item">
      <button class="faq-q" onclick="toggleFaq(this)">
        Can I customize my PC build?
        <span class="faq-chev">&#9660;</span>
      </button>
      <div class="faq-a">Yes! Use our AI PC Builder tool to assemble a fully custom system. The tool automatically checks compatibility between your chosen CPU, motherboard, RAM, GPU, PSU, and storage before you place your order. You can also contact our experts for personalized build advice.</div>
    </div>
    <div class="faq-item">
      <button class="faq-q" onclick="toggleFaq(this)">
        Do you offer warranty support?
        <span class="faq-chev">&#9660;</span>
      </button>
      <div class="faq-a">Yes. All products come with their full manufacturer warranty. In addition, we offer a 30-day return and exchange policy for any product that arrives defective or damaged. Our support team handles warranty claims and RMA processes on your behalf.</div>
    </div>
    <div class="faq-item">
      <button class="faq-q" onclick="toggleFaq(this)">
        What payment methods are available?
        <span class="faq-chev">&#9660;</span>
      </button>
      <div class="faq-a">We accept eSewa, Khalti, ConnectIPS, all major debit and credit cards (Visa, Mastercard), bank transfers, and cash on delivery for eligible orders. All digital transactions are encrypted with 256-bit SSL for your security.</div>
    </div>
  </div>
</section>

<section id="contact">
  <div style="margin-bottom:52px;">
    <div class="label">Let’s Connect</div>
    <h2 class="section-title">Tell Us What<br>You’re Building</h2>
    <p class="section-sub">Have questions, feedback, or a vision you want to bring to life? Reach out through the form or contact us directly.</p>
  </div>
  <div class="contact-grid">
    <div class="contact-left">
      <div class="contact-cards">
        <div class="c-card">
          <div class="c-lbl">Email Address</div>
          <div class="c-val">aryanshrestha189@gmail.com</div>
        </div>
        <div class="c-card">
          <div class="c-lbl">Phone Number</div>
          <div class="c-val">+977 9841080560</div>
        </div>
        <div class="c-card">
          <div class="c-lbl">Office Location</div>
          <div class="c-val">Baneshwor, Nepal</div>
        </div>
        <div class="c-card">
          <div class="c-lbl">Business Hours</div>
          <div class="c-val">Sun – Fri &nbsp;|&nbsp; 9:00 AM – 6:00 PM</div>
        </div>
      </div>
    </div>

    <div class="form-box">
      <div class="form-ttl">Send a Message</div>
      <div class="form-row2">
        <div class="fg">
          <label for="fullName">Full Name</label>
          <input type="text" id="fullName" name="fullName" placeholder="Aryan Shrestha" required>
        </div>
        <div class="fg">
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" placeholder="aryanshrestha189@gmail.com" required>
        </div>
      </div>
      <div class="form-row2">
        <div class="fg">
          <label for="subject">Subject</label>
          <select id="subject" name="subject">
            <option value="" disabled selected>Select a topic</option>
            <option value="order">Order Inquiry</option>
            <option value="product">Product Question</option>
            <option value="build">PC Build Help</option>
            <option value="warranty">Warranty &amp; Returns</option>
            <option value="payment">Payment Issue</option>
            <option value="other">Other</option>
          </select>
        </div>
        <div class="fg">
          <label for="orderId">Order ID <span style="color:var(--gray-400);font-weight:400;">(optional)</span></label>
          <input type="text" id="orderId" name="orderId" placeholder="......">
        </div>
      </div>
      <div class="fg">
        <label for="message">Message</label>
        <textarea id="message" name="message" placeholder="Tell us what you’re looking to build or improve..."></textarea>
      </div>
      <div class="upload-area" onclick="document.getElementById('attachment').click()">
        <span>&#128206;</span> Attach a file (optional) — JPG, PNG, PDF up to 10 MB
        <input type="file" id="attachment" name="attachment" style="display:none" accept=".jpg,.jpeg,.png,.pdf">
      </div>
      <button type="button" class="submit-btn" onclick="handleSubmit()">
        Send Message <span class="arr">&#8594;</span>
      </button>
    </div>
  </div>
</section>

<footer>
  <div class="footer-top">
    <div class="footer-brand">
      <a href="${pageContext.request.contextPath}/dashboard" class="logo">Digital<span>Bazaar</span></a>
      <p class="footer-desc">Nepal's most trusted destination for genuine PC components, peripherals, and custom build solutions.</p>
    </div>
    <div class="footer-col">
      <h4>Shop</h4>
      <ul>
        <li><a href="${pageContext.request.contextPath}/shop">All Products</a></li>
        <li><a href="${pageContext.request.contextPath}/shop?category=GPU">Graphics Cards</a></li>
        <li><a href="${pageContext.request.contextPath}/shop?category=CPU">Processors</a></li>
        <li><a href="${pageContext.request.contextPath}/shop?category=Motherboard">Motherboards</a></li>
        <li><a href="${pageContext.request.contextPath}/shop?category=RAM">Memory</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Support</h4>
      <ul>
        <li><a href="${pageContext.request.contextPath}/build-pc">PC Builder</a></li>
        <li><a href="${pageContext.request.contextPath}/dashboard#track">Track Order</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us#faq">Payment</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us#faq">Warranty</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Company</h4>
      <ul>
        <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us#founder">Our Founder</a></li>
        <li><a href="${pageContext.request.contextPath}/about-us#contact">Contact</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <div class="footer-socials">
      <a href="https://www.facebook.com/aryan.shrestha.852902/" class="fsoc" title="Facebook">
        <svg viewBox="0 0 24 24"><path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/></svg>
      </a>
      <a href="https://www.instagram.com/_aaryan_sht/" class="fsoc" title="Instagram">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
      </a>
      <a href="https://www.linkedin.com/in/aryan-shrestha-823863371/" class="fsoc" title="LinkedIn">
        <svg viewBox="0 0 24 24"><path d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"/><circle cx="4" cy="4" r="2"/></svg>
      </a>
      <a href="https://github.com/RyanXrztha" class="fsoc" title="GitHub">
        <svg viewBox="0 0 24 24"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 00-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0020 4.77 5.07 5.07 0 0019.91 1S18.73.65 16 2.48a13.38 13.38 0 00-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 005 4.77a5.44 5.44 0 00-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 009 18.13V22"/></svg>
      </a>
    </div>
  </div>
</footer>

<script>
function toggleFaq(btn) {
  var item = btn.closest('.faq-item');
  var isOpen = item.classList.contains('open');
  document.querySelectorAll('.faq-item').forEach(function(el){ el.classList.remove('open'); });
  if (!isOpen) item.classList.add('open');
}

var isLoggedIn = ${isLoggedIn != null ? isLoggedIn : false};
var hasOrders  = ${hasOrders != null ? hasOrders : false};

function handleSubmit() {
  if (!isLoggedIn) {
    alert('Please log in to send a message.');
    window.location.href = '${pageContext.request.contextPath}/login';
    return;
  }
  if (!hasOrders) {
    alert('Only customers who have placed an order can send a message.');
    return;
  }
  var name    = document.getElementById('fullName').value.trim();
  var email   = document.getElementById('email').value.trim();
  var message = document.getElementById('message').value.trim();
  if (!name || !email || !message) {
    alert('Please fill in your name, email, and message.');
    return;
  }
  var btn = document.querySelector('.submit-btn');
  btn.textContent = 'Sending\u2026';
  btn.style.background = '#6b7280';
  setTimeout(function() {
    btn.innerHTML = '&#10003; Message Sent!';
    btn.style.background = '#16a34a';
  }, 1400);
}

window.addEventListener('scroll', function() {
  var nav = document.querySelector('nav');
  if (window.scrollY > 10) {
    nav.style.boxShadow = '0 1px 20px rgba(0,0,0,0.08)';
  } else {
    nav.style.boxShadow = 'none';
  }
});

document.getElementById('attachment').addEventListener('change', function() {
  var area = this.closest('.upload-area');
  if (this.files && this.files[0]) {
    area.innerHTML = '&#128206; ' + this.files[0].name;
    area.style.color = 'var(--blue)';
    area.style.borderColor = 'var(--blue)';
    area.style.background = 'var(--blue-light)';
  }
});

(function() {
    var aboutLink   = document.getElementById('aboutNavLink');
    var contactLink = document.getElementById('contactNavLink');

    // On page load, check hash
    if (window.location.hash === '#contact') {
        aboutLink.classList.remove('active');
        contactLink.classList.add('active');
    }

    // When Contact Us is clicked
    contactLink.addEventListener('click', function() {
        aboutLink.classList.remove('active');
        contactLink.classList.add('active');
    });

    // When About Us is clicked
    aboutLink.addEventListener('click', function() {
        contactLink.classList.remove('active');
        aboutLink.classList.add('active');
    });
})();
function toggleProfile() {
    var btn = document.getElementById('profileBtn');
    var dd  = document.getElementById('profileDropdown');
    var isOpen = dd.classList.contains('open');
    dd.classList.toggle('open', !isOpen);
    btn.classList.toggle('open', !isOpen);
}

document.addEventListener('click', function(e) {
    var wrapper = document.getElementById('profileWrapper');
    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('profileDropdown').classList.remove('open');
        document.getElementById('profileBtn').classList.remove('open');
    }
});
</script>

</body>
</html>