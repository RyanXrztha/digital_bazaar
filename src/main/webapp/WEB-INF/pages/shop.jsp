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
<%@ page import="java.util.List, com.DigitalBazaar.model.Product, com.DigitalBazaar.model.User" %>
<%
Boolean loggedIn = (Boolean) request.getAttribute("isLoggedIn");
User userObj = (User) session.getAttribute("user");
String sessionUsername = (userObj != null) ? userObj.getUsername() : null;
// If your User model uses getFullName() or getName(), use that instead
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
<title>Shop — Digital Bazaar</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>

/* ================= VARIABLES (identical to dashboard) ================= */
:root {
    --white:        #FFFFFF;
    --off-white:    #F8F9FB;
    --surface:      #F2F4F7;
    --border:       #E4E7EC;
    --border-light: #EEF0F4;
    --text-primary: #0D1117;
    --text-secondary:#5A6478;
    --text-muted:   #9BA5B7;
    --accent:       #1A56DB;
    --accent-dark:  #1240A8;
    --accent-light: #EBF0FD;
    --success:      #16A34A;
    --hero-bg:      #0D1117;
    --shadow-sm:    0 1px 3px rgba(13,17,23,0.06), 0 1px 2px rgba(13,17,23,0.04);
    --shadow-md:    0 4px 12px rgba(13,17,23,0.08), 0 2px 6px rgba(13,17,23,0.04);
    --radius:       8px;
    --radius-sm:    5px;
    --sidebar-w:    224px;
}

*, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

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
    width: 36px; height: 36px;
    display: flex; align-items: center; justify-content: center;
    border-radius: var(--radius-sm);
    color: var(--text-secondary);
    transition: all 0.15s ease;
    position: relative;
    font-size: 16px;
    border: none;
    background: transparent;
}
.icon-btn:hover { background: var(--surface); color: var(--text-primary); }

.cart-count {
    position: absolute;
    top: 2px; right: 2px;
    background: var(--accent);
    color: white;
    font-size: 9px; font-weight: 700;
    min-width: 16px; height: 16px;
    padding: 0 4px;
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
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
    display: flex; flex-direction: column;
    transition: right 0.38s cubic-bezier(0.4,0,0.2,1);
    z-index: 999;
    box-shadow: -8px 0 32px rgba(13,17,23,0.08);
}
.cart-sidebar.active { right: 0; }

.cart-header {
    padding: 20px 24px;
    border-bottom: 1px solid var(--border-light);
    display: flex; justify-content: space-between; align-items: center;
}
.cart-header h2 {
    font-size: 13px; font-weight: 600;
    color: var(--text-primary);
    letter-spacing: 0.8px; text-transform: uppercase;
    font-family: 'DM Mono', monospace;
}
.close-cart {
    cursor: pointer;
    width: 28px; height: 28px;
    display: flex; align-items: center; justify-content: center;
    border-radius: 4px;
    color: var(--text-muted);
    transition: all 0.15s; font-size: 14px;
}
.close-cart:hover { color: var(--text-primary); background: var(--surface); }

#cartItems { flex: 1; overflow-y: auto; padding: 16px; }
#cartItems::-webkit-scrollbar { width: 3px; }
#cartItems::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

.cart-empty {
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    height: 220px; color: var(--text-muted);
    font-size: 13px; gap: 10px;
}
.cart-empty-icon { font-size: 36px; opacity: 0.5; }

