<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
		* {
		  	margin: 0;
		    padding: 0;
		    box-sizing: border-box;
		}
		
		/* ================= BODY ================= */
		
		body {
		    background: #0f172a;
		    color: #f0f0f0;
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
		    background: #0f172a;
    		border-bottom: 1px solid #334155;
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    padding: 0 40px;
		    z-index: 1000;
		}
		
		/* LOGO */
		
		.logo {
		    color: #2563eb;
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
		    color: #8a8a8a;
		    font-size: 14px;
		}
		
		.nav-links a:hover {
		    color: white;
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
		    color: #8a8a8a;
		    position: relative;
		}
		
		.icon:hover {
		    color: white;
		}
		
		/* CART COUNT */
		
		.cart-count {
		    position: absolute;
		    top: -6px;
		    right: -8px;
		    background: #2563eb;
		    color: black;
		    font-size: 10px;
		    padding: 2px 6px;
		    border-radius: 50%;
		}
		
		/* CART SIDEBAR */
/* ================= PROFESSIONAL CART SIDEBAR ================= */
.cart-sidebar {
    position: fixed;
    top: 60px;
    right: -400px;
    width: 380px;
    height: calc(100% - 60px);
    background: #111827; /* Slightly darker for depth */
    border-left: 1px solid #334155;
    display: flex;
    flex-direction: column;
    transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 999;
    box-shadow: -10px 0 30px rgba(0,0,0,0.5);
}

.cart-sidebar.active {
    right: 0;
}

/* HEADER SECTION */
.cart-header {
    padding: 24px 20px;
    border-bottom: 1px solid #334155;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.cart-header h2 {
    font-size: 1.25rem;
    font-weight: 600;
    color: #fff;
    letter-spacing: 0.5px;
}

.close-cart {
    cursor: pointer;
    font-size: 24px;
    color: #94a3b8;
    transition: 0.2s;
}

.close-cart:hover {
    color: #ef4444;
}

/* ITEMS CONTAINER */
#cartItems {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
}

/* CART ITEM */
.cart-item {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 15px 0;
    border-bottom: 1px solid #1e293b;
}

.cart-item img {
    width: 70px;
    height: 70px;
    background: #1e293b;
    border-radius: 8px;
    padding: 5px;
    object-fit: contain;
}

.cart-item-info {
    flex: 1;
}

.cart-item-info strong {
    display: block;
    font-size: 14px;
    margin-bottom: 4px;
    color: #f8fafc;
}

.cart-item-info p {
    color: #2563eb;
    font-weight: bold;
    font-size: 14px;
}

.remove-item {
    background: transparent;
    border: none;
    color: #64748b;
    cursor: pointer;
    font-size: 12px;
    text-decoration: underline;
}

.remove-item:hover {
    color: #ef4444;
}

/* FOOTER SECTION */
.cart-footer {
    padding: 24px 20px;
    background: #1e293b;
    border-top: 1px solid #334155;
}

.total-container {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
}

.total-container h3 {
    font-size: 14px;
    color: #94a3b8;
}

.total-amount {
    font-size: 18px;
    color: #fff;
    font-weight: bold;
}

.checkout-btn {
    width: 100%;
    padding: 14px;
    background: #2563eb;
    color: white;
    font-weight: 600;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.3s;
}

.checkout-btn:hover {
    background: #1d4ed8;
    transform: translateY(-2px);
}

/* CART ITEM */
.cart-item {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
    border-bottom: 1px solid #334155;
    padding-bottom: 10px;
}

.cart-item img {
    width: 60px;
    height: 60px;
    object-fit: contain;
}

.cart-footer {
    margin-top: 20px;
}

.checkout-btn {
    width: 100%;
    padding: 10px;
    background: #2563eb;
    border: none;
    cursor: pointer;
}

/* ================= HERO ================= */
.hero {
    margin-top: 60px;
    height: 350px;
    background: black; /* TEMP BLACK BACKGROUND */
    display: flex;
    align-items: center;
    padding-left: 60px;
}

.hero-text h1 {
    font-size: 40px;
}

.hero-text span {
    color: #2563eb;
}

.hero-text p {
    color: #aaa;
    margin: 10px 0;
}

.hero-text button {
    background: #2563eb;
    border: none;
    padding: 10px 20px;
    cursor: pointer;
}

/* ================= PRODUCTS ================= */
.products-container {
    padding: 40px;
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 20px;
}

.product-card {
    background: #1e293b;
    border: 1px solid #334155;
    padding: 15px;
    border-radius: 10px;
}

.product-img {
    width: 100%;
    height: 160px;
}

