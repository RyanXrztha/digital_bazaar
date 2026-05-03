<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.List, com.DigitalBazaar.model.Product" %>
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
	    background: #F1F5F9;
	    color: #0F172A;
	    font-family: 'Inter', Segoe UI, Arial, sans-serif;
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
	
	/* ================= PROFESSIONAL CART SIDEBAR ================= */
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
		    margin-top: 60px;
		    height: 350px;
		    background: #0F172A;
		    display: flex;
		    align-items: center;
		    padding-left: 60px;
            color: white;
		}
		
		.hero-text h1 {
		    font-size: 40px;
		}
		
		.hero-text span {
		    color: #3B82F6;
		}
		
		.hero-text p {
		    color: #94A3B8;
		    margin: 10px 0;
		}
		
		.hero-text button {
		    background: #1E40AF;
		    color: white;
            font-weight: 600;
		    border: none;
            border-radius: 4px;
		    padding: 12px 24px;
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
		    background: #FFFFFF;
		    border: 1px solid #E2E8F0;
		    padding: 15px;
		    border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: border-color 0.2s;
		}
        .product-card:hover {
            border-color: #3B82F6;
        }
		
		.product-img {
		    width: 100%;
		    height: 160px;
            background: #F8FAFC;
            border-radius: 2px;
            margin-bottom: 10px;
		}
		
		.product-img img {
		    width: 100%;
		    height: 100%;
		    object-fit: contain;
            mix-blend-mode: multiply;
		}
		
		.price-cart {
		    display: flex;
		    justify-content: space-between;
		    margin-top: 10px;
		}
		
		/* CONTROL BAR */
		
		.control-bar {
		    margin-top: 0px;
		    padding: 15px 60px;
		    display: flex;
		    justify-content: flex-end;
		    gap: 15px;
		    background: #FFFFFF;
		    border-bottom: 1px solid #E2E8F0;
		}
		
		/* SEARCH BOX */
		
		.search-box input {
		    width: 300px;
		    padding: 10px;
		    background: #F1F5F9;
		    border: 1px solid #E2E8F0;
		    color: #0F172A;
		    border-radius: 4px;
		    outline: none;
		}
		
		/* DROPDOWN */
		
		.filter-box select {
		    padding: 10px;
		    background: #F1F5F9;
		    border: 1px solid #E2E8F0;
		    color: #0F172A;
		    border-radius: 4px;
		}
		
		.search-box input:focus,
		.filter-box select:focus {
		    border-color: #3B82F6;
		}
		
		/* PRODUCT CATEGORY */
		
		.category {
		    font-size: 12px;
		    color: #64748B;
		}
		
		/* PRICE */
		
		.price {
		    margin-top: 5px;
		    color: #0F172A;
		    font-weight: bold;
            font-size: 1.1rem;
		}
		
		/* BUTTONS */
		
		.product-actions {
		    display: flex;
		    gap: 10px;
		    margin-top: 15px;
		}

		/* ================= ADD TO CART BUTTON — PROFESSIONAL ================= */
		.btn-cart {
		    flex: 1.5;
		    padding: 9px 10px;
		    background: linear-gradient(135deg, #1E40AF 0%, #2563EB 100%);
		    color: white;
		    font-weight: 700;
		    font-size: 11px;
		    letter-spacing: 0.6px;
		    text-transform: uppercase;
		    border: none;
		    border-radius: 5px;
		    cursor: pointer;
		    transition: all 0.25s ease;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    gap: 5px;
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
		
		.btn-buy {
		    flex: 1;
		    background: transparent;
		    border: 1px solid #E2E8F0;
		    color: #64748B;
            border-radius: 4px;
		    cursor: pointer;
		    font-size: 11px;
		    font-weight: 600;
		    text-transform: uppercase;
		    letter-spacing: 0.5px;
		    transition: 0.2s;
		}
		
		.btn-buy:hover {
		    border-color: #1E40AF;
		    color: #1E40AF;
		}
</style>
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
	        <div class="cart-empty">
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

	<!-- ================= HERO (unchanged) ================= -->
	<div class="hero">
	    <div class="hero-text">
	        <h1>OVERCLOCK THE <span>FUTURE</span></h1>
	        <p>High performance components</p>
	        <button onclick="document.getElementById('products').scrollIntoView({behavior:'smooth'})">INITIALIZE</button>
	    </div>
	</div>

	<!-- ================= FILTER BAR (unchanged) ================= -->
	<div class="control-bar">
	    <div class="search-box">
	        <input type="text" id="searchInput" placeholder="Search hardware...">
	    </div>
	    <div class="filter-box" id="products">
	        <select id="categoryFilter">
	            <option value="all">All Categories</option>
	            <option value="GPU">GPU</option>
	            <option value="CPU">CPU</option>
	            <option value="RAM">RAM</option>
	            <option value="Storage">Storage</option>
	        </select>
	    </div>
	</div>

	<!-- ================= PRODUCTS — now from DB ================= -->
	<div class="products-container">
	<%
	    List<Product> products = (List<Product>) request.getAttribute("products");
	    if (products != null && !products.isEmpty()) {
	        for (Product p : products) {
	%>
	    <div class="product-card"
	         data-name="<%= p.getName() %>"
	         data-category="<%= p.getCategory() %>"
	         data-price="<%= p.getPrice() %>"
	         data-img="<%= request.getContextPath() %>/images/<%= p.getImage() %>">
	        <div class="product-img">
	            <img src="<%= request.getContextPath() %>/images/<%= p.getImage() %>" alt="<%= p.getName() %>">
	        </div>
	        <h3><%= p.getName() %></h3>
	        <p class="category"><%= p.getCategory() %></p>
	        <div class="price">$<%= String.format("%.0f", p.getPrice()) %></div>
	        <div class="product-actions">
	            <button class="btn-cart" onclick="addToCart(this)">🛒 ADD TO CART</button>
	            <button class="btn-buy" onclick="handleBuyNow(this)">BUY NOW</button>
	        </div>
	    </div>
	<%
	        }
	    } else {
	%>
	    <p style="color:#94a3b8; padding:20px; grid-column:1/-1;">
	        No products found. Please check your database.
	    </p>
	<%
	    }
	%>
	</div>

	<!-- ================= JAVASCRIPT ================= -->
	<script>
    const searchInput   = document.getElementById("searchInput");
    const categoryFilter = document.getElementById("categoryFilter");
    const productCards  = document.querySelectorAll(".product-card");
    const isLoggedIn    = ${isLoggedIn == true ? "true" : "false"};

    /* ================= FILTER (unchanged) ================= */
    function filterProducts() {
        const searchValue   = searchInput.value.toLowerCase();
        const categoryValue = categoryFilter.value;
        productCards.forEach(product => {
            const name     = product.dataset.name.toLowerCase();
            const category = product.dataset.category;
            const matchSearch   = name.includes(searchValue);
            const matchCategory = categoryValue === "all" || category === categoryValue;
            product.style.display = (matchSearch && matchCategory) ? "block" : "none";
        });
    }
    searchInput.addEventListener("input", filterProducts);
    categoryFilter.addEventListener("change", filterProducts);

    /* ================= CART ================= */
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
            container.innerHTML = '<div class="cart-empty"><div class="cart-empty-icon">🛒</div><div>Your cart is empty</div></div>';
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