.cart-item {
    display: flex; align-items: center; gap: 12px;
    padding: 12px 0;
    border-bottom: 1px solid var(--border-light);
}
.cart-item:last-child { border-bottom: none; }
.cart-item img {
    width: 60px; height: 60px;
    background: var(--off-white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-sm);
    padding: 6px; object-fit: contain; flex-shrink: 0;
}
.cart-item-info { flex: 1; min-width: 0; }
.cart-item-info strong {
    display: block; font-size: 13px; font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    margin-bottom: 4px;
}
.cart-item-meta { display: flex; align-items: center; justify-content: space-between; }
.cart-item-qty {
    font-size: 11px; color: var(--text-muted);
    font-family: 'DM Mono', monospace;
    background: var(--surface); padding: 2px 7px; border-radius: 3px;
}
.cart-item-price {
    color: var(--accent);
    font-weight: 800;
    font-size: 13px;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0;
}
.remove-item {
    background: transparent; border: none;
    color: var(--text-muted); cursor: pointer;
    font-size: 13px; width: 26px; height: 26px;
    display: flex; align-items: center; justify-content: center;
    border-radius: 4px; transition: all 0.15s; flex-shrink: 0;
}
.remove-item:hover { color: #EF4444; background: #FEF2F2; }

.cart-footer {
    padding: 20px;
    background: var(--off-white);
    border-top: 1px solid var(--border-light);
}
.total-container {
    display: flex; justify-content: space-between; align-items: baseline;
    margin-bottom: 14px;
}
.total-container h3 {
    font-size: 11px; font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 0.8px;
}
.total-amount {
    font-size: 20px;
    color: var(--text-primary);
    font-weight: 800;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0;
}
.checkout-btn {
    width: 100%; padding: 13px;
    background: var(--accent); color: white;
    font-weight: 600; font-size: 12px;
    letter-spacing: 0.8px; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm);
    cursor: pointer; transition: all 0.2s ease;
    font-family: 'DM Sans', sans-serif;
}
.checkout-btn:hover {
    background: var(--accent-dark);
    box-shadow: 0 4px 14px rgba(26,86,219,0.28);
    transform: translateY(-1px);
}

/* ================= REFINED PROFILE DROPDOWN ================= */
/* ================= PROFESSIONAL PROFILE DROPDOWN ================= */
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
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
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
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    line-height: 1.2;
}

.pd-status {
    font-size: 11px;
    color: var(--text-muted);
    font-weight: 500;
    margin-top: 4px;
}

.pd-nav { padding: 8px; }

.pd-item, .pd-logout {
    display: block;
    width: 100%;
    padding: 10px 14px;
    font-size: 13px;
    font-weight: 500;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.15s ease;
    border: none;
    background: transparent;
    text-align: left;
    cursor: pointer;
}

.pd-item:hover {
    background: var(--off-white);
    color: var(--accent);
}

.pd-footer {
    padding: 8px;
    border-top: 1px solid var(--border-light);
}

.pd-logout {
    color: #DC2626;
}

.pd-logout:hover {
    background: #FEF2F2;
    color: #991B1B;
}

/* ================= HERO ================= */
.hero {
    margin-top: 58px;
    height: 300px;
    background: var(--hero-bg);
    display: flex; align-items: center;
    position: relative;
    overflow: hidden;
}
.hero::before {
    content: '';
    position: absolute; inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
    background-size: 48px 48px;
}
.hero::after {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(105deg, rgba(13,17,23,0.95) 0%, rgba(13,17,23,0.5) 70%, transparent 100%);
}
.hero-content {
    position: relative;
    z-index: 2;
    padding-left: 80px;
}

.hero-eyebrow {
    display: inline-flex; align-items: center; gap: 8px;
    background: rgba(26,86,219,0.15);
    border: 1px solid rgba(26,86,219,0.3);
    color: #7BA7F5;
    font-size: 11px; font-weight: 600;
    letter-spacing: 1.2px; text-transform: uppercase;
    padding: 5px 12px; border-radius: 20px;
    margin-bottom: 16px;
    font-family: 'DM Mono', monospace;
}
.hero-eyebrow::before {
    content: ''; width: 6px; height: 6px;
    border-radius: 50%; background: #3B82F6;
    animation: pulse-dot 2s ease-in-out infinite;
}
@keyframes pulse-dot {
    0%,100% { opacity:1; transform:scale(1); }
    50%      { opacity:0.5; transform:scale(0.7); }
}

.hero-title {
    font-size: 52px; font-weight: 700;
    line-height: 1.05; color: #FFFFFF;
    letter-spacing: -1.5px;
    margin-bottom: 16px;
}