.product-img img {
    width: 100%;
    height: 100%;
    object-fit: contain; /* FIT IMAGE */
}

.price-cart {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}

.price-cart button {
    background: #2563eb;
    border: none;
    padding: 5px 10px;
}

/* FILTER BAR */
/* CONTROL BAR */
.control-bar {
    margin-top: 0px;
    padding: 10px 60px;
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    background: #1e293b;
    border-bottom: 1px solid #334155;
}

/* CART SIDEBAR */
.cart-sidebar {
    position: fixed;
    top: 60px;
    right: -400px;
    width: 350px;
    height: calc(100% - 60px);
    background: #1e293b;
    border-left: 1px solid #334155;
    padding: 20px;
    transition: 0.3s;
    overflow-y: auto;
    z-index: 999;
}

.cart-sidebar.active {
    right: 0;
}

/* CART ITEM */
.cart-item {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
    border-bottom: 1px solid #334155;
    padding-bottom: 10px;
}

.cart-item img {
    width: 60px;
    height: 60px;
    object-fit: contain;
}

.cart-footer {
    margin-top: 20px;
}

.checkout-btn {
    width: 100%;
    padding: 10px;
    background: #2563eb;
    border: none;
    cursor: pointer;
}

/* SEARCH BOX */
.search-box input {
    width: 300px;
    padding: 10px;
    background: #0f172a;
    border: 1px solid #334155;
    color: white;
    border-radius: 6px;
    outline: none;
}

/* DROPDOWN */
.filter-box select {
    padding: 10px;
    background: #111;
    border: 1px solid #333;
    color: white;
    border-radius: 6px;
}

/* HOVER EFFECT */
.search-box input:focus,
.filter-box select:focus {
    border-color: #00e5ff;
    box-shadow: 0 0 8px rgba(0,229,255,0.3);
}

/* PRODUCT CATEGORY */
.category {
    font-size: 12px;
    color: #888;
}

/* PRICE */
.price {
    margin-top: 5px;
    color: #00e5ff;
    font-weight: bold;
}

/* BUTTONS */
.product-actions {
    display: flex;
    gap: 10px;
    margin-top: 10px;
}

.btn-cart {
    flex: 1;
    background: #2563eb;
    border: none;
    padding: 6px;
    cursor: pointer;
}

.btn-buy {
    flex: 1;
    background: transparent;
    border: 1px solid #2563eb;
    color: #2563eb;
    cursor: pointer;
}

.btn-cart:hover,
.btn-buy:hover {
    opacity: 0.8;
}

.btn-cart:hover,
.hero-text button:hover {
    background: #1d4ed8;
}

.btn-buy:hover {
    background: #2563eb;
    color: white;
}

