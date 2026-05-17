<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.List, com.DigitalBazaar.model.Product" %>
<%!
private String formatNPR(double amount) {
    long n = (long) amount;
    if (n < 1000) return String.valueOf(n);
    String last3 = String.valueOf(n % 1000);
    while (last3.length() < 3) last3 = "0" + last3;
    long rest = n / 1000;
    StringBuilder sb = new StringBuilder(last3);
    sb.insert(0, ",");
    while (rest > 0) {
        sb.insert(0, rest % 100);
        rest = rest / 100;
        if (rest > 0) sb.insert(0, ",");
    }
    return sb.toString();
}
%>
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
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Digital Bazaar</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>

/* ================= VARIABLES ================= */
:root {
    --white:       #FFFFFF;
    --off-white:   #F8F9FB;
    --surface:     #F2F4F7;
    --border:      #E4E7EC;
    --border-light:#EEF0F4;
    --text-primary:#0D1117;
    --text-secondary:#5A6478;
    --text-muted:  #9BA5B7;
    --accent:      #1A56DB;
    --accent-dark: #1240A8;
    --accent-light:#EBF0FD;
    --success:     #16A34A;
    --hero-bg:     #0D1117;
    --shadow-sm:   0 1px 3px rgba(13,17,23,0.06), 0 1px 2px rgba(13,17,23,0.04);
    --shadow-md:   0 4px 12px rgba(13,17,23,0.08), 0 2px 6px rgba(13,17,23,0.04);
    --shadow-lg:   0 12px 32px rgba(13,17,23,0.10);
    --radius:      8px;
    --radius-sm:   5px;
}

/* ================= RESET ================= */
*, *::before, *::after {
    margin: 0; padding: 0;
    box-sizing: border-box;
}

/* ================= BASE ================= */
body {
    background: var(--off-white);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    font-size: 14px;
    line-height: 1.5;
    overflow-x: hidden;
    -webkit-font-smoothing: antialiased;
}


.icon-btn {
    cursor: pointer;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-sm);
    color: var(--text-secondary);
    transition: all 0.15s ease;
    position: relative;
    font-size: 16px;
    border: none;
    background: transparent;
}

.icon-btn:hover {
    background: var(--surface);
    color: var(--text-primary);
}

.cart-count {
    position: absolute;
    top: 2px; right: 2px;
    background: var(--accent);
    color: white;
    font-size: 9px;
    font-weight: 700;
    min-width: 16px;
    height: 16px;
    padding: 0 4px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'DM Mono', monospace;
}

/* ================= CART SIDEBAR ================= */
.cart-sidebar {
    position: fixed;
    top: 58px; right: -420px;
    width: 400px;
    height: calc(100% - 58px);
    background: var(--white);
    border-left: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    transition: right 0.38s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 999;
    box-shadow: -8px 0 32px rgba(13,17,23,0.08);
}

.cart-sidebar.active { right: 0; }

.cart-header {
    padding: 20px 24px;
    border-bottom: 1px solid var(--border-light);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.cart-header h2 {
    font-size: 13px;
    font-weight: 600;
    color: var(--text-primary);
    letter-spacing: 0.8px;
    text-transform: uppercase;
    font-family: 'DM Mono', monospace;
}

.close-cart {
    cursor: pointer;
    width: 28px; height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 4px;
    color: var(--text-muted);
    transition: all 0.15s;
    font-size: 14px;
}

.close-cart:hover {
    color: var(--text-primary);
    background: var(--surface);
}

#cartItems {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
}

#cartItems::-webkit-scrollbar { width: 3px; }
#cartItems::-webkit-scrollbar-track { background: transparent; }
#cartItems::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

.cart-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 220px;
    color: var(--text-muted);
    font-size: 13px;
    gap: 10px;
}

.cart-empty-icon { font-size: 36px; opacity: 0.5; }

.cart-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 0;
    border-bottom: 1px solid var(--border-light);
}

.cart-item:last-child { border-bottom: none; }

.cart-item img {
    width: 60px; height: 60px;
    background: var(--off-white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-sm);
    padding: 6px;
    object-fit: contain;
    flex-shrink: 0;
}

.cart-item-info { flex: 1; min-width: 0; }

.cart-item-info strong {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-bottom: 4px;
}