.hero-subtitle {
    margin-top: 14px;
    font-size: 15px;
    line-height: 1.7;
    color: #8B9BB5;
    font-weight: 300;
    max-width: 480px;
}
.hero-title span { color: #3B82F6; }

/* ================= SHOP LAYOUT ================= */
.shop-layout {
    display: flex;
    align-items: flex-start;
    padding: 32px 48px;
    gap: 24px;
    min-height: calc(100vh - 278px);
}

/* ================= LEFT SIDEBAR ================= */
/* ================= LEFT SIDEBAR ================= */
.filter-sidebar {
    width: var(--sidebar-w);
    flex-shrink: 0;
    position: sticky;
    top: 74px;
    background: var(--white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
}

.sidebar-header {
    padding: 16px 18px 12px;
    background: var(--white);
}
.sidebar-header-title {
    font-family: 'DM Mono', monospace;
    font-size: 10px;
    font-weight: 500;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 1.5px;
}

/* Category group */
.filter-group {
    border-top: 1px solid var(--border-light);
}

.filter-group-label {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 11px 18px;
    cursor: pointer;
    user-select: none;
    transition: background 0.15s;
}
.filter-group-label:hover {
    background: var(--off-white);
}

.filter-group-name {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-primary);
    letter-spacing: 0;
    font-family: 'DM Sans', sans-serif;
    text-transform: none;
}

.filter-group-label.active .filter-group-name {
    color: var(--accent);
    font-weight: 600;
}

.chevron {
    color: var(--text-muted);
    font-size: 10px;
    transition: transform 0.2s ease;
}
.filter-group-label.open .chevron {
    transform: rotate(180deg);
}

/* Brand sub-list */
.brand-list {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease;
}
.brand-list.open {
    max-height: 300px;
}

.brand-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 18px 8px 28px;
    cursor: pointer;
    transition: all 0.15s;
    font-size: 13px;
    color: var(--text-secondary);
}
.brand-item::before {
    content: '';
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: var(--border);
    flex-shrink: 0;
    transition: background 0.15s;
}
.brand-item:hover {
    color: var(--text-primary);
    background: var(--off-white);
}
.brand-item:hover::before {
    background: var(--accent);
}
.brand-item.active {
    color: var(--accent);
    font-weight: 600;
    background: var(--accent-light);
}
.brand-item.active::before {
    background: var(--accent);
}

/* Clear filter */
.sidebar-clear {
    padding: 14px 18px;
    border-top: 1px solid var(--border-light);
}
.clear-btn {
    width: 100%;
    padding: 8px;
    background: transparent;
    border: 1px solid var(--border);
    color: var(--text-muted);
    font-size: 12px;
    font-weight: 500;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all 0.15s;
    font-family: 'DM Sans', sans-serif;
    letter-spacing: 0.2px;
}
.clear-btn:hover {
    border-color: var(--accent);
    color: var(--accent);
    background: var(--accent-light);
}

/* ================= PRODUCT AREA ================= */
.product-area { flex: 1; min-width: 0; }

/* Toolbar */
.product-toolbar {
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 20px;
}
.product-count {
    font-family: 'DM Mono', monospace;
    font-size: 12px; color: var(--text-muted);
}
.product-count strong { color: var(--text-primary); font-size: 14px; }

.active-filters {
    display: flex; gap: 6px; flex-wrap: wrap;
}
.filter-tag {
    display: inline-flex; align-items: center; gap: 5px;
    background: var(--accent-light);
    border: 1px solid rgba(26,86,219,0.2);
    color: var(--accent);
    font-size: 11px; font-weight: 600;
    padding: 3px 10px; border-radius: 20px;
    font-family: 'DM Mono', monospace;
}

/* Products grid */
.products-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
}

.category-list {
    list-style: none;
    margin-top: 20px;
}

.category-item {
    display: flex;
    align-items: center;
    padding: 10px 12px;
    margin-bottom: 4px;
    color: #6B7280; /* Professional Gray */
    text-decoration: none;
    font-family: 'Inter', sans-serif;
    font-size: 13px;
    font-weight: 500;
    border-radius: 4px;
    transition: all 0.2s ease;
}

/* Specific Label Styling (CPU, GPU, etc.) */
.category-item span {
    font-family: 'JetBrains Mono', monospace; /* Technical feel for components */
    font-size: 11px;
    letter-spacing: 0.05em;
    text-transform: uppercase;
}

.category-item:hover {
    background: #F3F4F6;
    color: #111827;
}

.category-item.active {
    background: #111827; /* Solid Dark instead of Blue */
    color: #FFFFFF;
}

.price-range-display {
    font-family: 'JetBrains Mono', monospace;
    font-size: 13px;
    font-weight: 600;
    color: #374151; /* Slate Charcoal */
    margin-top: 12px;
}

.filter-group-title {
    font-family: 'Inter', sans-serif;
    font-size: 11px;
    font-weight: 700;
    color: #9CA3AF;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    margin-bottom: 12px;
    padding-left: 12px;
}

