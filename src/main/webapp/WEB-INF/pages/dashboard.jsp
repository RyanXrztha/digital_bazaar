<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<style>
	
		/* ================= RESET ================= */
		
		/* ================= RESET ================= */

* {
margin: 0;
padding: 0;
box-sizing: border-box;
}

/* ================= BODY ================= */

body {
background: #0f172a;
color: #e5e7eb;
font-family: Segoe UI, Arial, sans-serif;
overflow-x: hidden;
}

/* ================= NAVBAR ================= */

.navbar {

position: fixed;
top: 0;
left: 0;
width: 100%;
height: 60px;
background: #020617;
border-bottom: 1px solid #1f2937;
display: flex;
align-items: center;
justify-content: space-between;
padding: 0 40px;
z-index: 1000;
}

/* LOGO */

.logo {
color: #3b82f6;
font-weight: bold;
letter-spacing: 2px;
}

/* NAV LINKS */

.nav-links {
list-style: none;
display: flex;
gap: 35px;
}

.nav-links a {
text-decoration: none;
color: #94a3b8;
font-size: 14px;
transition: 0.2s;
}

.nav-links a:hover {
color: #e5e7eb;
}

/* ICON AREA */

.nav-icons {
display: flex;
align-items: center;
gap: 20px;
font-size: 18px;
}

/* ICON */

.icon {

cursor: pointer;
color: #94a3b8;
position: relative;
transition: 0.2s;
}

.icon:hover {
color: #e5e7eb;
}

/* CART COUNT */

.cart-count {
position: absolute;
top: -6px;
right: -8px;
background: #3b82f6;
color: white;
font-size: 10px;
padding: 2px 6px;
border-radius: 50%;
}

/* ================= HERO ================= */

.hero {
position: relative;
height: 100vh;
width: 100%;
display: flex;
align-items: center;
overflow: hidden;
margin-top: 60px;
}

/* DARK OVERLAY */

.hero-overlay {

position: absolute;
top: 0;
left: 0;
width: 100%;
height: 100%;
background: rgba(0, 0, 0, 0.6);
z-index: 1;
}

/* HERO CONTENT */

.hero-content {
position: relative;
z-index: 2;
padding-left: 80px;
max-width: 700px;
}

/* HERO TITLE */

.hero-title {
font-size: 80px;
font-weight: 800;
line-height: 1.05;
letter-spacing: 1px;
margin-bottom: 20px;
}

.hero-title span {
color: #3b82f6;
}

/* DESCRIPTION */

.hero-desc {
font-size: 18px;
color: #94a3b8;
margin-bottom: 10px;
line-height: 1.6;
}

/* OFFER */

.hero-offer {
font-size: 18px;
font-weight: bold;
color: #3b82f6;
margin-bottom: 30px;
}

/* BUTTON GROUP */

.hero-buttons {
display: flex;
gap: 18px;
}

#best-sellers {
    scroll-margin-top: 70px;
}

/* BUTTON BASE */

.btn {
padding: 14px 34px;
font-size: 14px;
font-weight: bold;
cursor: pointer;
transition: 0.2s;
border-radius: 6px;
}

/* PRIMARY BUTTON */

.btn-primary {
background: #3b82f6;
color: white;
border: none;
}

.btn-primary:hover {
background: #2563eb;
}

/* OUTLINE BUTTON */

.btn-outline {
background: none;
border: 2px solid #1f2937;
color: #e5e7eb;
}

.btn-outline:hover {
border-color: #3b82f6;
color: #3b82f6;
}

/* ================= SECTION HEADER ================= */

.section-header {

display: flex;
justify-content: space-between;
border-bottom: 1px solid #1f2937;
margin-bottom: 30px;
padding-bottom: 15px;
margin-top: 80px;
}

.section-title {
font-size: 24px;
border-left: 3px solid #3b82f6;
padding-left: 12px;
}

/* ================= GRID ================= */

.products-grid {

display: grid;
grid-template-columns: repeat(4, 1fr);
gap: 20px;
}

/* ================= PRODUCT CARD ================= */