.cart-item-meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.cart-item-qty {
    font-size: 11px;
    color: var(--text-muted);
    font-family: 'DM Mono', monospace;
    background: var(--surface);
    padding: 2px 7px;
    border-radius: 3px;
}

.cart-item-price {
    color: var(--accent);
    font-weight: 800;
    font-size: 13px;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0;
}

.remove-item {
    background: transparent;
    border: none;
    color: var(--text-muted);
    cursor: pointer;
    font-size: 13px;
    width: 26px; height: 26px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 4px;
    transition: all 0.15s;
    flex-shrink: 0;
}

.remove-item:hover { color: #EF4444; background: #FEF2F2; }

.cart-footer {
    padding: 20px;
    background: var(--off-white);
    border-top: 1px solid var(--border-light);
}

.total-container {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    margin-bottom: 14px;
}

.total-container h3 {
    font-size: 11px;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.8px;
}

.total-amount {
    font-size: 20px;
    color: var(--text-primary);
    font-weight: 800;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0;
}

.checkout-btn {
    width: 100%;
    padding: 13px;
    background: var(--accent);
    color: white;
    font-weight: 600;
    font-size: 12px;
    letter-spacing: 0.8px;
    text-transform: uppercase;
    border: none;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: 'DM Sans', sans-serif;
}

.checkout-btn:hover {
    background: var(--accent-dark);
    box-shadow: 0 4px 14px rgba(26,86,219,0.28);
    transform: translateY(-1px);
}

/* ================= PROFILE DROPDOWN ================= */
.profile-wrapper { position: relative; }

.profile-btn {
    cursor: pointer;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    border: 1.5px solid var(--border);
    background: var(--white);
    transition: all 0.2s ease;
    padding: 0;
    overflow: hidden;
}
.profile-btn:hover {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
}
.profile-btn.open {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(26,86,219,0.15);
}
.profile-btn-avatar {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    font-weight: 700;
    color: var(--accent);
    font-family: 'DM Mono', monospace;
    letter-spacing: 0.5px;
    background: var(--accent-light);
}
.profile-dropdown {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    width: 220px;
    background: var(--white);
    border-radius: 12px;
    border: 1px solid var(--border);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,0.15), 0 4px 10px -5px rgba(0,0,0,0.05);
    z-index: 1100;
    opacity: 0;
    visibility: hidden;
    transform: translateY(8px);
    transition: all 0.25s cubic-bezier(0.16,1,0.3,1);
    overflow: hidden;
}
.profile-dropdown.open {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}
.pd-header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-light);
    background: #FAFAFB;
}
.pd-username {
    font-size: 14px; font-weight: 600;
    color: var(--text-primary); line-height: 1.2;
}
.pd-status {
    font-size: 11px; color: var(--text-muted);
    font-weight: 500; margin-top: 4px;
}
.pd-nav { padding: 8px; }
.pd-item, .pd-logout {
    display: block; width: 100%;
    padding: 10px 14px;
    font-size: 13px; font-weight: 500;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.15s ease;
    border: none; background: transparent;
    text-align: left; cursor: pointer;
}
.pd-item:hover { background: var(--off-white); color: var(--accent); }
.pd-footer { padding: 8px; border-top: 1px solid var(--border-light); }
.pd-logout { color: #DC2626; }
.pd-logout:hover { background: #FEF2F2; color: #991B1B; }

/* ================= HERO ================= */
.hero {
    position: relative;
    height: 64vh;
    min-height: 420px;
    width: 100%;
    display: flex;
    align-items: center;
    overflow: hidden;
    margin-top: 58px;
    background: var(--hero-bg);
}

/* Subtle grid texture */
.hero::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
    background-size: 48px 48px;
    z-index: 1;
}

/* Gradient overlay from left */
.hero::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(105deg, rgba(13,17,23,0.95) 0%, rgba(13,17,23,0.7) 55%, rgba(13,17,23,0.1) 100%);
    z-index: 2;
}

.hero video {
    position: absolute;
    inset: 0;
    width: 100%; height: 100%;
    object-fit: cover;
    opacity: 0.45;
}

.hero-content {
    position: relative;
    z-index: 3;
    padding-left: 80px;
    max-width: 640px;
}

