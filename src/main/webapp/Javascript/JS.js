/**
 * 
 */
let cart = JSON.parse(localStorage.getItem('digitalBazaarCart')) || [];

    function saveCart() {
        localStorage.setItem('digitalBazaarCart', JSON.stringify(cart));
        renderCart();
    }

    function addToCartAction(name, price, img) {
        // Check for login if variable exists on page
        if (typeof isLoggedIn !== 'undefined' && !isLoggedIn) {
            alert("Secure Access Required. Please login first.");
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }

        let existingItem = cart.find(item => item.name === name);
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cart.push({ name, price, img, quantity: 1 });
        }
        
        saveCart();
        document.getElementById("cartSidebar").classList.add("active");
    }

    function renderCart() {
        const container = document.getElementById("cartItems");
        const totalEl = document.getElementById("totalPrice");
        const countEls = document.querySelectorAll(".cart-count");

        if (!container) return; 

        container.innerHTML = "";
        let total = 0;
        let count = 0;

        cart.forEach((item, index) => {
            let itemTotal = item.price * item.quantity;
            total += itemTotal;
            count += item.quantity;
            
            container.innerHTML += `
                <div class="cart-item">
                    <img src="${item.img}" alt="product">
                    <div class="cart-item-info">
                        <strong>${item.name}</strong>
                        <p>$${item.price.toFixed(2)} &times; ${item.quantity}</p>
                    </div>
                    <div class="cart-item-actions">
                        <span class="cart-item-total">$${itemTotal.toFixed(2)}</span>
                        <button class="remove-item" onclick="removeFromCart(${index})">Remove</button>
                    </div>
                </div>
            `;
        });

        if(totalEl) totalEl.textContent = total.toFixed(2);
        countEls.forEach(el => el.textContent = count);
    }

    function removeFromCart(index) {
        cart.splice(index, 1);
        saveCart();
    }

    function toggleCart() {
        document.getElementById("cartSidebar").classList.toggle("active");
    }

    function buyNow() {
        if (cart.length === 0) {
            alert("Your cart is empty.");
            return;
        }
        alert("Proceeding to secure checkout portal...");
    }

    // Attach click events for dynamic Shop/Dashboard Buttons
    document.addEventListener("DOMContentLoaded", () => {
        renderCart(); // Render on load
        
        document.querySelectorAll(".btn-cart").forEach(btn => {
            btn.addEventListener("click", function () {
                const product = this.closest(".product-card");
                // Supports both dashboard and shop DOM structures
                const nameNode = product.querySelector("h3") || product.querySelector(".product-title-row div");
                const priceNode = product.querySelector(".price") || product.querySelector(".product-price");
                
                const name = nameNode.textContent.trim();
                const price = parseFloat(priceNode.textContent.replace("$", "").trim());
                const img = product.querySelector("img").src;

                addToCartAction(name, price, img);
            });
        });

        // Attach static Buy Now buttons
        document.querySelectorAll(".btn-buy").forEach(btn => {
            btn.addEventListener("click", buyNow);
        });
    });