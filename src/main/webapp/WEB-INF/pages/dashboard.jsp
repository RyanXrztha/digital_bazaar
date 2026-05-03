<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<style>

/* ================= RESET ================= */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    /* ================= BODY ================= */
    body {
        background: #F1F5F9;
        color: #0F172A;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        overflow-x: hidden;
    }
    /* ================= NAVBAR ================= */
    .navbar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 60px;
        background: #FFFFFF;
        border-bottom: 1px solid #E2E8F0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 40px;
        z-index: 1000;
    }
    .logo {
        color: #0F172A;
        font-weight: bold;
        letter-spacing: 1px;
    }
    .nav-links {
        list-style: none;
        display: flex;
        gap: 35px;
    }
    .nav-links a {
        text-decoration: none;
        color: #64748B;
        font-size: 14px;
        font-weight: 500;
        transition: 0.2s;
    }
    .nav-links a:hover {
        color: #1E40AF;
    }
    .nav-icons {
        display: flex;
        align-items: center;
        gap: 20px;
        font-size: 18px;
    }
    .icon {
        cursor: pointer;
        color: #0F172A;
        position: relative;
        transition: 0.2s;
    }
    .icon:hover {
        color: #3B82F6;
    }
    .cart-count {
        position: absolute;
        top: -6px;
        right: -8px;
        background: #1E40AF;
        color: white;
        font-size: 10px;
        font-weight: bold;
        padding: 2px 6px;
        border-radius: 50%;
    }

    /* ================= CART SIDEBAR ================= */
    .cart-sidebar {
        position: fixed;
        top: 60px;
        right: -420px;
        width: 400px;
        height: calc(100% - 60px);
        background: #FFFFFF;
        border-left: 1px solid #E2E8F0;
        display: flex;
        flex-direction: column;
        transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        z-index: 999;
        box-shadow: -5px 0 20px rgba(0,0,0,0.08);
    }
    .cart-sidebar.active {
        right: 0;
    }
    .cart-header {
        padding: 22px 24px;
        border-bottom: 1px solid #E2E8F0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #FFFFFF;
    }
    .cart-header h2 {
        font-size: 1.1rem;
        font-weight: 700;
        color: #0F172A;
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
    .close-cart:hover {
        color: #0F172A;
        background: #F1F5F9;
    }
    #cartItems {
        flex: 1;
        overflow-y: auto;
        padding: 16px;
    }
    #cartItems::-webkit-scrollbar { width: 4px; }
    #cartItems::-webkit-scrollbar-track { background: #F8FAFC; }
    #cartItems::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 2px; }
    .cart-empty {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 200px;
        color: #94A3B8;
        font-size: 14px;
    }
    .cart-empty-icon { font-size: 40px; margin-bottom: 12px; }
    .cart-item {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 0;
        border-bottom: 1px solid #F1F5F9;
    }
    .cart-item:last-child { border-bottom: none; }
    .cart-item img {
        width: 68px;
        height: 68px;
        background: #F8FAFC;
        border: 1px solid #E2E8F0;
        border-radius: 6px;
        padding: 6px;
        object-fit: contain;
        flex-shrink: 0;
    }
    .cart-item-info { flex: 1; min-width: 0; }
    .cart-item-info strong {
        display: block;
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 4px;
        color: #0F172A;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .cart-item-meta {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 6px;
    }
    .cart-item-qty {
        font-size: 11px;
        color: #64748B;
        background: #F1F5F9;
        padding: 2px 8px;
        border-radius: 3px;
    }
    .cart-item-price {
        color: #1E40AF;
        font-weight: 700;
        font-size: 15px;
    }
    .remove-item {
        background: transparent;
        border: none;
        color: #CBD5E1;
        cursor: pointer;
        font-size: 16px;
        padding: 4px;
        border-radius: 4px;
        transition: 0.2s;
        flex-shrink: 0;
    }
    .remove-item:hover { color: #EF4444; background: #FEF2F2; }
    .cart-footer {
        padding: 20px;
        background: #F8FAFC;
        border-top: 1px solid #E2E8F0;
    }
    .total-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }
    .total-container h3 {
        font-size: 13px;
        font-weight: 600;
        color: #64748B;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .total-amount {
        font-size: 22px;
        color: #0F172A;
        font-weight: 800;
    }
    .checkout-btn {
        width: 100%;
        padding: 14px;
        background: linear-gradient(135deg, #1E40AF, #3B82F6);
        color: white;
        font-weight: 700;
        font-size: 14px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: 0.3s;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
    .checkout-btn:hover {
        background: linear-gradient(135deg, #172554, #1E40AF);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(30,64,175,0.3);
    }

    /* ================= HERO ================= */
    .hero {
        position: relative;
        height: 60vh;
        width: 100%;
        display: flex;
        align-items: center;
        overflow: hidden;
        margin-top: 60px;
        background: #0F172A;
    }
    .hero-content {
        position: relative;
        z-index: 2;
        padding-left: 80px;
        max-width: 700px;
    }
    .hero-title {
        font-size: 64px;
        font-weight: 800;
        line-height: 1.1;
        color: #FFFFFF;
        margin-bottom: 20px;
    }
    .hero-title span { color: #3B82F6; }
    .hero-desc {
        font-size: 18px;
        color: #94A3B8;
        margin-bottom: 10px;
        line-height: 1.6;
    }
    .hero-offer {
        font-size: 18px;
        font-weight: bold;
        color: #3B82F6;
        margin-bottom: 30px;
    }
    .hero-buttons { display: flex; gap: 18px; }
    #best-sellers { scroll-margin-top: 70px; }
    .btn {
        padding: 14px 34px;
        font-size: 14px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.2s;
        border-radius: 4px;
    }
    .btn-primary {
        background: #1E40AF;
        color: white;
        border: none;
    }
    .btn-primary:hover { background: #172554; }
    .btn-outline {
        background: none;
        border: 2px solid #334155;
        color: #FFFFFF;
    }
    .btn-outline:hover { border-color: #3B82F6; color: #3B82F6; }

    /* ================= SECTION HEADER ================= */
    .section-header {
        display: flex;
        justify-content: space-between;
        border-bottom: 1px solid #E2E8F0;
        margin-bottom: 30px;
        padding-bottom: 15px;
        margin-top: 60px;
        padding-left: 60px;
        padding-right: 60px;
    }
    .section-title {
        font-size: 24px;
        font-weight: 700;
        border-left: 4px solid #1E40AF;
        padding-left: 15px;
        color: #0F172A;
    }

    /* ================= GRID ================= */
    .products-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 24px;
        padding: 0 60px;
    }

    /* ================= PRODUCT CARD ================= */
    .product-card {
        background: #FFFFFF;
        border: 1px solid #E2E8F0;
        transition: 0.3s;
        display: flex;
        flex-direction: column;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    .product-card:hover {
        border-color: #3B82F6;
        transform: translateY(-2px);
    }
    .product-img-wrap {
        height: 220px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #F8FAFC;
        border-bottom: 1px solid #F1F5F9;
    }
    .product-img {
        max-width: 85%;
        max-height: 85%;
        object-fit: contain;
    }
    .product-info { padding: 20px; }
    .product-title-row {
        display: flex;
        flex-direction: column;
        gap: 5px;
        margin-bottom: 10px;
    }
    .product-info strong { font-size: 15px; color: #0F172A; }
    .product-price { color: #1E40AF; font-weight: 700; font-size: 18px; }
    .product-sub { font-size: 12px; color: #64748B; margin-top: 5px; }
    .product-actions { display: flex; gap: 10px; margin-top: 15px; }

    /* ================= ADD TO CART BUTTON — PROFESSIONAL ================= */
    .btn-cart {
        flex: 1;
        padding: 10px 14px;
        background: linear-gradient(135deg, #1E40AF 0%, #2563EB 100%);
        border: none;
        color: #FFFFFF;
        font-weight: 700;
        font-size: 12px;
        letter-spacing: 0.6px;
        text-transform: uppercase;
        cursor: pointer;
        border-radius: 5px;
        transition: all 0.25s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        box-shadow: 0 2px 6px rgba(30,64,175,0.25);
        position: relative;
        overflow: hidden;
    }
    .btn-cart::before {
        content: '';
        position: absolute;
        top: 0; left: -100%;
        width: 100%; height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
        transition: left 0.4s ease;
    }
    .btn-cart:hover::before { left: 100%; }
    .btn-cart:hover {
        background: linear-gradient(135deg, #172554 0%, #1E40AF 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(30,64,175,0.35);
    }
    .btn-cart:active {
        transform: translateY(0);
        box-shadow: 0 1px 4px rgba(30,64,175,0.2);
    }
    .btn-cart.added {
        background: linear-gradient(135deg, #166534, #16a34a);
        box-shadow: 0 2px 6px rgba(22,101,52,0.3);
    }

    /* BUY BUTTON */
    .btn-buy {
        flex: 1;
        padding: 10px;
        background: transparent;
        border: 1px solid #E2E8F0;
        color: #64748B;
        cursor: pointer;
        border-radius: 4px;
        transition: 0.2s;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .btn-buy:hover { border-color: #1E40AF; color: #1E40AF; }

    /* ================= FOOTER ================= */
    .footer {
        background: #0F172A;
        border-top: 1px solid #1E293B;
        padding: 50px 30px;
        text-align: center;
        margin-top: 80px;
        color: #94A3B8;
    }
    .footer strong { color: #FFFFFF; display: block; margin-bottom: 10px; }

    /* ================= RESPONSIVE ================= */
    @media (max-width: 1100px) {
        .products-grid { grid-template-columns: repeat(3, 1fr); padding: 0 30px; }
    }
    @media (max-width: 850px) {
        .products-grid { grid-template-columns: repeat(2, 1fr); }
        .hero-title { font-size: 48px; }
    }
    @media (max-width: 600px) {
        .products-grid { grid-template-columns: 1fr; }
        .hero-content { padding-left: 30px; }
    }

	</style>
</head>
<body>
	<div class="navbar">
		<div class="logo">Digital_Bazaar</div>
		<ul class="nav-links">
			<li><a href="${pageContext.request.contextPath}/dashboard">HOME</a></li>
			<li><a href="${pageContext.request.contextPath}/shop">SHOP</a></li>
			<li><a href="#">CONTACT</a></li>
		</ul>
		<div class="nav-icons">
			<div class="icon" onclick="toggleCart()">
				🛒<span class="cart-count">0</span>
			</div>
			<div class="icon">👤</div>
		</div>
	</div>

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
	            <span class="total-amount">$<span id="totalPrice">0.00</span></span>
	        </div>
	        <button class="checkout-btn" onclick="handleCheckout()">Proceed to Checkout</button>
	    </div>
	</div>

	<!-- ================= HERO ================= -->
	<div class="hero">
	<video autoplay muted loop>
	<source src="<%=request.getContextPath()%>/videos/hero.mp4" type="video/mp4">
	</video>
	<div class="hero-overlay"></div>
	<div class="hero-content">
	<div class="hero-title">
	NEW SEASON <br>
	<span>COLLECTION</span>
	</div>
	<div class="hero-desc">
	Performance redefined. Secure the latest high-end hardware.
	</div>
	<div class="hero-offer">
	Up to 50% Off Today.
	</div>
	<div class="hero-buttons">
	<button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/shop'">
	SHOP NOW
	</button>
	<button class="btn btn-outline" onclick="document.getElementById('best-sellers').scrollIntoView({behavior:'smooth'})">
	EXPLORE COLLECTION
	</button>
	</div>
	</div>
	</div>

	<!-- ================= BEST SELLERS ================= -->

<div class="section-header" id="best-sellers">
    <div class="section-title">BEST_SELLERS</div>
</div>
<div class="products-grid" id="best-sellers-grid">
    <div class="product-card"
         data-name="RTX 4090"
         data-price="1899"
         data-img="<%=request.getContextPath()%>/images/products/p1.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p1.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>RTX 4090</div>
                <div class="product-price">$1899</div>
            </div>
            <div class="product-sub">GPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Ryzen 9 7950X"
         data-price="599"
         data-img="<%=request.getContextPath()%>/images/products/p2.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p2.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Ryzen 9 7950X</div>
                <div class="product-price">$599</div>
            </div>
            <div class="product-sub">CPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Corsair 32GB DDR5"
         data-price="299"
         data-img="<%=request.getContextPath()%>/images/products/p3.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p3.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Corsair 32GB DDR5</div>
                <div class="product-price">$299</div>
            </div>
            <div class="product-sub">RAM</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Samsung 980 Pro 1TB"
         data-price="149"
         data-img="<%=request.getContextPath()%>/images/products/p4.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p4.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Samsung 980 Pro 1TB</div>
                <div class="product-price">$149</div>
            </div>
            <div class="product-sub">Storage</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
</div>
<div class="section-header">
    <div class="section-title">NEW_ARRIVALS</div>
</div>
<div class="products-grid">
    <div class="product-card"
         data-name="RTX 4060"
         data-price="399"
         data-img="<%=request.getContextPath()%>/images/products/p16.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p16.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>RTX 4060</div>
                <div class="product-price">$399</div>
            </div>
            <div class="product-sub">GPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="RX 7900 XT"
         data-price="999"
         data-img="<%=request.getContextPath()%>/images/products/p17.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p17.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>RX 7900 XT</div>
                <div class="product-price">$999</div>
            </div>
            <div class="product-sub">GPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Ryzen 5 7600X"
         data-price="249"
         data-img="<%=request.getContextPath()%>/images/products/p18.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p18.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Ryzen 5 7600X</div>
                <div class="product-price">$249</div>
            </div>
            <div class="product-sub">CPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="ADATA 16GB DDR5"
         data-price="119"
         data-img="<%=request.getContextPath()%>/images/products/p19.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p19.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>ADATA 16GB DDR5</div>
                <div class="product-price">$119</div>
            </div>
            <div class="product-sub">RAM</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Samsung 2TB SSD"
         data-price="199"
         data-img="<%=request.getContextPath()%>/images/products/p20.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p20.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Samsung 2TB SSD</div>
                <div class="product-price">$199</div>
            </div>
            <div class="product-sub">Storage</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="RTX 3090"
         data-price="1199"
         data-img="<%=request.getContextPath()%>/images/products/p21.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p21.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>RTX 3090</div>
                <div class="product-price">$1199</div>
            </div>
            <div class="product-sub">GPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Intel i5 13400"
         data-price="199"
         data-img="<%=request.getContextPath()%>/images/products/p22.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p22.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Intel i5 13400</div>
                <div class="product-price">$199</div>
            </div>
            <div class="product-sub">CPU</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
    <div class="product-card"
         data-name="Kingston 32GB RAM"
         data-price="149"
         data-img="<%=request.getContextPath()%>/images/products/p23.jpg">
        <div class="product-img-wrap">
            <img src="<%=request.getContextPath()%>/images/products/p23.jpg" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-title-row">
                <div>Kingston 32GB RAM</div>
                <div class="product-price">$149</div>
            </div>
            <div class="product-sub">RAM</div>
            <div class="product-actions">
                <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
                <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
            </div>
        </div>
    </div>
</div>

	<!-- ================= FOOTER ================= -->
	<div class="footer">
	© 2025 Kinetic Terminal — All Rights Reserved
	</div>

	<script>
    const isLoggedIn = ${isLoggedIn == true ? "true" : "false"};

    let cart = [];

    function toggleCart() {
        document.getElementById('cartSidebar').classList.toggle('active');
    }

    function addToCart(btn) {
        if (!isLoggedIn) {
            alert("Please login first!");
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }

        var card  = btn.closest('.product-card');
        var name  = card.dataset.name  || card.querySelector('h3').textContent.trim();
        var price = parseFloat(card.dataset.price || card.querySelector('.price').textContent.replace('$','').trim());
        var img   = card.dataset.img   || card.querySelector('img').src;

        // Check if item already exists in cart
        var existing = cart.find(function(item) { return item.name === name; });
        if (existing) {
            existing.qty   += 1;
            existing.price += price;
        } else {
            cart.push({ name: name, price: price, img: img, qty: 1, unitPrice: price });
        }

        var original = btn.innerHTML;
        btn.innerHTML = '✔ ADDED';
        btn.classList.add('added');
        setTimeout(function() {
            btn.innerHTML = original;
            btn.classList.remove('added');
        }, 1500);

        updateCartCount();
        renderCart();
        document.getElementById('cartSidebar').classList.add('active');
    }

    function handleBuyNow(btn) {
        if (!isLoggedIn) {
            alert("Please login first!");
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }
        addToCart(btn.previousElementSibling);
    }

    function removeItem(index) {
        cart.splice(index, 1);
        updateCartCount();
        renderCart();
    }

    function updateCartCount() {
        document.querySelector('.cart-count').textContent = cart.length;
    }

    function renderCart() {
        const container = document.getElementById('cartItems');

        if (cart.length === 0) {
            container.innerHTML = '<div class="cart-empty" id="cartEmpty"><div class="cart-empty-icon">🛒</div><div>Your cart is empty</div></div>';
            document.getElementById('totalPrice').textContent = '0.00';
            return;
        }

        let html  = '';
        let total = 0;

        cart.forEach(function(item, i) {
            var displayName  = item.name  || 'Unknown Product';
            var displayPrice = isNaN(item.price) ? '0.00' : item.price.toFixed(2);
            total += item.price || 0;
            html += '<div class="cart-item">'
                +     '<img src="' + (item.img || '') + '" alt="' + displayName + '">'
                +     '<div class="cart-item-info">'
                +         '<strong>' + displayName + '</strong>'
                +         '<div class="cart-item-meta">'
                +             '<span class="cart-item-qty">Qty: ' + item.qty + '</span>'
                +             '<span class="cart-item-price">$' + displayPrice + '</span>'
                +         '</div>'
                +     '</div>'
                +     '<button class="remove-item" onclick="removeItem(' + i + ')">✕</button>'
                + '</div>';
        });

        container.innerHTML = html;
        document.getElementById('totalPrice').textContent = total.toFixed(2);
    }

    function handleCheckout() {
        if (cart.length === 0) {
            alert('Your cart is empty!');
            return;
        }
        alert('Proceeding to checkout...');
    }
</script>
</body>
</html>