.hero-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(26,86,219,0.15);
    border: 1px solid rgba(26,86,219,0.3);
    color: #7BA7F5;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    padding: 5px 12px;
    border-radius: 20px;
    margin-bottom: 22px;
    font-family: 'DM Mono', monospace;
}

.hero-eyebrow::before {
    content: '';
    width: 6px; height: 6px;
    border-radius: 50%;
    background: #3B82F6;
    animation: pulse-dot 2s ease-in-out infinite;
}

@keyframes pulse-dot {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.5; transform: scale(0.7); }
}

.hero-title {
    font-size: 58px;
    font-weight: 700;
    line-height: 1.05;
    color: #FFFFFF;
    margin-bottom: 18px;
    letter-spacing: -1.5px;
}

.hero-title span { color: #3B82F6; }

.hero-desc {
    font-size: 16px;
    color: #8B9BB5;
    margin-bottom: 8px;
    line-height: 1.65;
    font-weight: 300;
}

.hero-offer {
    font-size: 14px;
    font-weight: 600;
    color: #3B82F6;
    margin-bottom: 36px;
    letter-spacing: 0.2px;
}

.hero-buttons { display: flex; gap: 12px; }

.btn {
    padding: 12px 28px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    border-radius: var(--radius-sm);
    letter-spacing: 0.3px;
    font-family: 'DM Sans', sans-serif;
}

.btn-primary {
    background: var(--accent);
    color: white;
    border: none;
    box-shadow: 0 2px 8px rgba(26,86,219,0.3);
}

.btn-primary:hover {
    background: var(--accent-dark);
    box-shadow: 0 4px 16px rgba(26,86,219,0.4);
    transform: translateY(-1px);
}

.btn-ghost {
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.14);
    color: #E2E8F0;
    backdrop-filter: blur(8px);
}

.btn-ghost:hover {
    background: rgba(255,255,255,0.1);
    border-color: rgba(255,255,255,0.25);
    color: #FFFFFF;
}

/* ================= SECTION ================= */
.section-wrap {
    padding: 0 56px;
    margin-top: 60px;
}

.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 28px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border);
}

.section-title {
    font-family: 'DM Mono', monospace;
    font-size: 13px;
    font-weight: 500;
    color: var(--text-primary);
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.section-title::before {
    content: '';
    display: block;
    width: 3px; height: 16px;
    background: var(--accent);
    border-radius: 2px;
}

.section-count {
    font-size: 11px;
    color: var(--text-muted);
    background: var(--surface);
    padding: 2px 8px;
    border-radius: 10px;
    font-family: 'DM Mono', monospace;
}

/* ================= PRODUCTS GRID ================= */
.products-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
}

/* ================= PRODUCT CARD ================= */
.product-card {
    background: var(--white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius);
    display: flex;
    flex-direction: column;
    box-shadow: var(--shadow-sm);
    transition: all 0.22s ease;
    overflow: hidden;
}

.product-card:hover {
    border-color: var(--border);
    box-shadow: var(--shadow-md);
    transform: translateY(-3px);
}

.product-img-wrap {
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--off-white);
    border-bottom: 1px solid var(--border-light);
    position: relative;
    overflow: hidden;
}

.product-badge {
    position: absolute;
    top: 10px; left: 10px;
    background: var(--accent);
    color: white;
    font-size: 10px;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 3px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    font-family: 'DM Mono', monospace;
}

.product-img {
    max-width: 80%;
    max-height: 80%;
    object-fit: contain;
    transition: transform 0.3s ease;
}

.product-card:hover .product-img {
    transform: scale(1.04);
}

.product-info { padding: 16px 18px 18px; }

.product-category {
    font-size: 10px;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-bottom: 5px;
    font-family: 'DM Mono', monospace;
}

.product-name {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 10px;
    line-height: 1.3;
}

.product-price-row {
    display: flex;
    align-items: baseline;
    gap: 8px;
    margin-bottom: 14px;
}

.product-price {
    color: var(--text-primary);
    font-weight: 700;
    font-size: 18px;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0;
    margin-bottom: 12px;
}

.product-actions { display: flex; gap: 8px; }

/* ================= CART BUTTON ================= */
.btn-cart {
    flex: 1;
    padding: 9px 12px;
    background: var(--accent);
    border: none;
    color: #FFFFFF;
    font-weight: 600;
    font-size: 11px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    cursor: pointer;
    border-radius: var(--radius-sm);
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    font-family: 'DM Sans', sans-serif;
    box-shadow: 0 1px 4px rgba(26,86,219,0.2);
}