/* Ensure currency prefix is consistent */
.price-range-display::before {
    content: "Rs. ";
    color: #9CA3AF; /* Muted prefix */
    font-weight: 400;
}

/* Empty state */
.empty-state {
    grid-column: 1 / -1;
    text-align: center;
    padding: 80px 20px;
    color: var(--text-muted);
}
.empty-icon { font-size: 40px; margin-bottom: 12px; opacity: 0.4; }
.empty-state p { font-size: 13px; }

/* ================= PRODUCT CARD ================= */
.product-card {
    background: var(--white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius);
    display: flex; flex-direction: column;
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
    height: 160px;
    display: flex; align-items: center; justify-content: center;
    background: var(--off-white);
    border-bottom: 1px solid var(--border-light);
    overflow: hidden;
}
.product-img-wrap img {
    max-width: 80%; max-height: 80%;
    object-fit: contain;
    transition: transform 0.3s ease;
}
.product-card:hover .product-img-wrap img { transform: scale(1.05); }

.product-info { padding: 14px 16px 16px; }

.product-category {
    font-size: 10px; font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 0.8px;
    margin-bottom: 4px;
    font-family: 'DM Mono', monospace;
}
.product-name {
    font-size: 13px; font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 10px; line-height: 1.3;
}
.product-price {
    font-size: 17px; font-weight: 700;
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
	letter-spacing: 0;
	gap: 3px;
    margin-bottom: 12px;
}

.product-actions { display: flex; gap: 7px; }

.btn-cart {
    flex: 1;
    padding: 8px 10px;
    background: var(--accent);
    border: none; color: #FFFFFF;
    font-weight: 600; font-size: 11px;
    letter-spacing: 0.4px; text-transform: uppercase;
    cursor: pointer; border-radius: var(--radius-sm);
    transition: all 0.2s ease;
    display: flex; align-items: center; justify-content: center; gap: 5px;
    font-family: 'DM Sans', sans-serif;
    box-shadow: 0 1px 4px rgba(26,86,219,0.2);
}
.btn-cart:hover {
    background: var(--accent-dark);
    box-shadow: 0 3px 10px rgba(26,86,219,0.3);
    transform: translateY(-1px);
}
.btn-cart.added { background: var(--success); }

.btn-buy {
    padding: 8px 12px;
    background: transparent;
    border: 1px solid var(--border);
    color: var(--text-secondary);
    cursor: pointer; border-radius: var(--radius-sm);
    font-size: 11px; font-weight: 600;
    text-transform: uppercase; letter-spacing: 0.4px;
    transition: all 0.2s;
    font-family: 'DM Sans', sans-serif;
    white-space: nowrap;
}
.btn-buy:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }



