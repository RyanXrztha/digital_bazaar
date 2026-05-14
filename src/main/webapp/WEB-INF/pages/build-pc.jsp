<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.List, java.util.Map, com.DigitalBazaar.model.Product" %>
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
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>PC Builder — Digital Bazaar</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>

/* ================= VARIABLES (identical to shop.jsp) ================= */
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

[class*="price"],
.summary-total-amount,
.summary-total-row-val {
    color: #111827 !important;
}

/* ================= CART SIDEBAR ================= */
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
.cart-item-info { flex: 1; min-width: 0; }
.cart-item-info strong {
    display: block; font-size: 13px; font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    margin-bottom: 4px;
}
.cart-item-meta { display: flex; align-items: center; justify-content: space-between; }
.cart-item-cat {
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
    font-size: 36px; font-weight: 700;
    line-height: 1.1; color: #FFFFFF;
    letter-spacing: -1px;
}
.hero-title span { color: #3B82F6; }

.hero-subtitle {
    margin-top: 14px;
    font-size: 15px;
    line-height: 1.7;
    color: #8B9BB5;
    font-weight: 300;
    max-width: 480px;
}
/* ================= MAIN LAYOUT ================= */
.builder-layout {
    display: grid;
    grid-template-columns: 1fr 320px;
    gap: 24px;
    padding: 32px 48px;
    align-items: start;
    min-height: calc(100vh - 278px);
}

.builder-layout > div:last-child {
    height: 100%;
}

/* ================= SECTION CARD ================= */
.section-card {
    background: var(--white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
    margin-bottom: 20px;
}

.section-card:last-child { margin-bottom: 0; }

.section-card-header {
    padding: 14px 20px;
    border-bottom: 1px solid var(--border-light);
    background: var(--off-white);
    display: flex; align-items: center; justify-content: space-between;
}

.section-card-title {
    font-family: 'DM Mono', monospace;
    font-size: 10px; font-weight: 500;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 1px;
}

.section-card-body { padding: 20px; }

.budget-display {
    font-family: 'DM Sans', sans-serif;
    font-weight: 700;
    font-size: 32px;
    color: #0D1117;
}
.budget-display .currency {
    font-size: 16px;
    color: var(--text-muted);
    margin-right: 2px;
}

.budget-input-wrap {
    position: relative;
    margin-bottom: 14px;
}
.budget-input-prefix {
    position: absolute;
    left: 12px; top: 50%;
    transform: translateY(-50%);
    font-family: 'DM Mono', monospace;
    font-size: 13px;
    color: var(--text-muted);
    pointer-events: none;
}
.budget-input-wrap input[type=number] {
    width: 100%;
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 10px 14px 10px 30px;
    font-family: 'DM Mono', monospace;
    font-size: 14px;
    color: var(--text-primary);
    background: var(--off-white);
    outline: none;
    transition: border-color 0.15s, background 0.15s;
    -moz-appearance: textfield;
}
.budget-input-wrap input[type=number]::-webkit-outer-spin-button,
.budget-input-wrap input[type=number]::-webkit-inner-spin-button { -webkit-appearance: none; }
.budget-input-wrap input[type=number]:focus {
    border-color: var(--accent);
    background: var(--white);
}

input[type=range] {
    -webkit-appearance: none;
    width: 100%;
    height: 3px;
    background: var(--border);
    border-radius: 2px;
    outline: none;
    cursor: pointer;
    margin-bottom: 8px;
}
input[type=range]::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 16px; height: 16px;
    border-radius: 50%;
    background: var(--accent);
    cursor: pointer;
    box-shadow: 0 0 0 3px var(--accent-light);
    transition: box-shadow 0.15s;
}
input[type=range]::-webkit-slider-thumb:hover {
    box-shadow: 0 0 0 5px var(--accent-light);
}
.range-hints {
    display: flex; justify-content: space-between;
    font-family: 'DM Mono', monospace;
    font-size: 11px; color: var(--text-muted);
}

/* ================= CATEGORY TABS ================= */
.category-tabs {
    display: flex;
    gap: 6px;
    flex-wrap: wrap;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-light);
    background: var(--off-white);
}