.btn-cart:hover {
    background: var(--accent-dark);
    box-shadow: 0 3px 10px rgba(26,86,219,0.3);
    transform: translateY(-1px);
}

.btn-cart:active { transform: translateY(0); }

.btn-cart.added {
    background: var(--success);
    box-shadow: 0 2px 6px rgba(22,163,74,0.25);
}

.btn-buy {
    padding: 9px 14px;
    background: transparent;
    border: 1px solid var(--border);
    color: var(--text-secondary);
    cursor: pointer;
    border-radius: var(--radius-sm);
    transition: all 0.2s;
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-family: 'DM Sans', sans-serif;
    white-space: nowrap;
}

.btn-buy:hover {
    border-color: var(--accent);
    color: var(--accent);
    background: var(--accent-light);
}

/* ================= FOOTER ================= */
footer { padding: 60px 56px 28px; background: #ffffff; }
.footer-top {
  display: grid; grid-template-columns: 1.6fr 1fr 1fr 1fr;
  gap: 48px; margin-bottom: 44px;
}
.footer-brand .logo { display: block; margin-bottom: 12px; font-size: 1.05rem; }
.footer-desc {
  font-size: 0.82rem; color: #A3A3A3;
  line-height: 1.75; font-weight: 300; max-width: 250px;
}
.footer-col h4 {
  font-size: 0.83rem; font-weight: 700;
  color: #0A0A0A; margin-bottom: 16px;
}
.footer-col ul { list-style: none; display: flex; flex-direction: column; gap: 9px; }
.footer-col ul li a {
  font-size: 0.82rem; color: #A3A3A3;
  text-decoration: none; transition: color 0.2s;
}
.footer-col ul li a:hover { color: #0A0A0A; }
.footer-bottom {
  border-top: 1px solid #EBEBEB; padding-top: 22px;
  display: flex; justify-content: flex-end;
  align-items: center; flex-wrap: wrap; gap: 14px;
}
.footer-socials { display: flex; gap: 9px; }
.fsoc {
  width: 33px; height: 33px; border: 1px solid #EBEBEB;
  border-radius: 8px; display: flex; align-items: center;
  justify-content: center; text-decoration: none;
  color: #A3A3A3; transition: all 0.2s;
}
.fsoc:hover { border-color: #A3A3A3; color: #0A0A0A; }
.fsoc svg { width: 13px; height: 13px; fill: currentColor; }
@media (max-width: 1080px) { .footer-top { grid-template-columns: 1fr 1fr; } }
@media (max-width: 768px)  { .footer-top { grid-template-columns: 1fr; } .footer-bottom { flex-direction: column; align-items: flex-start; } }

/* ================= RESPONSIVE ================= */
@media (max-width: 1100px) {
    .products-grid { grid-template-columns: repeat(3, 1fr); }
    .section-wrap { padding: 0 32px; }
}
@media (max-width: 850px) {
    .products-grid { grid-template-columns: repeat(2, 1fr); }
    .hero-title { font-size: 42px; }
    .hero-content { padding-left: 40px; }
    .navbar { padding: 0 24px; }
}
@media (max-width: 600px) {
    .products-grid { grid-template-columns: 1fr; }
    .hero-content { padding-left: 24px; }
    .section-wrap { padding: 0 20px; }
}

/* ================= SCROLL MARGIN ================= */
#best-sellers { scroll-margin-top: 70px; }

</style>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
<script>
    const isLoggedIn = ${isLoggedIn};
    const CTX = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <div class="logo">Digital<span>_</span>Bazaar</div>
    <%
    String uri = request.getRequestURI();
%>
<ul class="nav-links">
    <li><a href="${pageContext.request.contextPath}/dashboard"
           class="<%= uri.contains("/dashboard") ? "active" : "" %>">Home</a></li>
    <li><a href="${pageContext.request.contextPath}/shop"
           class="<%= uri.contains("/shop") ? "active" : "" %>">Shop</a></li>
    <li><a href="${pageContext.request.contextPath}/build-pc"
           class="<%= uri.contains("/build-pc") ? "active" : "" %>">PC Builder</a></li>
    <li><a href="${pageContext.request.contextPath}/about-us"
           class="<%= uri.contains("/about-us") ? "active" : "" %>">About Us</a></li>
    <li><a href="${pageContext.request.contextPath}/about-us#contact"
           class="<%= uri.contains("/about-us#contact") ? "active" : "" %>">Contact Us</a></li>
</ul>
    <div class="nav-icons">
        <button class="icon-btn" onclick="toggleCart()" aria-label="Cart">
            🛒<span class="cart-count">0</span>
        </button>
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
                <a href="${pageContext.request.contextPath}/dashboard#track" class="pd-item">My Orders</a>
                <a href="${pageContext.request.contextPath}/shop" class="pd-item">Shop Products</a>
                <a href="#" class="pd-item" onclick="toggleCart(); toggleProfile(); return false;">View Cart</a>
                <a href="${pageContext.request.contextPath}/build-pc" class="pd-item">PC Builder</a>
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

<c:if test="${orderSuccess}">
    <div style="position:fixed;top:68px;left:50%;transform:translateX(-50%);
        background:#16A34A;color:white;padding:10px 24px;border-radius:6px;
        font-weight:600;font-size:13px;z-index:2000;box-shadow:0 4px 12px rgba(0,0,0,0.15);" id="successToast">
        ✔ Order placed successfully!
    </div>
</c:if>
<c:if test="${orderError}">
    <div style="position:fixed;top:68px;left:50%;transform:translateX(-50%);
        background:#EF4444;color:white;padding:10px 24px;border-radius:6px;
        font-weight:600;font-size:13px;z-index:2000;box-shadow:0 4px 12px rgba(0,0,0,0.15);" id="errorToast">
        ✕ Something went wrong. Please try again.
    </div>
</c:if>

<!-- ================= CART SIDEBAR ================= -->
<div class="cart-sidebar" id="cartSidebar">
    <div class="cart-header">
        <h2>Your Cart</h2>
        <span class="close-cart" onclick="toggleCart()">✕</span>
    </div>
    <div id="cartItems">
        <div class="cart-empty" id="cartEmpty">
            <div class="cart-empty-icon">🛒</div>
            <div>Your cart is empty</div>
        </div>
    </div>
    <div class="cart-footer">
        <div class="total-container">
            <h3>Total</h3>
            <span class="total-amount">₨ <span id="totalPrice">0.00</span></span>
        </div>
        <button class="checkout-btn" onclick="handleCheckout()">Proceed to Checkout</button>
    </div>
</div>

<!-- ================= HERO ================= -->
<div class="hero">
    <img src="${pageContext.request.contextPath}/images/hero.png"
         alt="Hero"
         style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0.45;">
    <div class="hero-content">
        <div class="hero-eyebrow">New Season Drop</div>
        <div class="hero-title">
            NEW SEASON<br>
            <span>COLLECTION</span>
        </div>
        <div class="hero-desc">
            Performance redefined. Secure the latest high-end hardware.
        </div>
        <div class="hero-offer">Up to 50% Off Today.</div>
        <div class="hero-buttons">
            <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/shop'">
                Shop Now
            </button>
            <button class="btn btn-ghost" onclick="document.getElementById('best-sellers').scrollIntoView({behavior:'smooth'})">
                Explore Collection
            </button>
        </div>
    </div>
</div>

<!-- ================= BEST SELLERS ================= -->
<div class="section-wrap" id="best-sellers">
    <div class="section-header">
        <div class="section-title">BEST_SELLERS
            <span class="section-count">
                <%= ((List<Product>)request.getAttribute("bestSellers")) != null
                    ? ((List<Product>)request.getAttribute("bestSellers")).size() : 0 %>
            </span>
        </div>
    </div>
    <div class="products-grid" id="best-sellers-grid">
    <c:choose>
    <c:when test="${not empty bestSellers}">
        <c:forEach var="p" items="${bestSellers}" varStatus="status">
            <div class="product-card"
                 data-product-id="${p.id}"
                 data-name="${p.name}"
                 data-price="${p.price}"
                 data-img="${pageContext.request.contextPath}/images/${p.image}"
                 data-stock="${p.stock}">
                <div class="product-img-wrap">
                    <c:if test="${status.first}">
                        <span class="product-badge">Top Pick</span>
                    </c:if>
                    <img src="${pageContext.request.contextPath}/images/${p.image}"
                         class="product-img" alt="${p.name}">
                </div>
                <div class="product-info">
                    <div class="product-category">${p.category}</div>
                    <div class="product-name">${p.name}</div>
                    <div class="product-price-row">
                        <span class="product-price">₨ ${p.price}</span>
                    </div>
                    <div class="product-actions">
                        <c:choose>
                            <c:when test="${p.stock == 0}">
                                <button class="btn-cart" disabled style="opacity:0.4;cursor:not-allowed;background:#94a3b8;">Out of Stock</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-cart" onclick="addToCart(this)">🛒 Add to Cart</button>
                                <button class="btn-buy" onclick="handleBuyNow(this)">Buy Now</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div style="grid-column:1/-1;text-align:center;color:#9BA5B7;padding:40px;">
            No featured products found.
        </div>
    </c:otherwise>
</c:choose>
    </div>
</div>

<!-- ================= NEW ARRIVALS ================= -->
<div class="section-wrap" style="margin-top: 52px; margin-bottom: 80px;">
    <div class="section-header">
        <div class="section-title">NEW_ARRIVALS
            <span class="section-count">
                <%= ((List<Product>)request.getAttribute("newArrivals")) != null
                    ? ((List<Product>)request.getAttribute("newArrivals")).size() : 0 %>
            </span>
        </div>
    </div>
    <div class="products-grid">
    <%
        List<Product> newArrivals = (List<Product>) request.getAttribute("newArrivals");
        if (newArrivals != null && !newArrivals.isEmpty()) {
            for (Product p : newArrivals) {
    %>
        <div class="product-card"
		     data-product-id="<%= p.getId() %>"
		     data-name="<%= p.getName() %>"
		     data-price="<%= p.getPrice() %>"
		     data-img="<%= request.getContextPath() %>/images/<%= p.getImage() %>"
		     data-stock="<%= p.getStock() %>">
            <div class="product-img-wrap">
                <span class="product-badge">New</span>
                <img src="<%= request.getContextPath() %>/images/<%= p.getImage() %>"
                     class="product-img" alt="<%= p.getName() %>">
            </div>
            <div class="product-info">
                <div class="product-category"><%= p.getCategory() %></div>
                <div class="product-name"><%= p.getName() %></div>
                <div class="product-price-row">
                    <span class="product-price">₨ <%= formatNPR(p.getPrice()) %></span>
                </div>
                <div class="product-actions">
				    <% if (p.getStock() == 0) { %>
				        <button class="btn-cart" disabled style="opacity:0.4;cursor:not-allowed;background:#94a3b8;">Out of Stock</button>
				    <% } else { %>
				        <button class="btn-cart" onclick="addToCart(this)">🛒 Add to Cart</button>
				        <button class="btn-buy" onclick="handleBuyNow(this)">Buy Now</button>
				    <% } %>
				</div>
            </div>
        </div>
    <%
            }
        } else {
    %>
        <div style="grid-column:1/-1;text-align:center;color:#9BA5B7;padding:40px;">
            No new arrivals found.
        </div>
    <% } %>
    </div>
</div>

<div class="section-wrap" id="track" style="margin-bottom: 80px;">
    <div class="section-header">
        <div class="section-title">MY_ORDERS</div>
    </div>
    <c:choose>
    <c:when test="${not isLoggedIn}">
        <p style="color:#9BA5B7;font-size:13px;">Please <a href="${pageContext.request.contextPath}/login">login</a> to see your orders.</p>
    </c:when>
    <c:when test="${not empty orderHistory}">
        <table style="width:100%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.06);">
            <thead><tr style="background:#F2F4F7;">
                <th style="padding:12px 16px;text-align:left;font-size:11px;color:#9BA5B7;">Order ID</th>
                <th style="padding:12px 16px;text-align:left;font-size:11px;color:#9BA5B7;">Product</th>
                <th style="padding:12px 16px;text-align:left;font-size:11px;color:#9BA5B7;">Qty</th>
                <th style="padding:12px 16px;text-align:left;font-size:11px;color:#9BA5B7;">Total</th>
                <th style="padding:12px 16px;text-align:left;font-size:11px;color:#9BA5B7;">Date</th>
            </tr></thead>
            <tbody>
                <c:forEach var="o" items="${orderHistory}">
                    <tr style="border-top:1px solid #EEF0F4;">
                        <td style="padding:12px 16px;font-size:13px;">#${o.id}</td>
                        <td style="padding:12px 16px;font-size:13px;">${o.product}</td>
                        <td style="padding:12px 16px;font-size:13px;">${o.qty}</td>
                        <td style="padding:12px 16px;font-size:13px;">₨ ${o.total}</td>
                        <td style="padding:12px 16px;font-size:13px;">${o.date}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <p style="color:#9BA5B7;font-size:13px;">No orders yet.</p>
    </c:otherwise>
</c:choose>
</div>

<!-- ================= FOOTER ================= -->
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

<!-- ================= CART JAVASCRIPT (paste into shop.jsp, dashboard.jsp, test.jsp) ================= -->
<script>
</script>
<div id="loginModal" style="display:none;position:fixed;inset:0;background:rgba(13,17,23,0.55);z-index:9999;align-items:center;justify-content:center;">
  <div style="background:#fff;border-radius:12px;border:1px solid #E4E7EC;width:340px;overflow:hidden;box-shadow:0 24px 60px rgba(13,17,23,0.18);animation:modalUp 0.25s ease;font-family:'DM Sans',sans-serif;">
    <div style="padding:24px 24px 0;display:flex;align-items:flex-start;justify-content:space-between;">
      
      <button onclick="closeLoginModal()" style="background:transparent;border:none;color:#9BA5B7;cursor:pointer;font-size:18px;line-height:1;">✕</button>
    </div>
    <div style="padding:16px 24px 24px;">
      <div style="font-size:16px;font-weight:700;color:#0D1117;margin-bottom:6px;">Sign in required</div>
      <div style="font-size:13px;color:#5A6478;margin-bottom:20px;line-height:1.6;">You need to be logged in to add items to your cart or make a purchase.</div>
      <a href="/login" id="modalLoginBtn" style="display:block;width:100%;padding:11px;background:#1A56DB;color:#fff;text-align:center;border-radius:5px;font-weight:600;font-size:13px;text-decoration:none;letter-spacing:0.4px;box-sizing:border-box;">Log In</a>
      <a href="/register" id="modalRegisterBtn" style="display:block;width:100%;padding:11px;background:transparent;border:1px solid #E4E7EC;color:#5A6478;text-align:center;border-radius:5px;font-weight:600;font-size:13px;text-decoration:none;letter-spacing:0.4px;margin-top:8px;box-sizing:border-box;">Create Account</a>
    </div>
  </div>
</div>
<style>
@keyframes modalUp {
  from { opacity:0; transform:translateY(12px); }
  to   { opacity:1; transform:translateY(0); }
}
</style>
<div id="cartEmptyModal" style="display:none;position:fixed;inset:0;background:rgba(13,17,23,0.55);z-index:9999;align-items:center;justify-content:center;">
  <div onclick="event.stopPropagation()" style="background:#fff;border-radius:12px;border:1px solid #E4E7EC;width:340px;overflow:hidden;box-shadow:0 24px 60px rgba(13,17,23,0.18);animation:modalUp 0.25s ease;font-family:'DM Sans',sans-serif;">
    <div style="padding:28px 24px 0;">
      <div style="width:44px;height:44px;background:#FEF9EC;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:22px;margin-bottom:16px;">🛒</div>
      <div style="font-size:16px;font-weight:700;color:#0D1117;margin-bottom:6px;">Your cart is empty</div>
      <div style="font-size:13px;color:#5A6478;margin-bottom:20px;line-height:1.6;">Add some products to your cart before proceeding to checkout.</div>
    </div>
    <div style="padding:0 24px 24px;display:flex;gap:8px;">
      <button onclick="closeCartEmptyModal()" style="flex:1;padding:11px;background:#F2F4F7;border:1px solid #E4E7EC;border-radius:5px;color:#5A6478;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;">Dismiss</button>
      <button onclick="closeCartEmptyModal();window.location.href=CTX+'/shop'" style="flex:1;padding:11px;background:#1A56DB;border:none;border-radius:5px;color:#fff;font-size:13px;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;">Go to Shop</button>
    </div>
  </div>
</div>
</body>
</html>