/* ================= RESPONSIVE ================= */
@media (max-width: 1200px) { .products-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 960px)  { .products-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 720px) {
    .shop-layout { flex-direction: column; padding: 20px; }
    .filter-sidebar { width: 100%; position: static; }
    .products-grid { grid-template-columns: repeat(2, 1fr); }
    .navbar { padding: 0 20px; }
}
@media (max-width: 480px) { .products-grid { grid-template-columns: 1fr; } }

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
        <% if (Boolean.TRUE.equals(loggedIn) && sessionUsername != null ) { %>
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

<!-- ================= CART SIDEBAR ================= -->
<div class="cart-sidebar" id="cartSidebar">
    <div class="cart-header">
        <h2>Your Cart</h2>
        <span class="close-cart" onclick="toggleCart()">✕</span>
    </div>
    <div id="cartItems">
        <div class="cart-empty">
            <div class="cart-empty-icon">🛒</div>
            <div>Your cart is empty</div>
        </div>
    </div>
    <div class="cart-footer">
        <div class="total-container">
            <h3>Total</h3>
            <span class="total-amount">₨ <span id="totalPrice">0</span></span>
        </div>
        <button class="checkout-btn" onclick="handleCheckout()">Proceed to Checkout</button>
    </div>
</div>

<!-- ================= HERO ================= -->
<!-- ================= HERO ================= -->
<div class="hero">
    <img src="${pageContext.request.contextPath}/images/shop.png"
         alt="Hero"
         style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0.45;">
    <div class="hero-content">
        <div class="hero-eyebrow">Hardware Catalog</div>
        <div class="hero-title">OVERCLOCK THE <span>FUTURE</span></div>
        <div class="hero-subtitle">High-performance PC components built for gamers, creators, and enthusiasts.</div>
    </div>
</div>

<!-- ================= SHOP LAYOUT ================= -->
<div class="shop-layout">

    <!-- LEFT SIDEBAR -->
    <aside class="filter-sidebar" id="filterSidebar">
        <div class="sidebar-header">
            <div class="sidebar-header-title">Browse By</div>
        </div>

        <!-- GPU -->
        <div class="filter-group">
            <div class="filter-group-label" onclick="toggleGroup(this, 'GPU')" id="group-GPU">
                <div class="filter-group-name">GPU</div>
                <span class="chevron">▼</span>
            </div>
            <div class="brand-list" id="brands-GPU">
                <div class="brand-item" onclick="selectBrand('GPU','NVIDIA')">
                    <span class="brand-dot"></span>NVIDIA
                </div>
                <div class="brand-item" onclick="selectBrand('GPU','AMD')">
                    <span class="brand-dot"></span>AMD
                </div>
                <div class="brand-item" onclick="selectBrand('GPU','Intel')">
                    <span class="brand-dot"></span>Intel
                </div>
            </div>
        </div>

        <!-- CPU -->
        <div class="filter-group">
            <div class="filter-group-label" onclick="toggleGroup(this, 'CPU')" id="group-CPU">
                <div class="filter-group-name">
                    CPU
                </div>
                <span class="chevron">▼</span>
            </div>
            <div class="brand-list" id="brands-CPU">
                <div class="brand-item" onclick="selectBrand('CPU','AMD')">
                    <span class="brand-dot"></span>AMD
                </div>
                <div class="brand-item" onclick="selectBrand('CPU','Intel')">
                    <span class="brand-dot"></span>Intel
                </div>
            </div>
        </div>

        <!-- RAM -->
        <div class="filter-group">
            <div class="filter-group-label" onclick="toggleGroup(this, 'RAM')" id="group-RAM">
                <div class="filter-group-name">
                    RAM
                </div>
                <span class="chevron">▼</span>
            </div>
            <div class="brand-list" id="brands-RAM">
                <div class="brand-item" onclick="selectBrand('RAM','Corsair')">
                    <span class="brand-dot"></span>Corsair
                </div>
                <div class="brand-item" onclick="selectBrand('RAM','Kingston')">
                    <span class="brand-dot"></span>Kingston
                </div>
                <div class="brand-item" onclick="selectBrand('RAM','ADATA')">
                    <span class="brand-dot"></span>ADATA
                </div>
                <div class="brand-item" onclick="selectBrand('RAM','G.Skill')">
                    <span class="brand-dot"></span>G.Skill
                </div>
            </div>
        </div>

        <!-- Storage -->
        <div class="filter-group">
            <div class="filter-group-label" onclick="toggleGroup(this, 'Storage')" id="group-Storage">
                <div class="filter-group-name">
                    Storage
                </div>
                <span class="chevron">▼</span>
            </div>
            <div class="brand-list" id="brands-Storage">
                <div class="brand-item" onclick="selectBrand('Storage','Samsung')">
                    <span class="brand-dot"></span>Samsung
                </div>
                <div class="brand-item" onclick="selectBrand('Storage','WD')">
                    <span class="brand-dot"></span>WD
                </div>
                <div class="brand-item" onclick="selectBrand('Storage','Seagate')">
                    <span class="brand-dot"></span>Seagate
                </div>
            </div>
        </div>

        <!-- Motherboard -->
        <div class="filter-group">
            <div class="filter-group-label" onclick="toggleGroup(this, 'Motherboard')" id="group-Motherboard">
                <div class="filter-group-name">
                    Motherboard
                </div>
                <span class="chevron">▼</span>
            </div>
            <div class="brand-list" id="brands-Motherboard">
                <div class="brand-item" onclick="selectBrand('Motherboard','ASUS')">
                    <span class="brand-dot"></span>ASUS
                </div>
                <div class="brand-item" onclick="selectBrand('Motherboard','MSI')">
                    <span class="brand-dot"></span>MSI
                </div>
                <div class="brand-item" onclick="selectBrand('Motherboard','Gigabyte')">
                    <span class="brand-dot"></span>Gigabyte
                </div>
            </div>
        </div>
        
        <!-- Cooler -->
		<div class="filter-group">
		    <div class="filter-group-label" onclick="toggleGroup(this, 'Cooler')" id="group-Cooler">
		        <div class="filter-group-name">Cooler</div>
		        <span class="chevron">▼</span>
		    </div>
		    <div class="brand-list" id="brands-Cooler">
		        <div class="brand-item" onclick="selectBrand('Cooler','Noctua')">Noctua</div>
		        <div class="brand-item" onclick="selectBrand('Cooler','NZXT')">NZXT</div>
		    </div>
		</div>
		
		<!-- PSU -->
		<div class="filter-group">
		    <div class="filter-group-label" onclick="toggleGroup(this, 'PSU')" id="group-PSU">
		        <div class="filter-group-name">PSU</div>
		        <span class="chevron">▼</span>
		    </div>
		    <div class="brand-list" id="brands-PSU">
		        <div class="brand-item" onclick="selectBrand('PSU','Seasonic')">Seasonic</div>
		        <div class="brand-item" onclick="selectBrand('PSU','Corsair')">Corsair</div>
		        <div class="brand-item" onclick="selectBrand('PSU','EVGA')">EVGA</div>
		    </div>
		</div>
		
		<!-- Case -->
		<div class="filter-group">
		    <div class="filter-group-label" onclick="toggleGroup(this, 'Case')" id="group-Case">
		        <div class="filter-group-name">Case</div>
		        <span class="chevron">▼</span>
		    </div>
		    <div class="brand-list" id="brands-Case">
		        <div class="brand-item" onclick="selectBrand('Case','Lian Li')">Lian Li</div>
		        <div class="brand-item" onclick="selectBrand('Case','Corsair')">Corsair</div>
		        <div class="brand-item" onclick="selectBrand('Case','Fractal')">Fractal</div>
		        <div class="brand-item" onclick="selectBrand('Case','NZXT')">NZXT</div>
		    </div>
		</div>

        <div class="sidebar-clear">
            <button class="clear-btn" onclick="clearFilters()">Clear All Filters</button>
        </div>
    </aside>

    <!-- RIGHT PRODUCT AREA -->
    <div class="product-area">
        <!-- Toolbar -->
        <div class="product-toolbar">
            <div class="product-count">
                Showing <strong id="countVisible">0</strong> products
            </div>
            <div class="active-filters" id="activeFilters"></div>
        </div>

        <!-- Grid -->
        <div class="products-grid" id="productsGrid">
<c:choose>
    <c:when test="${not empty products}">
        <c:forEach var="p" items="${products}">
            <div class="product-card"
                 data-product-id="${p.id}"
                 data-name="${p.name}"
                 data-category="${p.category}"
                 data-brand="${p.brand}"
                 data-price="${p.price}"
                 data-img="${pageContext.request.contextPath}/images/${p.image}"
                 data-stock="${p.stock}">
                <div class="product-img-wrap">
                    <img src="${pageContext.request.contextPath}/images/${p.image}" alt="${p.name}">
                </div>
                <div class="product-info">
                    <div class="product-category">${p.category}</div>
                    <div class="product-name">${p.name}</div>
                    <div class="product-price">₨ ${p.price}</div>
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
        <div class="empty-state">
            <div class="empty-icon">📦</div>
            <p>No products found. Please check your database.</p>
        </div>
    </c:otherwise>
</c:choose>
        </div>

<div id="paginationBar" style="display:flex;justify-content:center;gap:8px;margin-top:32px;padding-bottom:16px;">
    <c:if test="${currentPage > 1}">
        <a href="?page=${currentPage - 1}${not empty category ? '&category='.concat(category) : ''}"
           style="padding:8px 14px;border:1px solid #E4E7EC;border-radius:5px;font-size:13px;color:#5A6478;text-decoration:none;">← Prev</a>
    </c:if>
    <c:forEach var="pg" begin="1" end="${totalPages}">
        <a href="?page=${pg}${not empty category ? '&category='.concat(category) : ''}"
           style="padding:8px 14px;border:1px solid ${pg == currentPage ? '#1A56DB' : '#E4E7EC'};border-radius:5px;font-size:13px;color:${pg == currentPage ? '#fff' : '#5A6478'};background:${pg == currentPage ? '#1A56DB' : 'transparent'};text-decoration:none;">
            ${pg}
        </a>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}${not empty category ? '&category='.concat(category) : ''}"
           style="padding:8px 14px;border:1px solid #E4E7EC;border-radius:5px;font-size:13px;color:#5A6478;text-decoration:none;">Next →</a>
    </c:if>