</style>
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
			<div class="icon" onclick="toggleCart()">
			    🛒<span class="cart-count">0</span>
			</div>
			<div class="icon">
				👤
			</div>
		</div>
	</div>
	

	<!-- CART SIDEBAR -->
	<div class="cart-sidebar" id="cartSidebar">
	    <h2>Your Cart</h2>
	    
	    <div id="cartItems"></div>
	
	    <div class="cart-footer">
	        <h3>Total: $<span id="totalPrice">0</span></h3>
	        <button class="checkout-btn">Checkout</button>
	    </div>
	</div>
	
	<!-- ================= HERO ================= -->
	<div class="hero">
	    <div class="hero-text">
	        <h1>OVERCLOCK THE <span>FUTURE</span></h1>
	        <p>High performance components</p>
	        <button onclick="document.getElementById('products').scrollIntoView({behavior:'smooth'})">INITIALIZE</button>
	    </div>
	</div>
	
	<div class="control-bar">

	    <div class="search-box">
	        <input type="text" id="searchInput" placeholder="Search hardware...">
	    </div>
	
	    <div class="filter-box"  id="products">
	        <select id="categoryFilter">
	            <option value="all">All Categories</option>
	            <option value="GPU">GPU</option>
	            <option value="CPU">CPU</option>
	            <option value="RAM">RAM</option>
	            <option value="Storage">Storage</option>
	        </select>
	    </div>
	
	</div>
	
	<!-- ================= PRODUCTS ================= -->
	<div class="products-container">
	
	    <div class="product-card" data-name="RTX 4090" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p1.jpg"></div>
    <h3>RTX 4090</h3>
    <p class="category">GPU</p>
    <div class="price">$1899</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Ryzen 9 7950X" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p2.jpg"></div>
    <h3>Ryzen 9 7950X</h3>
    <p class="category">CPU</p>
    <div class="price">$599</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Corsair 32GB DDR5" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p3.jpg"></div>
    <h3>Corsair 32GB DDR5</h3>
    <p class="category">RAM</p>
    <div class="price">$299</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Samsung 980 Pro 1TB" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p4.jpg"></div>
    <h3>Samsung 980 Pro</h3>
    <p class="category">Storage</p>
    <div class="price">$149</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 4080" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p5.jpg"></div>
    <h3>RTX 4080</h3>
    <p class="category">GPU</p>
    <div class="price">$1299</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Intel i9 13900K" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p6.jpg"></div>
    <h3>Intel i9 13900K</h3>
    <p class="category">CPU</p>
    <div class="price">$649</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Kingston 16GB DDR5" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p7.jpg"></div>
    <h3>Kingston 16GB DDR5</h3>
    <p class="category">RAM</p>
    <div class="price">$129</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="WD Black 2TB HDD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p8.jpg"></div>
    <h3>WD Black 2TB HDD</h3>
    <p class="category">Storage</p>
    <div class="price">$89</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 4070 Ti" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p9.jpg"></div>
    <h3>RTX 4070 Ti</h3>
    <p class="category">GPU</p>
    <div class="price">$899</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Ryzen 7 7700X" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p10.jpg"></div>
    <h3>Ryzen 7 7700X</h3>
    <p class="category">CPU</p>
    <div class="price">$399</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="G.Skill 32GB Trident" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p11.jpg"></div>
    <h3>G.Skill 32GB Trident</h3>
    <p class="category">RAM</p>
    <div class="price">$279</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Crucial 1TB SSD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p12.jpg"></div>
    <h3>Crucial 1TB SSD</h3>
    <p class="category">Storage</p>
    <div class="price">$119</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 4060" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p13.jpg"></div>
    <h3>RTX 4060</h3>
    <p class="category">GPU</p>
    <div class="price">$399</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Intel i7 13700K" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p14.jpg"></div>
    <h3>Intel i7 13700K</h3>
    <p class="category">CPU</p>
    <div class="price">$419</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Corsair 16GB DDR4" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p15.jpg"></div>
    <h3>Corsair 16GB DDR4</h3>
    <p class="category">RAM</p>
    <div class="price">$89</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Seagate 4TB HDD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p16.jpg"></div>
    <h3>Seagate 4TB HDD</h3>
    <p class="category">Storage</p>
    <div class="price">$109</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RX 7900 XT" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p17.jpg"></div>
    <h3>RX 7900 XT</h3>
    <p class="category">GPU</p>
    <div class="price">$999</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Ryzen 5 7600X" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p18.jpg"></div>
    <h3>Ryzen 5 7600X</h3>
    <p class="category">CPU</p>
    <div class="price">$249</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="ADATA 16GB DDR5" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p19.jpg"></div>
    <h3>ADATA 16GB DDR5</h3>
    <p class="category">RAM</p>
    <div class="price">$119</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Samsung 2TB SSD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p20.jpg"></div>
    <h3>Samsung 2TB SSD</h3>
    <p class="category">Storage</p>
    <div class="price">$199</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 3090" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p21.jpg"></div>
    <h3>RTX 3090</h3>
    <p class="category">GPU</p>
    <div class="price">$1199</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Intel i5 13400" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p22.jpg"></div>
    <h3>Intel i5 13400</h3>
    <p class="category">CPU</p>
    <div class="price">$199</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Kingston 32GB RAM" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p23.jpg"></div>
    <h3>Kingston 32GB RAM</h3>
    <p class="category">RAM</p>
    <div class="price">$149</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="WD 1TB SSD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p24.jpg"></div>
    <h3>WD 1TB SSD</h3>
    <p class="category">Storage</p>
    <div class="price">$99</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 4070" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p25.jpg"></div>
    <h3>RTX 4070</h3>
    <p class="category">GPU</p>
    <div class="price">$799</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Ryzen 3 4100" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p26.jpg"></div>
    <h3>Ryzen 3 4100</h3>
    <p class="category">CPU</p>
    <div class="price">$99</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Corsair 8GB DDR4" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p27.jpg"></div>
    <h3>Corsair 8GB DDR4</h3>
    <p class="category">RAM</p>
    <div class="price">$49</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Seagate 1TB HDD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p28.jpg"></div>
    <h3>Seagate 1TB HDD</h3>
    <p class="category">Storage</p>
    <div class="price">$59</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RX 6800 XT" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p29.jpg"></div>
    <h3>RX 6800 XT</h3>
    <p class="category">GPU</p>
    <div class="price">$699</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Intel i3 12100" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p30.jpg"></div>
    <h3>Intel i3 12100</h3>
    <p class="category">CPU</p>
    <div class="price">$129</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="TeamGroup 16GB RAM" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p31.jpg"></div>
    <h3>TeamGroup 16GB RAM</h3>
    <p class="category">RAM</p>
    <div class="price">$79</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Crucial 500GB SSD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p32.jpg"></div>
    <h3>Crucial 500GB SSD</h3>
    <p class="category">Storage</p>
    <div class="price">$49</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 3080" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p33.jpg"></div>
    <h3>RTX 3080</h3>
    <p class="category">GPU</p>
    <div class="price">$799</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Ryzen 7 5800X" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p34.jpg"></div>
    <h3>Ryzen 7 5800X</h3>
    <p class="category">CPU</p>
    <div class="price">$299</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="HyperX 8GB RAM" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p35.jpg"></div>
    <h3>HyperX 8GB RAM</h3>
    <p class="category">RAM</p>
    <div class="price">$39</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Samsung 4TB HDD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p36.jpg"></div>
    <h3>Samsung 4TB HDD</h3>
    <p class="category">Storage</p>
    <div class="price">$139</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="RTX 4060 Ti" data-category="GPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p37.jpg"></div>
    <h3>RTX 4060 Ti</h3>
    <p class="category">GPU</p>
    <div class="price">$499</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="Intel i7 12700K" data-category="CPU">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p38.jpg"></div>
    <h3>Intel i7 12700K</h3>
    <p class="category">CPU</p>
    <div class="price">$329</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="ADATA 32GB DDR5" data-category="RAM">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p39.jpg"></div>
    <h3>ADATA 32GB DDR5</h3>
    <p class="category">RAM</p>
    <div class="price">$159</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>