.product-card {
background: #111827;
border: 1px solid #1f2937;
transition: 0.3s;
display: flex;
flex-direction: column;
border-radius: 10px;
}

.product-card:hover {
border-color: #3b82f6;
}

/* IMAGE WRAPPER */

.product-img-wrap {

height: 220px;

display: flex;

align-items: center;
justify-content: center;

background: #020617;
}

/* IMAGE */

.product-img {
max-width: 100%;
max-height: 100%;
object-fit: contain;
}

/* PRODUCT INFO */

.product-info {
padding: 12px;
}

/* TITLE + PRICE */

.product-title-row {
display: flex;
justify-content: space-between;
margin-bottom: 5px;
}

.product-price {
color: #3b82f6;
}

/* SUBTEXT */

.product-sub {
font-size: 12px;
color: #94a3b8;
margin-top: 5px;
}

/* BUTTON AREA */

.product-actions {
display: flex;
gap: 10px;
margin-top: 10px;
}

/* CART BUTTON */

.btn-cart {
flex: 1;
padding: 8px;
background: none;
border: 1px solid #1f2937;
color: #94a3b8;
cursor: pointer;
border-radius: 6px;
transition: 0.2s;
}

.btn-cart:hover {
border-color: #3b82f6;
color: #3b82f6;
}

/* BUY BUTTON */

.btn-buy {
flex: 1;
padding: 8px;
background: #3b82f6;
border: none;
color: white;
cursor: pointer;
border-radius: 6px;
transition: 0.2s;
}

.btn-buy:hover {
background: #2563eb;
}

/* ================= FOOTER ================= */

.footer {

background: #020617;

border-top: 1px solid #1f2937;

padding: 30px;

text-align: center;

margin-top: 40px;

color: #94a3b8;
}

/* ================= RESPONSIVE ================= */

@media (max-width: 1000px) {
.products-grid {
grid-template-columns: repeat(2, 1fr);
}
}

@media (max-width: 600px) {
.products-grid {
grid-template-columns: 1fr;
}
}
	
	</style>
</head>
<body>
	<div class="navbar">
		<div class="logo">
			Digital_Bazaar
		</div>
		
		<ul class="nav-links">
			<li><a href="${pageContext.request.contextPath}/dashboard">HOME</a></li>
			<li><a href="${pageContext.request.contextPath}/shop">SHOP</a></li>
			<li><a href="#">CONTACT</a></li>
		</ul>
		
		<div class="nav-icons">
			<div class="icon">
				🛒<span class="cart-count">0</span>
			</div>
			<div class="icon">
				👤
			</div>
		</div>
	</div>
	
	
	
	<!-- ================= HERO ================= -->
	
	<div class="hero">
	
	<!-- VIDEO -->
	
	<video autoplay muted loop>
	
	<source src="<%=request.getContextPath()%>/videos/hero.mp4" 
	type="video/mp4">
	
	</video>
	
	<!-- OVERLAY -->
	
	<div class="hero-overlay"></div>
	
	<!-- CONTENT -->
	
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
	
<div class="section-header" id = "best-sellers">
    <div class="section-title">BEST_SELLERS</div>
</div>

<div class="products-grid" id="best-sellers-grid">

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>
</div>

<div class="section-header">
    <div class="section-title">NEW_ARRIVALS</div>
</div>

<div class="products-grid">

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>

    <div class="product-card">
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
                <button class="btn-cart">ADD TO CART</button>
                <button class="btn-buy">BUY NOW</button>
            </div>
        </div>
    </div>


</div>
	
	
	
	<!-- ================= FOOTER ================= -->
	
	<div class="footer">
	© 2025 Kinetic Terminal — All Rights Reserved
	</div>
	
	<script>
		/* CART COUNTER */
		
		let count=0;
		document.querySelectorAll(".btn-cart,.btn-buy")
		
		.forEach(btn=>{
			btn.onclick=function(){
				count++;
				document.querySelector(".cart-count").textContent=count;
			};
		});
	
	</script>
</body>
</html>