</div>

    </div>
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

<!-- ================= JAVASCRIPT ================= -->
<script>

    let activeCategory = null;
    let activeBrand    = null;
    
    var urlCategory = new URLSearchParams(window.location.search).get('category');

    function toggleGroup(labelEl, category) {
        const brandList = document.getElementById('brands-' + category);
        const isOpen    = brandList.classList.contains('open');

        document.querySelectorAll('.brand-list').forEach(function(l) { l.classList.remove('open'); });
        document.querySelectorAll('.filter-group-label').forEach(function(l) { l.classList.remove('active', 'open'); });
        document.querySelectorAll('.brand-item').forEach(function(b) { b.classList.remove('active'); });

        if (isOpen && urlCategory === category && activeBrand === null) {
            // Deselect — go back to all products
            window.location.href = CTX + '/shop';
            return;
        }

        // Navigate to server with category filter
        window.location.href = CTX + '/shop?category=' + encodeURIComponent(category);
    }

    function selectBrand(category, brand) {
        // If we're not already on this category page, go there first
        if (urlCategory !== category) {
            window.location.href = CTX + '/shop?category=' + encodeURIComponent(category);
            return;
        }

        // Already on correct category page — just filter in JS
        document.querySelectorAll('.filter-group-label').forEach(function(l) { l.classList.remove('active'); });
        document.querySelectorAll('.brand-item').forEach(function(b) { b.classList.remove('active'); });

        var catLabel  = document.getElementById('group-' + category);
        var brandList = document.getElementById('brands-' + category);
        catLabel.classList.add('active', 'open');
        brandList.classList.add('open');
        brandList.querySelectorAll('.brand-item').forEach(function(item) {
            if (item.textContent.trim() === brand) item.classList.add('active');
        });

        activeCategory = category;
        activeBrand    = brand;
        applyFilters();
    }

    function applyFilters() {
        var cards   = document.querySelectorAll('.product-card');
        var visible = 0;

        cards.forEach(function(card) {
            var brand = card.dataset.brand;
            var matchBrand = (activeBrand === null) || (brand === activeBrand);

            if (matchBrand) {
                card.style.display = '';
                visible++;
            } else {
                card.style.display = 'none';
            }
        });

        document.getElementById('countVisible').textContent = visible;
        updateFilterTags();
        updateEmptyState(visible);

        // Hide pagination when brand filtering
        var pagination = document.getElementById('paginationBar');
        if (pagination) {
            pagination.style.display = activeBrand ? 'none' : 'flex';
        }
    }

    function updateFilterTags() {
        var container = document.getElementById('activeFilters');
        container.innerHTML = '';
        if (activeCategory) {
            var tag = document.createElement('span');
            tag.className = 'filter-tag';
            tag.textContent = activeCategory;
            container.appendChild(tag);
        }
        if (activeBrand) {
            var tag2 = document.createElement('span');
            tag2.className = 'filter-tag';
            tag2.textContent = activeBrand;
            container.appendChild(tag2);
        }
    }

    function updateEmptyState(visible) {
        var existing = document.getElementById('emptyState');
        if (existing) existing.remove();
        if (visible === 0) {
            var grid  = document.getElementById('productsGrid');
            var empty = document.createElement('div');
            empty.id  = 'emptyState';
            empty.className = 'empty-state';
            empty.innerHTML = '<div class="empty-icon">🔍</div><p>No products match your selection.</p>';
            grid.appendChild(empty);
        }
    }

    function clearFilters() {
        window.location.href = CTX + '/shop';
    }

    applyFilters();

    
 // Highlight active filter from URL on page load
window.addEventListener('load', function() {
    if (urlCategory) {
        var catLabel  = document.getElementById('group-' + urlCategory);
        var brandList = document.getElementById('brands-' + urlCategory);
        if (catLabel)  catLabel.classList.add('active', 'open')    ;
        if (brandList) brandList.classList.add('open');
        activeCategory = urlCategory;
    }
    applyFilters();
});
 

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
