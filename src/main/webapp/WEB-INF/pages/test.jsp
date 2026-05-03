<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List, java.util.Map, com.DigitalBazaar.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart PC Builder – DigitalBazaar</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* Base Reset */
        *, ::before, ::after { 
            box-sizing: border-box; 
            margin: 0;
            padding: 0; 
        }
        
        html { height: 100%; }
        
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f3f4f6; 
            color: #111827; 
            display: flex;
            min-height: 100vh; 
            overflow-x: hidden; 
        }
        /* Sidebar */
        .sidebar-overlay { 
            display: none; 
            position: fixed; 
            inset: 0; 
            background-color: rgba(0,0,0,0.5);
            z-index: 110; 
        }
        .sidebar-overlay.active { display: block; }
        
        .sidebar { 
            width: 250px; 
            height: 100vh; 
            background-color: #ffffff;
            border-right: 1px solid #e5e7eb; 
            position: fixed; 
            top: 0; 
            left: 0;
            display: flex; 
            flex-direction: column; 
            z-index: 120; 
            transition: transform 0.3s ease;
            overflow-y: auto; 
        }
        
        .logo { 
            padding: 24px 20px; 
            border-bottom: 1px solid #e5e7eb; 
            flex-shrink: 0; 
        }
        .logo h2 { font-size: 18px; font-weight: 700; color: #111827; }
        .logo span { color: #0066cc; }
        
        .sidebar-label { 
            font-size: 11px; 
            font-weight: 600; 
            letter-spacing: 1px; 
            text-transform: uppercase;
            color: #6b7280; 
            padding: 24px 20px 8px; 
            flex-shrink: 0; 
        }
        
        .menu { list-style: none; padding: 0 12px; flex-shrink: 0; }
        .menu li { 
            display: flex; 
            align-items: center; 
            gap: 12px;
            padding: 10px 12px; 
            border-radius: 6px; 
            cursor: pointer; 
            color: #4b5563;
            font-size: 14px; 
            font-weight: 500; 
            transition: background-color 0.2s, color 0.2s; 
            margin-bottom: 4px;
        }
        .menu li:hover { background-color: #f9fafb; color: #111827; }
        .menu li.active { 
            background-color: #eff6ff; 
            color: #0066cc; 
            font-weight: 600;
        }
        .menu li .icon { font-size: 16px; width: 20px; text-align: center; }
        
        .sidebar-footer { 
            margin-top: auto; 
            padding: 16px 12px; 
            border-top: 1px solid #e5e7eb;
            flex-shrink: 0; 
        }
        
        .logout-btn { 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            width: 100%;
            padding: 10px 12px; 
            border-radius: 6px; 
            background-color: transparent; 
            border: 1px solid #ef4444;
            color: #ef4444; 
            font-family: inherit; 
            font-size: 14px; 
            font-weight: 500; 
            cursor: pointer;
            transition: all 0.2s; 
        }
        .logout-btn:hover { background-color: #ef4444; color: #ffffff; }
        /* Topbar */
        .mobile-topbar { 
            display: none; 
            position: fixed; 
            top: 0; left: 0; right: 0; 
            height: 60px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #e5e7eb;
            align-items: center; 
            justify-content: space-between; 
            padding: 0 16px; 
            z-index: 100; 
        }
        .mobile-topbar .m-logo { font-size: 16px; font-weight: 700; color: #111827; }
        .mobile-topbar .m-logo span { color: #0066cc; }
        
        .hamburger { 
            background: none; border: none; color: #4b5563; font-size: 24px;
            cursor: pointer; padding: 4px;
        }
        
        .topbar { 
            height: 70px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #e5e7eb;
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            padding: 0 32px;
            position: sticky; 
            top: 0; 
            z-index: 50; 
            flex-shrink: 0; 
        }
        
        .topbar-left { display: flex; align-items: center; gap: 16px; }
        .topbar h1 { font-size: 18px; font-weight: 600; color: #111827; }
        .page-badge { 
            background-color: #eff6ff; 
            color: #0066cc;
            font-size: 12px; 
            font-weight: 600; 
            padding: 4px 10px; 
            border-radius: 4px; 
        }
        
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .avatar { 
            width: 36px; height: 36px; 
            border-radius: 50%; 
            background-color: #0066cc;
            display: flex; align-items: center; justify-content: center; 
            font-size: 14px; font-weight: 600;
            color: #ffffff; cursor: pointer;
        }
        .chip { 
            display: inline-flex; align-items: center; gap: 6px; 
            background-color: #f0fdf4;
            border: 1px solid #bbf7d0; 
            border-radius: 4px; padding: 4px 10px; font-size: 12px;
            font-weight: 500; color: #16a34a; 
        }
        /* Main Layout */
        .main { 
            margin-left: 250px; 
            flex: 1; 
            display: flex; 
            flex-direction: column;
            min-height: 100vh; 
        }
        .content { padding: 32px; flex: 1; }
        
        .builder-grid { 
            display: grid; 
            grid-template-columns: 1fr 380px; 
            gap: 24px; 
            align-items: start;
        }
        /* Wizard Steps */
        .wizard-steps { 
            display: flex; align-items: center; margin-bottom: 24px; 
        }
        .step { display: flex; align-items: center; gap: 8px; }
        .step-num { 
            width: 28px; height: 28px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-size: 12px; font-weight: 600;
            border: 1px solid #d1d5db; color: #6b7280; background-color: #ffffff; 
        }
        .step.active .step-num { 
            background-color: #0066cc; border-color: #0066cc; color: #ffffff;
        }
        .step.done .step-num { background-color: #16a34a; border-color: #16a34a; color: #ffffff; }
        .step-label { font-size: 14px; font-weight: 500; color: #6b7280; }
        .step.active .step-label { color: #0066cc; font-weight: 600; }
        .step.done .step-label { color: #16a34a; }
        .step-connector { width: 30px; height: 1px; background-color: #d1d5db; margin: 0 12px; }
        /* Cards & Forms */
        .card { 
            background-color: #ffffff; 
            border: 1px solid #e5e7eb; 
            border-radius: 8px;
            margin-bottom: 24px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        .card-header { 
            padding: 16px 24px; border-bottom: 1px solid #e5e7eb; display: flex;
            align-items: center; justify-content: space-between; 
        }
        .card-header h3 { font-size: 16px; font-weight: 600; color: #111827; }
        .card-body { padding: 24px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        label { font-size: 12px; font-weight: 600; color: #4b5563; }
        
        select { 
            background-color: #ffffff; border: 1px solid #d1d5db; border-radius: 6px;
            color: #111827; font-family: inherit; font-size: 14px; padding: 10px;
            outline: none; width: 100%; transition: border-color 0.2s; 
        }
        select:focus { border-color: #0066cc; }
        /* Personas */
        .persona-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .persona-card { 
            background-color: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px;
            padding: 16px; cursor: pointer; text-align: center; position: relative; 
            transition: border-color 0.2s, background-color 0.2s;
        }
        .persona-card:hover { border-color: #0066cc; }
        .persona-card.selected { border-color: #0066cc; background-color: #eff6ff; border-width: 2px; padding: 15px; }
        
        .pc-icon { font-size: 24px; margin-bottom: 8px; }
        .pc-label { font-size: 14px; font-weight: 600; color: #111827; margin-bottom: 4px; }
        .persona-card.selected .pc-label { color: #0066cc; }
        .pc-desc { font-size: 12px; color: #6b7280; line-height: 1.4; }
        
        .persona-badge { 
            position: absolute; top: -8px; right: -8px; font-size: 10px;
            font-weight: 600; padding: 2px 8px; border-radius: 12px; 
            background-color: #111827; color: #ffffff;
        }
        
        .persona-info { background-color: #f9fafb; border-radius: 6px; border: 1px solid #e5e7eb; padding: 16px; margin-top: 16px; }
        .persona-info-header { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; }
        .persona-info-icon { font-size: 24px; }
        .persona-info-title { font-size: 15px; font-weight: 600; color: #111827; }
        .persona-info-sub { font-size: 13px; color: #6b7280; margin-top: 2px; }
        
        .priority-bars { display: flex; flex-direction: column; gap: 10px; }
        .priority-row { display: flex; align-items: center; gap: 12px; }
        .priority-label { font-size: 12px; font-weight: 500; color: #4b5563; width: 60px; }
        .priority-track { flex: 1; height: 8px; background-color: #e5e7eb; border-radius: 4px; overflow: hidden; }
        .priority-fill { height: 100%; border-radius: 4px; background-color: #0066cc; }
        .priority-pct { font-size: 12px; color: #6b7280; width: 35px; text-align: right; }
        /* Budget Controls */
        .budget-value { font-size: 28px; font-weight: 700; color: #111827; margin-bottom: 12px; }
        
        input[type="range"] { width: 100%; cursor: pointer; margin-bottom: 8px; }
        .range-labels { display: flex; justify-content: space-between; }
        .range-labels span { font-size: 12px; color: #6b7280; }
        
        .budget-hint { 
            font-size: 13px; color: #4b5563; margin-top: 16px; padding: 12px;
            background-color: #f3f4f6; border-radius: 6px; border-left: 3px solid #0066cc; 
        }
        
        .budget-tiers { display: flex; gap: 8px; margin-top: 16px; }
        .tier-pill { 
            flex: 1; padding: 8px 4px; border-radius: 6px; text-align: center;
            font-size: 12px; font-weight: 500; border: 1px solid #d1d5db; color: #4b5563;
            cursor: pointer; background-color: #ffffff;
        }
        .tier-pill.active { color: #0066cc; border-color: #0066cc; background-color: #eff6ff; font-weight: 600; }
        /* Component Slots */
        .rec-banner { 
            display: flex; align-items: flex-start; gap: 12px; padding: 16px;
            background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 6px; margin-bottom: 20px; 
        }
        .rec-banner-text { font-size: 13px; color: #166534; line-height: 1.5; }
        .rec-banner-text strong { font-weight: 600; }
        
        .component-slots { display: flex; flex-direction: column; gap: 16px; }
        .component-slot { 
            background-color: #ffffff; border: 1px solid #e5e7eb; border-radius: 6px;
            overflow: hidden; 
        }
        
        .slot-header { display: flex; align-items: center; gap: 12px; padding: 12px 16px; background-color: #f9fafb; border-bottom: 1px solid #e5e7eb; }
        .slot-icon { font-size: 18px; }
        .slot-label-text { font-size: 13px; font-weight: 600; color: #374151; flex: 1; text-transform: uppercase; }
        .slot-price-badge { font-size: 14px; font-weight: 600; color: #111827; }
        
        .slot-body { padding: 16px; }
        .slot-native-select { 
            width: 100%; background-color: #ffffff; border: 1px solid #d1d5db;
            border-radius: 6px; color: #111827; font-family: inherit; font-size: 14px;
            padding: 10px 12px; outline: none; margin-bottom: 12px;
        }
        
        .slot-actions { display: flex; gap: 8px; align-items: center; }
        .slot-upgrade-btn, .slot-downgrade-btn { 
            font-size: 12px; font-weight: 500; padding: 6px 12px; border-radius: 4px;
            background-color: #ffffff; cursor: pointer;
        }
        .slot-upgrade-btn { border: 1px solid #0066cc; color: #0066cc; }
        .slot-downgrade-btn { border: 1px solid #4b5563; color: #4b5563; }
        
        .slot-stock-badge { font-size: 12px; font-weight: 500; margin-left: auto; }
        .stock-ok { color: #16a34a; }
        .stock-low { color: #d97706; }
        .stock-out { color: #dc2626; }
        /* Summary Section */
        .summary-card { position: sticky; top: 90px; }
        .budget-gauge-wrap { margin-bottom: 8px; }
        .budget-gauge-track { height: 10px; background-color: #e5e7eb; border-radius: 5px; overflow: hidden; margin-bottom: 8px; }
        .budget-gauge-fill { height: 100%; background-color: #16a34a; transition: width 0.3s; }
        .gauge-over { background-color: #dc2626; }
        .gauge-warn { background-color: #d97706; }
        
        .budget-nums { display: flex; justify-content: space-between; font-size: 13px; color: #4b5563; }
        .budget-nums .spent { font-weight: 600; color: #111827; }
        
        .budget-status { 
            padding: 12px; border-radius: 6px; font-size: 13px; font-weight: 500; margin-top: 16px; text-align: center;
            background-color: #f0fdf4; color: #166534; border: 1px solid #bbf7d0;
        }
        
        .price-breakdown { display: flex; flex-direction: column; }
        .price-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #e5e7eb; }
        .price-row:last-child { border: none; }
        .price-row-left { display: flex; align-items: center; gap: 12px; }
        .price-row-label { color: #6b7280; font-size: 12px; }
        .price-row-name { color: #111827; font-size: 13px; font-weight: 500; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .price-row-val { font-size: 14px; font-weight: 600; color: #111827; }
        
        .divider { height: 1px; background-color: #e5e7eb; margin: 16px 0; }
        
        .price-total-row { display: flex; justify-content: space-between; align-items: baseline; }
        .price-total-label { font-size: 16px; font-weight: 600; color: #111827; }
        .price-total-val { color: #111827; font-size: 28px; font-weight: 700; }
        
        /* ================= BUTTONS (CHANGED SECTION) ================= */

        /* ADD TO CART — Professional */
        .btn-primary { 
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #1E40AF 0%, #2563EB 100%);
            border: none;
            border-radius: 6px;
            color: #ffffff;
            font-family: inherit;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.6px;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 24px;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 2px 8px rgba(30,64,175,0.3);
            position: relative;
            overflow: hidden;
        }
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.4s ease;
        }
        .btn-primary:hover::before { left: 100%; }
        .btn-primary:hover {
            background: linear-gradient(135deg, #172554 0%, #1E40AF 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(30,64,175,0.4);
        }
        .btn-primary:active { transform: translateY(0); }
        .btn-primary.added {
            background: linear-gradient(135deg, #166534, #16a34a);
        }

        /* BUY NOW button */
        .btn-buynow {
            width: 100%;
            padding: 12px;
            background-color: #ffffff;
            border: 2px solid #0066cc;
            border-radius: 6px;
            color: #0066cc;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 12px;
            transition: all 0.2s;
            letter-spacing: 0.4px;
        }
        .btn-buynow:hover {
            background-color: #0066cc;
            color: #ffffff;
        }

        /* SAVE DRAFT button */
        .btn-secondary { 
            width: 100%; padding: 12px; background-color: #ffffff;
            border: 1px solid #d1d5db; border-radius: 6px; color: #374151; font-family: inherit;
            font-size: 14px; font-weight: 500; cursor: pointer; margin-top: 12px;
            transition: background-color 0.2s; 
        }
        .btn-secondary:hover { background-color: #f9fafb; }

        /* ================= CART SIDEBAR ================= */
        .cart-sidebar {
            position: fixed;
            top: 0;
            right: -420px;
            width: 400px;
            height: 100vh;
            background: #FFFFFF;
            border-left: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 999;
            box-shadow: -5px 0 20px rgba(0,0,0,0.1);
        }
        .cart-sidebar.active { right: 0; }
        .cart-sidebar-header {
            padding: 22px 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .cart-sidebar-header h2 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #111827;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .close-cart {
            cursor: pointer;
            font-size: 20px;
            color: #94A3B8;
            transition: 0.2s;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
        }
        .close-cart:hover { color: #111827; background: #F1F5F9; }
        #sideCartItems {
            flex: 1;
            overflow-y: auto;
            padding: 16px;
        }
        #sideCartItems::-webkit-scrollbar { width: 4px; }
        #sideCartItems::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 2px; }
        .side-cart-empty {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 200px;
            color: #94A3B8;
            font-size: 14px;
        }
        .side-cart-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #F1F5F9;
        }
        .side-cart-item:last-child { border-bottom: none; }
        .side-cart-item img {
            width: 60px;
            height: 60px;
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 6px;
            padding: 5px;
            object-fit: contain;
            flex-shrink: 0;
        }
        .side-cart-item-info { flex: 1; min-width: 0; }
        .side-cart-item-info strong {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #111827;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 4px;
        }
        .side-cart-item-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .side-cart-item-qty {
            font-size: 11px;
            color: #6b7280;
            background: #f3f4f6;
            padding: 2px 8px;
            border-radius: 3px;
        }
        .side-cart-item-price {
            color: #0066cc;
            font-weight: 700;
            font-size: 14px;
        }
        .side-remove-btn {
            background: transparent;
            border: none;
            color: #CBD5E1;
            cursor: pointer;
            font-size: 15px;
            padding: 4px;
            border-radius: 4px;
            transition: 0.2s;
            flex-shrink: 0;
        }
        .side-remove-btn:hover { color: #EF4444; background: #FEF2F2; }
        .cart-sidebar-footer {
            padding: 20px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
        }
        .side-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .side-total-label {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .side-total-amount {
            font-size: 22px;
            color: #111827;
            font-weight: 800;
        }
        .side-checkout-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #0066cc, #3B82F6);
            color: white;
            font-weight: 700;
            font-size: 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .side-checkout-btn:hover {
            background: linear-gradient(135deg, #0052a3, #0066cc);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,102,204,0.3);
        }
        
        .mobile-summary-bar { 
            display: none; position: fixed; bottom: 0; left: 0; right: 0; 
            background-color: #ffffff; border-top: 1px solid #e5e7eb; padding: 16px;
            z-index: 90; align-items: center; justify-content: space-between; 
        }
        /* Media Queries */
        @media (max-width: 1100px) { 
            .builder-grid { grid-template-columns: 1fr; } 
            .summary-card { position: static; } 
        }
        @media (max-width: 900px) {
            .sidebar { transform: translateX(-250px); }
            .sidebar.mobile-open { transform: translateX(0); box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
            .mobile-topbar { display: flex; }
            .mobile-summary-bar { display: flex; }
            .topbar { display: none; }
            .main { margin-left: 0; padding-top: 60px; }
            .content { padding: 16px 16px 100px; }
            .builder-grid > .summary-card { display: none; }
            .persona-grid { grid-template-columns: repeat(2, 1fr); }
            .form-row { grid-template-columns: 1fr; }
        }
        @media (max-width: 480px) {
            .step-label { display: none; }
            .card-body, .card-header { padding: 16px; }
        }

    </style>
</head>

<body>
    <div class="mobile-topbar">
        <div class="m-logo">Digital<span>Bazaar</span></div>
        <button class="hamburger" onclick="toggleSidebar()">☰</button>
    </div>
    
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <aside class="sidebar" id="sidebar">
        <div class="logo"><h2>Digital<span>Bazaar</span></h2></div>
        
        <div class="sidebar-label">Main Menu</div>
        <ul class="menu">
            <li onclick="location.href='<%= request.getContextPath() %>/dashboard'"><span class="icon">🏠</span> Dashboard</li>
            <li onclick="location.href='<%= request.getContextPath() %>/shop'"><span class="icon">🛍️</span> Shop</li>
            <li onclick="location.href='<%= request.getContextPath() %>/pcbuilder'" class="active"><span class="icon">🖥️</span> PC Builder</li>
            <li onclick="location.href='<%= request.getContextPath() %>/performanceSimulator'"><span class="icon">📊</span> Simulator</li>
        </ul>
        
        <div class="sidebar-label">Account</div>
        <ul class="menu">
            <li><span class="icon">👤</span> Profile</li>
            <li><span class="icon">⚙️</span> Settings</li>
        </ul>
        
        <div class="sidebar-footer">
            <button class="logout-btn" onclick="location.href='<%= request.getContextPath() %>/logout'">Logout</button>
        </div>
    </aside>

    <!-- ================= CART SIDEBAR ================= -->
    <div class="cart-sidebar" id="builderCartSidebar">
        <div class="cart-sidebar-header">
            <h2>Your Cart</h2>
            <span class="close-cart" onclick="toggleBuilderCart()">✕</span>
        </div>
        <div id="sideCartItems">
            <div class="side-cart-empty">
                <div style="font-size:40px; margin-bottom:12px;">🛒</div>
                <div>Your cart is empty</div>
            </div>
        </div>
        <div class="cart-sidebar-footer">
            <div class="side-total-row">
                <span class="side-total-label">Total</span>
                <span class="side-total-amount">$<span id="sideCartTotal">0.00</span></span>
            </div>
            <button class="side-checkout-btn" onclick="alert('Proceeding to checkout...')">Proceed to Checkout</button>
        </div>
    </div>
    
    <div class="main">
        <div class="topbar">
            <div class="topbar-left">
                <span class="page-badge">Smart Tool</span>
                <h1>PC Builder</h1>
            </div>
            <div class="topbar-right">
                <span class="chip">Live Products</span>
                <div class="avatar">U</div>
            </div>
        </div>
        
        <div class="content">
            <div class="wizard-steps">
                <div class="step done"><div class="step-num">✓</div><div class="step-label">Persona</div></div>
                <div class="step-connector"></div>
                <div class="step active"><div class="step-num">2</div><div class="step-label">Configure</div></div>
                <div class="step-connector"></div>
                <div class="step"><div class="step-num">3</div><div class="step-label">Review</div></div>
            </div>
            
            <div class="builder-grid">
                <div>
                    <div class="card">
                        <div class="card-header"><h3>Target Workload</h3></div>
                        <div class="card-body">
                            <div class="persona-grid">
                                <div class="persona-card selected" onclick="selectPersona(this,'gamer')">
                                    <div class="pc-icon">🎮</div><div class="pc-label">Gamer</div><div class="pc-desc">High FPS, 1440p/4K</div>
                                </div>
                                <div class="persona-card" onclick="selectPersona(this,'streamer')">
                                    <div class="pc-icon">📡</div><div class="pc-label">Streamer</div><div class="pc-desc">Stream & Play</div>
                                </div>
                                <div class="persona-card" onclick="selectPersona(this,'editor')">
                                    <div class="pc-icon">🎬</div><div class="pc-label">Video Editor</div><div class="pc-desc">4K Timelines</div>
                                </div>
                                <div class="persona-card" onclick="selectPersona(this,'datascience')">
                                    <div class="pc-icon">📊</div><div class="pc-label">Data Scientist</div><div class="pc-desc">Big Data Processing</div>
                                </div>
                            </div>
                            <div id="personaInfo" class="persona-info"></div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header"><h3>Budget Allocation</h3></div>
                        <div class="card-body">
                            <div class="budget-value" id="budgetDisplay">$1,500</div>
                            <input type="range" min="400" max="6000" step="50" value="1500" id="budgetSlider" oninput="onBudgetChange(this.value)">
                            <div class="range-labels"><span>$400</span><span>$6,000</span></div>
                            <div class="budget-hint" id="budgetHint">Mid-range build recommended for solid performance.</div>
                            <div class="budget-tiers">
                                <div class="tier-pill" onclick="setTier(700)">Entry (≤$700)</div>
                                <div class="tier-pill" onclick="setTier(1200)">Mid (≤$1.2k)</div>
                                <div class="tier-pill active" onclick="setTier(1800)">High (≤$1.8k)</div>
                                <div class="tier-pill" onclick="setTier(2800)">Ultra (≤$2.8k)</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header"><h3>System Preferences</h3></div>
                        <div class="card-body">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Hardware Priority</label>
                                    <select id="priority" onchange="reApplyDefaults()">
                                        <option value="balanced">Balanced Configuration</option>
                                        <option value="cpu">CPU Processing Power</option>
                                        <option value="gpu">GPU Graphic Performance</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Chassis Size</label>
                                    <select id="formFactor">
                                        <option value="atx">Standard ATX (Full Size)</option>
                                        <option value="matx">Micro-ATX (Compact)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3>Component Selection</h3>
                        </div>
                        <div class="card-body">
                            <div id="recBanner"></div>
                            <div class="component-slots" id="componentSlots"></div>
                        </div>
                    </div>
                </div>
                
                <div class="summary-card">
                    <div class="card">
                        <div class="card-header"><h3>Financial Summary</h3></div>
                        <div class="card-body">
                            <div class="budget-gauge-wrap">
                                <div class="budget-nums">
                                    <span>Allocated Spent:</span>
                                    <span class="spent" id="budgetSpent">$0</span>
                                </div>
                                <div style="margin-top:8px;" class="budget-gauge-track">
                                    <div class="budget-gauge-fill" id="budgetGaugeFill" style="width: 0%"></div>
                                </div>
                            </div>
                            <div id="budgetStatus" class="budget-status">Loading Status...</div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header"><h3>Build Invoice</h3></div>
                        <div class="card-body">
                            <div class="price-breakdown" id="priceBreakdown"></div>
                            <div class="divider"></div>
                            <div class="price-total-row">
                                <span class="price-total-label">Final Total</span>
                                <span class="price-total-val" id="totalPrice">$0.00</span>
                            </div>

                            <!-- ===== CHANGED BUTTONS ===== -->
                            <button class="btn-primary" id="addToCartBtn" onclick="addToCart()">🛒 Add to Cart</button>
                            <button class="btn-buynow" onclick="buyNow()">⚡ Buy Now</button>
                            <button class="btn-secondary" onclick="saveBuild()">💾 Save Draft</button>
                            <!-- ===== END CHANGED BUTTONS ===== -->

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="mobile-summary-bar">
        <div>
            <div style="font-size: 12px; color: #6b7280;">Total Estimate</div>
            <div style="font-size: 18px; font-weight: 700; color: #111827;" id="mobileTotalPrice">$0.00</div>
        </div>
        <button style="background: linear-gradient(135deg,#1E40AF,#2563EB); color: white; border: none; padding: 10px 16px; border-radius: 6px; font-weight: 700;" onclick="addToCart()">🛒 Add to Cart</button>
    </div>

    <script>
    <%
try {
    Map<String, List<Product>> byCategory = 
        (Map<String, List<Product>>) request.getAttribute("productsByCategory");
    if (byCategory == null || byCategory.isEmpty()) {
        out.println("const DB = {};");
    } else {
        StringBuilder sb = new StringBuilder();
        sb.append("const DB = ");
        sb.append("{");
        
        boolean firstCat = true;
        for (Map.Entry<String, List<Product>> entry : byCategory.entrySet()) {
            if (!firstCat) sb.append(",");
            firstCat = false;
            
            String cat = entry.getKey();
            sb.append("\"").append(cat).append("\":[");
            
            boolean firstProd = true;
            for (Product p : entry.getValue()) {
                if (!firstProd) sb.append(",");
                firstProd = false;
                
                String name = p.getName() == null ? "" : p.getName()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "")
                    .replace("\n", "")
                    .replace("\t", " ")
                    .replace("'", "\\'");
                    
                String img = p.getImage() == null ? "" : p.getImage()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"");
                
                sb.append("{")
                  .append("\"id\":").append(p.getId()).append(",")
                  .append("\"name\":\"").append(name).append("\",")
                  .append("\"price\":").append(p.getPrice()).append(",")
                  .append("\"stock\":").append(p.getStock()).append(",")
                  .append("\"img\":\"").append(img).append("\"")
                  .append("}");
            }
            sb.append("]");
        }
        sb.append("};");
        out.println(sb.toString());
    }
} catch (Throwable t) {
    out.println("const DB = {};");
    out.println("console.error('DB build failed: " + t.getMessage() + "');");
}
%>

    const DB_MAP = {};
    Object.keys(DB).forEach(key => { DB_MAP[key.trim().toLowerCase()] = DB[key]; });
    
    const SLOTS = [
        { key: 'gpu',         label: 'Graphics Card',   icon: '🖥️', cat: 'GPU'         },
        { key: 'cpu',         label: 'Processor',        icon: '🧠', cat: 'CPU'         },
        { key: 'motherboard', label: 'Motherboard',      icon: '🎛️', cat: 'Motherboard' },
        { key: 'ram',         label: 'Memory (RAM)',     icon: '💾', cat: 'RAM'         },
        { key: 'storage',     label: 'Primary Storage',  icon: '💿', cat: 'Storage'     },
        { key: 'cooler',      label: 'Cooling System',   icon: '❄️', cat: 'Cooler'      },
        { key: 'psu',         label: 'Power Supply',     icon: '⚡', cat: 'PSU'         },
        { key: 'case',        label: 'Chassis',          icon: '📦', cat: 'Case'        }
    ];
     
    const PERSONAS = {
        gamer: {
            label: 'Gamer', tagline: 'High frame rates and visual fidelity',
            priorities: { gpu: 10, cpu: 7, ram: 5, storage: 4 },
            budgetWeights: { gpu: .38, cpu: .17, motherboard: .10, ram: .10, storage: .08, cooler: .07, psu: .06, case: .04 }
        },
        streamer: {
            label: 'Streamer', tagline: 'Simultaneous rendering and broadcast',
            priorities: { gpu: 8, cpu: 10, ram: 7, storage: 5 },
            budgetWeights: { gpu: .30, cpu: .22, motherboard: .12, ram: .13, storage: .08, cooler: .07, psu: .05, case: .03 }
        },
        editor: {
            label: 'Video Editor', tagline: 'Rapid encoding and timeline scrubbing',
            priorities: { gpu: 7, cpu: 10, ram: 9, storage: 7 },
            budgetWeights: { gpu: .24, cpu: .22, motherboard: .10, ram: .17, storage: .12, cooler: .07, psu: .05, case: .03 }
        },
        datascience: {
            label: 'Data Scientist', tagline: 'Large scale data processing',
            priorities: { gpu: 6, cpu: 9, ram: 10, storage: 8 },
            budgetWeights: { gpu: .20, cpu: .22, motherboard: .10, ram: .22, storage: .12, cooler: .06, psu: .05, case: .03 }
        }
    };
     
    let currentPersona = 'gamer';
    const slotSelection = {};

    // ─── Cart state ────────────────────────────────────────────────────────────
    let sideCart = [];

    function toggleBuilderCart() {
        document.getElementById('builderCartSidebar').classList.toggle('active');
    }

    function renderSideCart() {
        var container = document.getElementById('sideCartItems');

        if (sideCart.length === 0) {
            container.innerHTML = '<div class="side-cart-empty"><div style="font-size:40px;margin-bottom:12px;">🛒</div><div>Your cart is empty</div></div>';
            document.getElementById('sideCartTotal').textContent = '0.00';
            return;
        }

        var html  = '';
        var total = 0;

        sideCart.forEach(function(item, i) {
            var displayName  = item.name || 'Unknown Product';
            var displayPrice = isNaN(item.price) ? '0.00' : item.price.toFixed(2);
            total += item.price || 0;

            html += '<div class="side-cart-item">'
                +     '<img src="' + item.img + '" alt="' + displayName + '" '
                +          'onerror="this.style.display=\'none\'">'
                +     '<div class="side-cart-item-info">'
                +         '<strong>' + displayName + '</strong>'
                +         '<div class="side-cart-item-meta">'
                +             '<span class="side-cart-item-qty">Qty: ' + item.qty + '</span>'
                +             '<span class="side-cart-item-price">$' + displayPrice + '</span>'
                +         '</div>'
                +     '</div>'
                +     '<button class="side-remove-btn" onclick="removeSideCartItem(' + i + ')" title="Remove">✕</button>'
                + '</div>';
        });

        container.innerHTML = html;
        document.getElementById('sideCartTotal').textContent = total.toFixed(2);
    }

    function removeSideCartItem(index) {
        sideCart.splice(index, 1);
        renderSideCart();
    }
     
    // ─── Helpers ───────────────────────────────────────────────────────────────
    function getCatProducts(cat)       { return DB_MAP[cat.trim().toLowerCase()] || []; }
    function getProductById(cat, id)   { return getCatProducts(cat).find(p => p.id === id) || null; }
    function sortedByPrice(cat)        { return [...getCatProducts(cat)].sort((a, b) => a.price - b.price); }
     
    function applyRecommendations() {
        optimizeBuild();
        renderPersonaInfo();
        document.getElementById('recBanner').innerHTML =
            '<div class="rec-banner">'
            + '<div class="rec-banner-text">'
            +   '<strong>Configuration updated for ' + PERSONAS[currentPersona].label + '.</strong> '
            +   'Components have been preselected based on workload priorities and your budget.'
            + '</div>'
            + '</div>';
    }
     
    function reApplyDefaults() { applyRecommendations(); }
     
    function renderPersonaInfo() {
        const persona = PERSONAS[currentPersona];
        let barsHTML = '';
        ['gpu', 'cpu', 'ram', 'storage'].forEach(function(key) {
            const pct = Math.round((persona.priorities[key] || 0) * 10);
            barsHTML += '<div class="priority-row">'
                + '<span class="priority-label">' + key.toUpperCase() + '</span>'
                + '<div class="priority-track"><div class="priority-fill" style="width:' + pct + '%"></div></div>'
                + '<span class="priority-pct">' + pct + '%</span>'
                + '</div>';
        });
        document.getElementById('personaInfo').innerHTML =
            '<div class="persona-info-header">'
            + '<div>'
            +   '<div class="persona-info-title">' + persona.label + ' Workload</div>'
            +   '<div class="persona-info-sub">' + persona.tagline + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="priority-bars">' + barsHTML + '</div>';
    }
     
    function renderSlots() {
        const container = document.getElementById('componentSlots');
        container.innerHTML = '';
        SLOTS.forEach(slot => {
            const sorted = sortedByPrice(slot.cat);
            if (!sorted.length) return;
            const selectedId   = slotSelection[slot.key];
            const selectedProd = getProductById(slot.cat, selectedId) || sorted[0];
            slotSelection[slot.key] = selectedProd.id;
            let optionsHTML = '';
            sorted.forEach(function(p) {
                const selected = (p.id == selectedProd.id) ? 'selected' : '';
                optionsHTML += '<option value="' + p.id + '" ' + selected + '>'
                             + p.name + ' — $' + Number(p.price).toFixed(2)
                             + '</option>';
            });
            const stockText = selectedProd.stock === 0
                ? '<span class="stock-out">Out of Stock</span>'
                : '<span class="stock-ok">In Stock (' + selectedProd.stock + ')</span>';
            const slotHTML = '<div class="component-slot">'
                + '<div class="slot-header">'
                +   '<span class="slot-icon">' + slot.icon + '</span>'
                +   '<span class="slot-label-text">' + slot.label + '</span>'
                +   '<span class="slot-price-badge">$' + Number(selectedProd.price).toFixed(2) + '</span>'
                + '</div>'
                + '<div class="slot-body">'
                +   '<select class="slot-native-select" onchange="onSlotChange(\'' + slot.key + '\', \'' + slot.cat + '\', parseInt(this.value))">'
                +   optionsHTML
                +   '</select>'
                +   '<div class="slot-actions">'
                +     '<button class="slot-downgrade-btn" onclick="downgradeSlot(\'' + slot.key + '\',\'' + slot.cat + '\')">Value Option</button>'
                +     '<button class="slot-upgrade-btn" onclick="upgradeSlot(\'' + slot.key + '\',\'' + slot.cat + '\')">Performance Option</button>'
                +     '<div class="slot-stock-badge">' + stockText + '</div>'
                +   '</div>'
                + '</div>'
                + '</div>';
            container.innerHTML += slotHTML;
        });
    }
     
    function onSlotChange(key, cat, id) { slotSelection[key] = id; updateSummary(); renderSlots(); }
     
    function upgradeSlot(key, cat) {
        const sorted = sortedByPrice(cat);
        const idx    = sorted.findIndex(p => p.id === slotSelection[key]);
        if (idx < sorted.length - 1) { slotSelection[key] = sorted[idx + 1].id; updateSummary(); renderSlots(); }
    }
     
    function downgradeSlot(key, cat) {
        const sorted = sortedByPrice(cat);
        const idx    = sorted.findIndex(p => p.id === slotSelection[key]);
        if (idx > 0) { slotSelection[key] = sorted[idx - 1].id; updateSummary(); renderSlots(); }
    }
     
    function optimizeBuild() {
        const budget   = Number(document.getElementById('budgetSlider').value);
        const weights  = { ...PERSONAS[currentPersona].budgetWeights };
        const priority = document.getElementById('priority').value;
     
        if (priority === 'gpu') {
            const boost = 0.15;
            weights.gpu = Math.min(weights.gpu + boost, 0.60);
            const reduction = boost / (SLOTS.length - 1);
            SLOTS.forEach(s => { if (s.key !== 'gpu') weights[s.key] = Math.max((weights[s.key] || 0.05) - reduction, 0.02); });
        } else if (priority === 'cpu') {
            const boost = 0.15;
            weights.cpu = Math.min(weights.cpu + boost, 0.45);
            const reduction = boost / (SLOTS.length - 1);
            SLOTS.forEach(s => { if (s.key !== 'cpu') weights[s.key] = Math.max((weights[s.key] || 0.05) - reduction, 0.02); });
        }
     
        SLOTS.forEach(slot => {
            const products = sortedByPrice(slot.cat);
            if (!products.length) return;
            const target = budget * (weights[slot.key] || 0.05);
            let best = products[0];
            for (const p of products) { if (p.price <= target) best = p; }
            slotSelection[slot.key] = best.id;
        });
     
        renderSlots();
        updateSummary();
    }
     
    function updateSummary() {
        let total = 0;
        let breakdownHTML = '';
        SLOTS.forEach(function(slot) {
            const prod = getProductById(slot.cat, slotSelection[slot.key]);
            if (!prod) return;
            total += Number(prod.price);
            breakdownHTML += '<div class="price-row">'
                + '<div class="price-row-left">'
                +   '<span style="font-size:16px;">' + slot.icon + '</span>'
                +   '<div>'
                +     '<div class="price-row-label">' + slot.label + '</div>'
                +     '<div class="price-row-name">' + prod.name + '</div>'
                +   '</div>'
                + '</div>'
                + '<span class="price-row-val">$' + Number(prod.price).toFixed(2) + '</span>'
                + '</div>';
        });
        document.getElementById('priceBreakdown').innerHTML = breakdownHTML;
        const formattedTotal = '$' + total.toFixed(2);
        document.getElementById('totalPrice').textContent       = formattedTotal;
        document.getElementById('mobileTotalPrice').textContent = formattedTotal;
        document.getElementById('budgetSpent').textContent      = formattedTotal;
        const budget = Number(document.getElementById('budgetSlider').value);
        const fill   = document.getElementById('budgetGaugeFill');
        const status = document.getElementById('budgetStatus');
        const pct    = budget > 0 ? Math.min((total / budget) * 100, 100) : 0;
        fill.style.width = pct + '%';
        if (total > budget) {
            fill.className               = 'budget-gauge-fill gauge-over';
            status.textContent           = 'Warning: $' + (total - budget).toFixed(0) + ' Over Budget';
            status.style.color           = '#dc2626';
            status.style.backgroundColor = '#fef2f2';
            status.style.borderColor     = '#fecaca';
        } else {
            fill.className               = 'budget-gauge-fill gauge-ok';
            status.textContent           = 'Cleared: $' + (budget - total).toFixed(0) + ' Remaining in Budget';
            status.style.color           = '#166534';
            status.style.backgroundColor = '#f0fdf4';
            status.style.borderColor     = '#bbf7d0';
        }
    }
     
    function selectPersona(el, key) {
        document.querySelectorAll('.persona-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        currentPersona = key;
        applyRecommendations();
    }
     
    function onBudgetChange(val) {
        val = parseInt(val);
        document.getElementById('budgetDisplay').textContent = '$' + val.toLocaleString();
        const tiers = [700, 1200, 1800, 2800];
        document.querySelectorAll('.tier-pill').forEach((pill, i) => {
            pill.classList.toggle('active', val <= tiers[i] && (i === 0 || val > tiers[i - 1]));
        });
        optimizeBuild();
    }
     
    function setTier(val) {
        document.getElementById('budgetSlider').value = val;
        onBudgetChange(val);
    }
     
    // ─── CHANGED: Add to Cart — displays items in sidebar cart ─────────────────
    function addToCart() {
    var ctx = '<%= request.getContextPath() %>';

    SLOTS.forEach(function(slot) {
        var prod = getProductById(slot.cat, slotSelection[slot.key]);
        if (!prod) return;

        var imgUrl = ctx + '/images/' + (prod.img || '');

        // Check if item already exists in cart
        var existing = sideCart.find(function(item) { return item.name === prod.name; });
        if (existing) {
            existing.qty   += 1;
            existing.price += Number(prod.price);
        } else {
            sideCart.push({
                name:      prod.name,
                price:     Number(prod.price),
                unitPrice: Number(prod.price),
                img:       imgUrl,
                qty:       1
            });
        }
    });

    renderSideCart();

    var btn      = document.getElementById('addToCartBtn');
    var original = btn.innerHTML;
    btn.innerHTML = '✔ Added to Cart!';
    btn.classList.add('added');
    setTimeout(function() {
        btn.innerHTML = original;
        btn.classList.remove('added');
    }, 2000);

    document.getElementById('builderCartSidebar').classList.add('active');
}

    // ─── CHANGED: Buy Now — adds to cart then shows checkout alert ─────────────
    function buyNow() {
        addToCart();
        setTimeout(() => {
            alert('Proceeding to checkout...');
        }, 300);
    }

    // ─── UNCHANGED: Save Draft ─────────────────────────────────────────────────
    function saveBuild() { alert('Draft configuration saved to local cache.'); }
     
    // ─── Mobile sidebar ─────────────────────────────────────────────────────────
    function toggleSidebar() {
        const sb   = document.getElementById('sidebar');
        const ov   = document.getElementById('sidebarOverlay');
        const open = sb.classList.toggle('mobile-open');
        ov.classList.toggle('active', open);
        document.body.style.overflow = open ? 'hidden' : '';
    }
     
    // ─── Init ────────────────────────────────────────────────────────────────────
    window.onload = () => applyRecommendations();
    </script>
</body>
</html>