.cat-tab {
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px; font-weight: 600;
    font-family: 'DM Mono', monospace;
    letter-spacing: 0.5px;
    cursor: pointer;
    border: 1px solid var(--border);
    color: var(--text-secondary);
    background: var(--white);
    transition: all 0.15s ease;
    user-select: none;
}
.cat-tab:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }
.cat-tab.active {
    background: var(--accent);
    border-color: var(--accent);
    color: var(--white);
}

/* ================= COMPONENT ROWS ================= */
.comp-table { width: 100%; border-collapse: collapse; }

.comp-row {
    display: grid;
    grid-template-columns: 60px 1fr auto auto;
    align-items: center;
    gap: 14px;
    padding: 14px 20px;
    border-bottom: 1px solid var(--border-light);
    transition: background 0.15s;
}
.comp-row:last-child { border-bottom: none; }
.comp-row:hover { background: var(--off-white); }

.comp-tag {
    font-family: 'DM Sans', sans-serif;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.3px;
    color: #374151;
    background: #F3F4F6;
}

.comp-info { min-width: 0; }
.comp-name {
    font-size: 13px; font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 2px;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.comp-spec {
    font-family: 'DM Sans', sans-serif;
    font-size: 12px;
    color: #6B7280;
}

.comp-price,
.selected-item-price,
.summary-total-row-val,
.summary-total-amount {
    font-family: 'DM Sans', sans-serif; /* NOT mono */
    font-weight: 600;
    color: #111827; /* neutral dark (professional) */
    letter-spacing: -0.2px;
}

.comp-select-btn {
    width: 28px; height: 28px;
    display: flex; align-items: center; justify-content: center;
    border-radius: var(--radius-sm);
    border: 1px solid var(--border);
    background: var(--white);
    color: var(--text-muted);
    cursor: pointer;
    font-size: 14px;
    transition: all 0.15s;
    flex-shrink: 0;
}
.comp-select-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }
.comp-select-btn.selected { border-color: var(--success); color: var(--success); background: #F0FDF4; }

/* Category section header */
.cat-section {
    display: none;
}
.cat-section.visible {
    display: block;
}

.cat-section-header {
    padding: 12px 20px;
    background: var(--accent-light);
    border-bottom: 1px solid rgba(26,86,219,0.12);
    display: flex; align-items: center; gap: 10px;
}
.cat-section-name {
    font-family: 'DM Mono', monospace;
    font-size: 11px; font-weight: 600;
    color: var(--accent);
    text-transform: uppercase; letter-spacing: 0.8px;
}
.cat-count {
    font-family: 'DM Mono', monospace;
    font-size: 10px;
    color: var(--accent);
    background: rgba(26,86,219,0.12);
    border-radius: 10px;
    padding: 1px 7px;
}

/* Empty state */
.empty-cat {
    text-align: center;
    padding: 48px 20px;
    color: var(--text-muted);
    font-size: 13px;
}
.empty-cat-icon { font-size: 32px; margin-bottom: 10px; opacity: 0.4; }

/* ================= SUMMARY SIDEBAR ================= */
.summary-card {
    background: var(--white);
    border: 1px solid var(--border-light);
    border-radius: var(--radius);
    box-shadow: var(--shadow-sm);
    position: sticky;
    top: 74px;
    max-height: calc(100vh - 90px);
    overflow-y: auto;
}

.summary-header {
    padding: 14px 20px;
    border-bottom: 1px solid var(--border-light);
    background: var(--off-white);
}
.summary-header-title {
    font-family: 'DM Mono', monospace;
    font-size: 10px; font-weight: 500;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 1px;
}

.summary-body { padding: 20px; }

.summary-total-display {
    margin-bottom: 4px;
}
.summary-total-label {
    font-size: 11px; font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 0.8px;
    margin-bottom: 6px;
}

.summary-total-amount .cur { font-size: 14px; color: var(--text-muted); margin-right: 2px; }
.summary-sub-note {
    font-size: 12px; color: var(--text-muted);
    margin-bottom: 20px;
    font-family: 'DM Mono', monospace;
}

.summary-card::-webkit-scrollbar {
    width: 4px;
}
.summary-card::-webkit-scrollbar-track {
    background: var(--border-light);
}
.summary-card::-webkit-scrollbar-thumb {
    background: var(--border);
    border-radius: 2px;
}
.summary-card::-webkit-scrollbar-thumb:hover {
    background: var(--text-muted);
}

/* selected items list */
.selected-list { margin-bottom: 20px; }

.selected-item {
    display: flex; align-items: flex-start; justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid var(--border-light);
    gap: 10px;
}
.selected-item:last-child { border-bottom: none; }

.selected-item-left { min-width: 0; flex: 1; }
.selected-item-cat {
    font-family: 'DM Mono', monospace;
    font-size: 9px; font-weight: 500;
    color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 0.8px;
    margin-bottom: 2px;
}
.selected-item-name {
    font-weight: 500;
    color: #111827;
}


.summary-divider {
    height: 1px;
    background: var(--border-light);
    margin: 16px 0;
}

.summary-total-row {
    display: flex; justify-content: space-between; align-items: baseline;
    margin-bottom: 16px;
}
.summary-total-row-label {
    font-size: 12px; font-weight: 600;
    color: var(--text-secondary);
}

.currency {
    font-size: 0.85em;
    color: var(--text-muted);
    margin-right: 2px;
}

/* ================= COMPONENT IMAGE ================= */
.comp-img {
    width: 52px;
    height: 52px;
    object-fit: contain;
    background: var(--off-white);
    border: 1px solid var(--border-light);
    border-radius: 6px;
    padding: 4px;
    flex-shrink: 0;
}

/* ================= CART ITEM IMAGE ================= */
.cart-item img {
    width: 52px;
    height: 52px;
    object-fit: contain;
    background: var(--off-white);
    border: 1px solid var(--border-light);
    border-radius: 5px;
    padding: 5px;
    flex-shrink: 0;
}


/* CTA buttons */
.cta-btn {
    width: 100%;
    padding: 11px;
    border: none;
    border-radius: var(--radius-sm);
    font-family: 'DM Sans', sans-serif;
    font-size: 12px; font-weight: 600;
    letter-spacing: 0.6px; text-transform: uppercase;
    cursor: pointer;
    transition: all 0.2s ease;
    margin-bottom: 8px;
}
.cta-btn:last-child { margin-bottom: 0; }

.cta-primary {
    background: var(--accent);
    color: var(--white);
}
.cta-primary:hover {
    background: var(--accent-dark);
    box-shadow: 0 4px 14px rgba(26,86,219,0.28);
    transform: translateY(-1px);
}

.cta-ghost {
    background: transparent;
    color: var(--text-secondary);
    border: 1px solid var(--border);
}
.cta-ghost:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }

.section-card-title-accent {
    color: var(--accent);
}

/* empty summary */
.summary-empty {
    text-align: center;
    padding: 32px 20px;
    color: var(--text-muted);
    font-size: 12px;
}
.summary-empty-icon { font-size: 28px; margin-bottom: 8px; opacity: 0.4; }



/* ================= RESPONSIVE ================= */
@media (max-width: 1024px) {
    .builder-layout { grid-template-columns: 1fr; }
    .summary-card { position: static; }
}
@media (max-width: 720px) {
    .builder-layout { padding: 20px; }
    .navbar { padding: 0 20px; }
    .hero { padding-left: 24px; }
    .comp-row { grid-template-columns: 50px 1fr auto; }
    .comp-price { display: none; }
}

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
		    🛒<span class="cart-count" id="cartCount">0</span>
		</button>
		<div class="profile-wrapper" id="profileWrapper">
    <button class="profile-btn" id="profileBtn" onclick="toggleProfile()" aria-label="Profile">
        <div class="profile-btn-avatar">
    <c:choose>
    <c:when test="${empty initials}">
        <img src="${pageContext.request.contextPath}/images/profile.png" alt="Profile"
             style="width:100%;height:100%;object-fit:cover;filter:invert(30%) sepia(80%) saturate(500%) hue-rotate(200deg);">
    </c:when>
    <c:otherwise>${initials}</c:otherwise>