<div class="product-card" data-name="WD 2TB SSD" data-category="Storage">
    <div class="product-img"><img src="<%=request.getContextPath()%>/images/p40.jpg"></div>
    <h3>WD 2TB SSD</h3>
    <p class="category">Storage</p>
    <div class="price">$179</div>
    
    <div class="product-actions">
    <button class="btn-cart">ADD TO CART</button>
    <button class="btn-buy">BUY NOW</button>
</div>
</div>


	</div>
	
	<script>
    const searchInput = document.getElementById("searchInput");
    const categoryFilter = document.getElementById("categoryFilter");
    const products = document.querySelectorAll(".product-card");

    const isLoggedIn = ${isLoggedIn == true ? "true" : "false"};

    /* ================= FILTER ================= */
    function filterProducts() {
        const searchValue = searchInput.value.toLowerCase();
        const categoryValue = categoryFilter.value;

        products.forEach(product => {
            const name = product.dataset.name.toLowerCase();
            const category = product.dataset.category;

            const matchSearch = name.includes(searchValue);
            const matchCategory = categoryValue === "all" || category === categoryValue;

            if (matchSearch && matchCategory) {
                product.style.display = "block";
            } else {
                product.style.display = "none";
            }
        });
    }

    searchInput.addEventListener("input", filterProducts);
    categoryFilter.addEventListener("change", filterProducts);

    /* ================= CART ================= */
    let cart = [];
let count = 0;

const cartItemsContainer = document.getElementById("cartItems");
const totalPriceElement = document.getElementById("totalPrice");
const cartSidebar = document.getElementById("cartSidebar");

/* TOGGLE CART */
function toggleCart() {
    cartSidebar.classList.toggle("active");
}

/* ADD TO CART */
document.querySelectorAll(".btn-cart").forEach(btn => {
    btn.addEventListener("click", function () {

        if (!isLoggedIn) {
            alert("Please login first!");
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }

        const product = this.closest(".product-card");

        const name = product.querySelector("h3").textContent.trim();
        const price = parseFloat(product.querySelector(".price").textContent.replace("$", "").trim());
        const img = product.querySelector("img").src;

        console.log(name, price, img); // DEBUG

        cart.push({ name, price, img });

        count++;
        document.querySelector(".cart-count").textContent = count;

        renderCart();
    });
});

function renderCart() {
    cartItemsContainer.innerHTML = "";
    let total = 0;

    cart.forEach(item => {
        total += item.price;

        const div = document.createElement("div");
        div.className = "cart-item";

        div.innerHTML = `
            <img src="\${item.img}">
            <div>
                <p><strong>\${item.name}</strong></p>
                <p>\${item.price}</p>
            </div>
        `;

        cartItemsContainer.appendChild(div);
    });

    totalPriceElement.textContent = total.toFixed(2);
}

    // BUY NOW
    document.querySelectorAll(".btn-buy").forEach(btn => {
        btn.addEventListener("click", function () {

            if (!isLoggedIn) {
                alert("Please login first!");
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }

            alert("Proceeding to checkout...");
        });
    });
</script>

</body>
</html>