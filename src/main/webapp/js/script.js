let cart = []; // local mirror of DB cart

function formatNPR(amount) {
        var n = Math.round(amount);
        var s = String(n);
        if (s.length <= 3) return s;
        var last3 = s.slice(-3);
        var rest  = s.slice(0, -3);
        var result = '';
        while (rest.length > 2) {
            result = ',' + rest.slice(-2) + result;
            rest = rest.slice(0, -2);
        }
        return rest + result + ',' + last3;
    }

    /* ── Toggle cart sidebar ── */
    function toggleCart() {
        document.getElementById('cartSidebar').classList.toggle('active');
    }

    /* ── Load cart from DB on page load ── */
    function loadCart() {
        fetch(CTX + '/cart/items')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data.loggedIn) { cart = []; renderCart(); return; }
                cart = data.items.map(function(item) {
                    return {
                        orderId:   item.id,
                        productId: item.productId,
                        name:      item.name,
                        category:  item.category,
                        price:     item.totalPrice,   // total for this row
                        unitPrice: item.price,        // per-unit price
                        qty:       item.quantity,
                        img:       CTX + '/images/' + item.image
                    };
                });
                updateCartCount();
                renderCart();
            })
            .catch(function(e) { console.error('Cart load error', e); });
    }

    /* ── Add to cart ── */
    function addToCart(btn) {
    if (!isLoggedIn) {
		showLoginModal();
		return;
    }
    var card      = btn.closest('.product-card');
    var productId = card.dataset.productId;
    var original  = '🛒 Add to Cart';

    fetch(CTX + '/cart/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + productId + '&quantity=1'
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            btn.innerHTML = '✔ Added';
            btn.classList.add('added');
            setTimeout(function() {
                btn.innerHTML = original;
                btn.classList.remove('added');
            }, 1500);
            loadCart();
            document.getElementById('cartSidebar').classList.add('active');
        } else {
            var msg = data.message || 'Could not add to cart.';
            btn.innerHTML = '⚠ ' + msg;
            btn.style.background = '#F59E0B';
            btn.style.fontSize = '10px';
            setTimeout(function() {
                btn.innerHTML = original;
                btn.style.background = '';
                btn.style.fontSize = '';
            }, 2500);
        }
    })
    .catch(function(e) { console.error('Add to cart error', e); });
}

    /* ── Remove item ── */
    function removeItem(orderId) {
    fetch(CTX + '/cart/remove', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'orderId=' + orderId
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) loadCart();
    })
    .catch(function(e) { console.error('Remove error', e); });
}

    /* ── Update cart count badge ── */
    function updateCartCount() {
        var countEl = document.querySelector('.cart-count');
        if (countEl) countEl.textContent = cart.length;
    }

    /* ── Render cart sidebar ── */
    function renderCart() {
        var container = document.getElementById('cartItems');
        updateCartCount();

        if (cart.length === 0) {
            container.innerHTML = '<div class="cart-empty"><div class="cart-empty-icon">🛒</div><div>Your cart is empty</div></div>';
            document.getElementById('totalPrice').textContent = '0';
            return;
        }

        var html = '', total = 0;
        cart.forEach(function(item) {
            total += item.price || 0;
            html += '<div class="cart-item">'
                + '<img src="' + item.img + '" alt="' + item.name + '">'
                + '<div class="cart-item-info">'
                + '<strong>' + item.name + '</strong>'
                + '<div class="cart-item-meta">'
                + '<span class="cart-item-qty">Qty: ' + item.qty + '</span>'
                + '<span class="cart-item-price">₨ ' + formatNPR(item.price) + '</span>'
                + '</div></div>'
                + '<button class="remove-item" onclick="removeItem(' + item.orderId + ')">✕</button>'
                + '</div>';
        });
        container.innerHTML = html;
        document.getElementById('totalPrice').textContent = formatNPR(total);
    }

    /* ── Buy Now (still direct checkout, no DB cart needed) ── */
    function handleBuyNow(btn) {
        if (!isLoggedIn) {
			showLoginModal();
			return;
        }
        var card  = btn.closest('.product-card');
        var name  = card.dataset.name;
        var price = parseFloat(card.dataset.price);

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

    /* ── Checkout — submit all cart items then mark as pending ── */
	function handleCheckout() {
	    if (cart.length === 0) {
	        showCartEmptyModal();
	        return;
	    }

	    var form = document.createElement('form');
	    form.method = 'POST';
	    form.action = CTX + '/checkout';

	    cart.forEach(function(item) {
	        var n = document.createElement('input');
	        n.type = 'hidden'; n.name = 'productName'; n.value = item.name;
	        form.appendChild(n);

	        var q = document.createElement('input');
	        q.type = 'hidden'; q.name = 'quantity'; q.value = item.qty;
	        form.appendChild(q);

	        var tp = document.createElement('input');
	        tp.type = 'hidden'; tp.name = 'totalPrice'; tp.value = item.price.toFixed(2);
	        form.appendChild(tp);
	    });

	    document.body.appendChild(form);
	    form.submit();
	}

	function showCartEmptyModal() {
	    document.getElementById('cartEmptyModal').style.display = 'flex';
	}

	function closeCartEmptyModal() {
	    document.getElementById('cartEmptyModal').style.display = 'none';
	}

    /* ── Init ── */
    loadCart();
    
    /* ---- PROFILE DROPDOWN ---- */
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
	
	function showLoginModal() {
	  var modal = document.getElementById('loginModal');
	  // Fix hrefs using CTX so they work on all pages
	  document.getElementById('modalLoginBtn').href = CTX + '/login';
	  document.getElementById('modalRegisterBtn').href = CTX + '/register';
	  modal.style.display = 'flex';
	}

	function closeLoginModal() {
	  document.getElementById('loginModal').style.display = 'none';
	}

	// Close when clicking the dark overlay backdrop
	document.addEventListener('click', function(e) {
	  var modal = document.getElementById('loginModal');
	  if (e.target === modal) closeLoginModal();
	});