</c:choose>
</div>
    </button>
    <div class="profile-dropdown" id="profileDropdown">
        <c:choose>
    <c:when test="${isLoggedIn and not empty sessionScope.user}">
        <div class="pd-header">
            <div class="pd-username">${sessionScope.user.username}</div>
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
    </c:when>
    <c:otherwise>
        <div class="pd-header">
            <div class="pd-username">Guest User</div>
            <div class="pd-status">Please sign in</div>
        </div>
        <nav class="pd-nav">
            <a href="${pageContext.request.contextPath}/login" class="pd-item">Log In</a>
            <a href="${pageContext.request.contextPath}/register" class="pd-item">Create Account</a>
        </nav>
    </c:otherwise>
</c:choose>
    </div>
</div>
    </div>
</nav>

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
<div class="hero">
    <img src="${pageContext.request.contextPath}/images/buildpc.png"
         alt="Hero"
         style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0.45;">
    <div class="hero-content">
        <div class="hero-eyebrow">PC Builder</div>
        <div class="hero-title">BUILD YOUR <span>DREAM RIG</span></div>
        <div class="hero-subtitle">Pick your components, set your budget, and assemble the perfect build.</div>
    </div>
</div>

<!-- ================= MAIN LAYOUT ================= -->
<div class="builder-layout">

    <!-- LEFT COLUMN -->
    <div>

        <!-- BUDGET SECTION -->
        <div class="section-card">
            <div class="section-card-header">
                <span class="section-card-title">Budget</span>
                <span class="section-card-title section-card-title-accent" id="budgetPercent">0% spent</span>
            </div>
            <div class="section-card-body">
                <div class="budget-display">
                    <span class="currency">₨</span><span id="budgetDisplay">1,30,000</span>
                </div>
                <div class="budget-input-wrap">
                    <span class="budget-input-prefix">₨</span>
                    <input type="number" id="budgetInput" value="130000" min="50000" max="500000"
                           placeholder="Enter budget" oninput="syncBudget(this.value, 'input')">
                </div>
                <input type="range" id="budgetSlider" value="130000" min="50000" max="500000"
                       oninput="syncBudget(this.value, 'slider')">
                <div class="range-hints">
                    <span>₨ 50,000</span><span>₨ 5,00,000</span>
                </div>
            </div>
        </div>

        <!-- COMPONENTS SECTION -->
        <div class="section-card">
            <div class="section-card-header">
                <span class="section-card-title">Select Components</span>
                <span class="section-card-title section-card-title-accent" id="selectedCount">0 selected</span>
            </div>

            <!-- Category Tabs -->
            <div class="category-tabs" id="categoryTabs">
                <div class="cat-tab active" onclick="switchCategory('all', this)">All</div>
                <c:forEach var="entry" items="${productsByCategory}">
				    <div class="cat-tab" onclick="switchCategory('${entry.key}', this)">${entry.key}</div>
				</c:forEach>
            </div>

            <!-- All categories content -->
            <c:choose>
    <c:when test="${not empty productsByCategory}">
        <c:forEach var="entry" items="${productsByCategory}">
            <div class="cat-section visible" id="cat-${entry.key}">
                <div class="cat-section-header">
                    <span class="cat-section-name">${entry.key}</span>
                    <span class="cat-count">${fn:length(entry.value)} items</span>
                </div>
                <c:forEach var="p" items="${entry.value}">
                    <div class="comp-row" id="row_prod_${fn:replace(p.name, ' ', '_')}">
                        <img src="${pageContext.request.contextPath}/images/${p.image}"
                             class="comp-img" alt="${p.name}">
                        <div class="comp-info">
                            <div class="comp-name">${p.name}</div>
                            <div class="comp-spec">${p.category}</div>
                        </div>
                        <div class="comp-price"><span class="currency">₨</span>${p.price}</div>
                        <button class="comp-select-btn"
                                data-name="${p.name}"
                                data-category="${entry.key}"
                                data-price="${p.price}"
                                data-product-id="${p.id}"
                                data-img="${pageContext.request.contextPath}/images/${p.image}"
                                onclick="toggleSelect(this)">+</button>
                    </div>
                </c:forEach>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="empty-cat">
            <div class="empty-cat-icon">📦</div>
            <div>No products found. Please check your database.</div>
        </div>
    </c:otherwise>
</c:choose>
        </div>

    </div>

    <!-- RIGHT COLUMN — SUMMARY -->
    <div>
        <div class="summary-card">
            <div class="summary-header">
                <div class="summary-header-title">Build Summary</div>
            </div>
            <div class="summary-body">

                <div class="summary-total-label">Total Cost</div>
                <div class="summary-total-amount">
                    <span class="cur">₨</span><span id="summaryTotal">0</span>
                </div>
                <div class="summary-sub-note" id="summaryNote">No components selected</div>

                <div class="summary-divider"></div>

                <!-- Selected items list -->
                <div class="selected-list" id="selectedList">
                    <div class="summary-empty">
                        <div class="summary-empty-icon">🔧</div>
                        <div>Select components from the left to start building your PC.</div>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total-row">
                    <span class="summary-total-row-label">Grand Total</span>
                    <span class="summary-total-row-val">₨ <span id="grandTotal">0</span></span>
                </div>

                <button class="cta-btn cta-primary" onclick="addBuildToCart()">🛒 Add to Cart</button>
                <button class="cta-btn cta-ghost" onclick="clearBuild()">✕ Clear Build</button>

            </div>
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

    /* ---------- Budget ---------- */
    function syncBudget(val, src) {
        var n = Math.max(50000, Math.min(500000, parseInt(val) || 50000));
        document.getElementById('budgetDisplay').textContent = fmtNPR(n);
        if (src !== 'input')  document.getElementById('budgetInput').value  = n;
        if (src !== 'slider') document.getElementById('budgetSlider').value = n;
        updateBudgetPercent();
    }

    function getBudget() {
        return parseInt(document.getElementById('budgetInput').value) || 130000;
    }

    function updateBudgetPercent() {
        var budget = getBudget();
        var spent = getTotal();
        var pct = budget > 0 ? Math.round((spent / budget) * 100) : 0;
        var el = document.getElementById('budgetPercent');
        el.textContent = pct + '% spent';
        el.style.color = pct > 100 ? '#EF4444' : pct > 80 ? '#F59E0B' : 'var(--accent)';
    }

    /* ---------- Category tabs ---------- */
    function switchCategory(cat, tabEl) {
        document.querySelectorAll('.cat-tab').forEach(function(t) { t.classList.remove('active'); });
        tabEl.classList.add('active');
        var sections = document.querySelectorAll('.cat-section');
        if (cat === 'all') {
            sections.forEach(function(s) { s.classList.add('visible'); });
        } else {
            sections.forEach(function(s) {
                s.classList.toggle('visible', s.id === 'cat-' + cat);
            });
        }
    }

    /* ---------- Selected components ---------- */
    var selected = {};

    function toggleSelect(btn) {
        var name     = btn.dataset.name;
        var category = btn.dataset.category;
        var price    = parseFloat(btn.dataset.price);
        var img      = btn.dataset.img;

        if (selected[category] && selected[category].name === name) {
            // clicking same button — deselect it
            delete selected[category];
            btn.textContent = '+';
            btn.classList.remove('selected');
        } else {
            // deselect previous button in same category by querying directly
            if (selected[category]) {
                document.querySelectorAll('.comp-select-btn').forEach(function(b) {
                    if (b.dataset.category === category) {
                        b.textContent = '+';
                        b.classList.remove('selected');
                    }
                });
            }

            selected[category] = { name: name, price: price, img: img, productId: btn.dataset.productId };
            btn.textContent = '✔';
            btn.classList.add('selected');
        }

        renderSummary();
    }

    function getTotal() {
        return Object.values(selected).reduce(function(sum, item) { return sum + item.price; }, 0);
    }

    function renderSummary() {
        var keys  = Object.keys(selected);
        var total = getTotal();

        document.getElementById('summaryTotal').textContent = fmtNPR(total);
        document.getElementById('grandTotal').textContent   = fmtNPR(total);
        document.getElementById('selectedCount').textContent = keys.length + ' selected';
        document.getElementById('summaryNote').textContent  =
            keys.length === 0 ? 'No components selected' :
            keys.length + ' component' + (keys.length > 1 ? 's' : '');

        var listEl = document.getElementById('selectedList');
        if (keys.length === 0) {
            listEl.innerHTML = '<div class="summary-empty"><div class="summary-empty-icon">🔧</div><div>Select components from the left to start building your PC.</div></div>';
        } else {
            var html = '';
            keys.forEach(function(cat) {
                var item = selected[cat];
                html += '<div class="selected-item">'
                    + '<div class="selected-item-left">'
                    + '<div class="selected-item-cat">' + cat + '</div>'
                    + '<div class="selected-item-name">' + item.name + '</div>'
                    + '</div>'
                    + '<div class="selected-item-price">₨ ' + fmtNPR(item.price) + '</div>'
                    + '</div>';
            });
            listEl.innerHTML = html;
        }

        updateBudgetPercent();
    }

    function clearBuild() {
        selected = {};
        document.querySelectorAll('.comp-select-btn').forEach(function(btn) {
            btn.textContent = '+';
            btn.classList.remove('selected');
        });
        renderSummary();
    }

    function addBuildToCart() {
        if (!isLoggedIn) {
            alert("Please login first!");
            window.location.href = CTX + "/login";
            return;
        }
        var keys = Object.keys(selected);
        if (keys.length === 0) { alert('Please select at least one component!'); return; }

        var promises = keys.map(function(cat) {
            var item = selected[cat];
            return fetch(CTX + '/cart/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'productId=' + item.productId + '&quantity=1'
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data.success) {
                    console.error('Failed to add ' + item.name + ': ' + data.message);
                }
            });
        });

        Promise.all(promises).then(function() {
            loadCart();
            document.getElementById('cartSidebar').classList.add('active');
        }).catch(function(e) {
            console.error('Add build to cart error', e);
        });
    }
    
    function handleBuyNow(btn) {
        if (!isLoggedIn) {
            alert("Please login first!");
            window.location.href = CTX + "/login";
            return;
        }
        var card  = btn.closest('.product-card');
        var name  = card.dataset.name;
        var price = parseFloat(card.dataset.price);

        // Build and submit a form directly — skip the cart entirely
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = CTX + '/checkout';

        var n = document.createElement('input');
        n.type = 'hidden'; n.name = 'productName'; n.value = name;
        form.appendChild(n);

        var q = document.createElement('input');
        q.type = 'hidden'; q.name = 'quantity'; q.value = '1';
        form.appendChild(q);

        var t = document.createElement('input');
        t.type = 'hidden'; t.name = 'totalPrice'; t.value = price.toFixed(2);
        form.appendChild(t);

        document.body.appendChild(form);
        form.submit();
    }

    /* ---------- Init ---------- */
    renderSummary();

    
</script>
</body>
</html>