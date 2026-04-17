<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<style>
        /* ---------- BASE LAYOUT ---------- */
        body { 
            margin: 0; 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background: #0f172a; 
            color: #e5e7eb; 
            display: flex; 
        }

        /* ---------- SIDEBAR ---------- */
        .sidebar { 
            width: 240px; 
            height: 100vh; 
            position: fixed; 
            background: #020617; 
            border-right: 1px solid #1f2937; 
            z-index: 100; 
        }
        .logo { padding: 30px 20px; border-bottom: 1px solid #1f2937; }
        .logo h2 { margin: 0; font-size: 18px; color: #3b82f6; }
        .menu { list-style: none; padding: 20px 10px; }
        .menu li { 
            padding: 12px 15px; 
            color: #94a3b8; 
            cursor: pointer; 
            border-radius: 8px; 
            transition: 0.2s; 
            margin-bottom: 5px; 
        }
        .menu li.active, .menu li:hover { background: #1e293b; color: white; }

        /* ---------- MAIN CONTENT ---------- */
        .main { 
            margin-left: 240px; 
            padding: 40px; 
            width: 100%; 
            box-sizing: border-box; 
        }
        .topbar { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
        }
        .badge { 
            background: #1e3a8a; 
            color: #93c5fd; 
            padding: 4px 10px; 
            border-radius: 6px; 
            font-size: 11px; 
            font-weight: bold; 
        }
        .logout { 
            background: transparent; 
            border: 1px solid #ef4444; 
            color: #ef4444; 
            padding: 8px 16px; 
            border-radius: 6px; 
            cursor: pointer; 
            transition: 0.2s; 
        }
        .logout:hover { background: #ef4444; color: white; }

        /* ---------- STATS CARDS ---------- */
        .stats { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        .card { 
            background: #111827; 
            padding: 24px; 
            border-radius: 12px; 
            border: 1px solid #1e293b; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: center; 
            text-align: center; 
        }
        .card h3 { margin: 10px 0; font-size: 32px; }

        /* ---------- CONTROL BAR (SEARCH & FILTER) ---------- */
        .control-bar {
            display: flex;
            justify-content: flex-end;
            background: #111827;
            padding: 15px 20px;
            border-radius: 12px 12px 0 0;
            border: 1px solid #1f2937;
            border-bottom: none;
        }
        .controls-wrapper {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .search-box input {
            width: 250px;
            padding: 10px 15px;
            background: #0f172a;
            border: 1px solid #334155;
            color: white;
            border-radius: 8px;
            outline: none;
        }
        .filter-box select {
            padding: 10px 15px;
            background: #0f172a;
            border: 1px solid #334155;
            color: white;
            border-radius: 8px;
            cursor: pointer;
        }

        /* ---------- TABLE SECTION ---------- */
        .container { 
            background: #111827; 
            border-radius: 0 0 12px 12px; 
            border: 1px solid #1f2937; 
            overflow: hidden; 
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px 20px; vertical-align: middle; border-top: 1px solid #1e293b; }
        
        th { 
            color: #94a3b8; 
            font-size: 11px; 
            text-transform: uppercase; 
            letter-spacing: 1px; 
            background: rgba(15, 23, 42, 0.5); 
            text-align: left;
            border-top: none;
        }

        th:nth-child(2), td:nth-child(2) { 
		    text-align: center; 
		    width: 80px; 
		}

        .img-box { 
            width: 48px; 
            height: 48px; 
            background: #1e293b; 
            border-radius: 8px; 
            overflow: hidden; 
            border: 1px solid #334155;
            display: inline-block; /* Essential for text-align center to work */
        }
        .img-box img { width: 100%; height: 100%; object-fit: cover; }

        .product-title { font-weight: 600; color: #f8fafc; font-size: 14px; }
        .category-tag { background: #1f2937; padding: 4px 10px; border-radius: 6px; font-size: 12px; color: #cbd5e1; }

        .edit-btn { background: #3b82f6; border: none; padding: 8px 14px; border-radius: 6px; color: white; cursor: pointer; font-weight: 500; }
        .delete-btn { background: transparent; border: 1px solid #ef4444; color: #ef4444; padding: 8px 14px; border-radius: 6px; cursor: pointer; margin-left: 5px; }
        .delete-btn:hover { background: #ef4444; color: white; }

        /* ---------- MODALS ---------- */
        .modal { 
            display: none; 
            position: fixed; 
            top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(2, 6, 23, 0.85); 
            z-index: 1000; 
            backdrop-filter: blur(4px); 
        }
        .modal-content { 
            background: #111827; 
            margin: 5% auto; 
            padding: 30px; 
            width: 400px; 
            border-radius: 16px; 
            border: 1px solid #334155; 
        }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-size: 11px; color: #94a3b8; margin-bottom: 5px; text-transform: uppercase; }
        .modal input { 
            width: 100%; padding: 12px; 
            background: #0f172a; 
            border: 1px solid #334155; 
            border-radius: 8px; color: white; 
            box-sizing: border-box; 
        }
        .modal-footer { display: flex; gap: 10px; margin-top: 25px; }
        .btn-save { flex: 1; background: #3b82f6; border: none; padding: 12px; border-radius: 8px; color: white; cursor: pointer; font-weight: bold; }
        .btn-close { background: #334155; border: none; padding: 12px; border-radius: 8px; color: white; cursor: pointer; }
    </style>
<body>
	<div class="sidebar">
        <div class="logo">
            <h2>DigitalBazaar</h2>
            <small>ADMIN PANEL</small>
        </div>
        <ul class="menu">
            <li class="active">Inventory</li>
            <li>Orders</li>
            <li>Customers</li>
        </ul>
    </div>

    <div class="main">
        <div class="topbar">
            <h2>Inventory Control <span class="badge">LIVE SYNC</span></h2>
            <button class="logout">Logout Session</button>
        </div>

        <div class="stats">
            <div class="card"><p>Total Items</p><h3>48</h3></div>
            <div class="card"><p>Low Stock</p><h3 style="color:#fbbf24">08</h3></div>
            <div class="card">
                <p>Quick Actions</p>
                <div style="margin-top:10px;">
                    <button class="edit-btn" onclick="openAdd()">+ Add New Product</button>
                </div>
            </div>
        </div>

        <div class="control-bar">
            <div class="controls-wrapper">
                <div class="search-box">
                    <input type="text" id="adminSearch" placeholder="Search product name..." onkeyup="filterInventory()">
                </div>
                <div class="filter-box">
                    <select id="adminCategoryFilter" onchange="filterInventory()">
                        <option value="all">All Categories</option>
                        <option value="Peripherals">Peripherals</option>
                        <option value="GPU">GPU</option>
                        <option value="CPU">CPU</option>
                        <option value="RAM">RAM</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="container">
            <table id="inventoryTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Stock</th>
                        <th>Price</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#001</td>
                        <td>
                            <div class="img-box">
                                <img src="images/keyboard.jpg" alt="product">
                            </div>
                        </td>
                        <td><span class="product-title">ProStream Keyboard X</span></td>
                        <td><span class="category-tag">Peripherals</span></td>
                        <td>42</td>
                        <td>$120.00</td>
                        <td>
                            <button class="edit-btn" onclick="openEdit('#001', 'ProStream Keyboard X', 'Peripherals', '42', '120.00', 'keyboard.jpg')">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    </tr>
                    <tr>
                        <td>#002</td>
                        <td>
                            <div class="img-box">
                                <img src="images/rtx4090.jpg" alt="product">
                            </div>
                        </td>
                        <td><span class="product-title">Nvidia RTX 4090</span></td>
                        <td><span class="category-tag">GPU</span></td>
                        <td>5</td>
                        <td>$1599.00</td>
                        <td>
                            <button class="edit-btn" onclick="openEdit('#002', 'Nvidia RTX 4090', 'GPU', '5', '1599.00', 'rtx4090.jpg')">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="productModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle">Product Details</h3>
            <div class="form-group">
                <label>Name</label>
                <input id="prodName" type="text">
            </div>
            <div class="form-group">
                <label>Category</label>
                <input id="prodCategory" type="text">
            </div>
            <div style="display:flex; gap:10px">
                <div class="form-group" style="flex:1">
                    <label>Stock</label>
                    <input id="prodStock" type="number">
                </div>
                <div class="form-group" style="flex:1">
                    <label>Price</label>
                    <input id="prodPrice" type="text">
                </div>
            </div>
            <div class="form-group">
                <label>Image Filename</label>
                <input id="prodImage" type="text">
            </div>
            <div class="modal-footer">
                <button class="btn-close" onclick="closeModal()">Cancel</button>
                <button class="btn-save" onclick="saveProduct()">Save Changes</button>
            </div>
        </div>
    </div>

    <script>
        const modal = document.getElementById("productModal");

        // SEARCH & FILTER LOGIC
        function filterInventory() {
            const searchValue = document.getElementById("adminSearch").value.toLowerCase();
            const categoryValue = document.getElementById("adminCategoryFilter").value.toLowerCase();
            const table = document.getElementById("inventoryTable");
            const rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            for (let i = 0; i < rows.length; i++) {
                const productName = rows[i].getElementsByTagName("td")[2].textContent.toLowerCase();
                const category = rows[i].getElementsByTagName("td")[3].textContent.toLowerCase();

                const matchesSearch = productName.includes(searchValue);
                const matchesCategory = (categoryValue === "all" || category.includes(categoryValue));

                rows[i].style.display = (matchesSearch && matchesCategory) ? "" : "none";
            }
        }

        // MODAL LOGIC
        function openEdit(id, name, cat, stock, price, img) {
            document.getElementById("modalTitle").innerText = "Edit Product";
            document.getElementById("prodName").value = name;
            document.getElementById("prodCategory").value = cat;
            document.getElementById("prodStock").value = stock;
            document.getElementById("prodPrice").value = price;
            document.getElementById("prodImage").value = img;
            modal.style.display = "block";
        }

        function openAdd() {
            document.getElementById("modalTitle").innerText = "Add New Product";
            document.getElementById("prodName").value = "";
            document.getElementById("prodCategory").value = "";
            document.getElementById("prodStock").value = "";
            document.getElementById("prodPrice").value = "";
            document.getElementById("prodImage").value = "";
            modal.style.display = "block";
        }

        function closeModal() { modal.style.display = "none"; }
        function saveProduct() { alert("Sending data to database..."); closeModal(); }
        
        window.onclick = function(event) { 
            if (event.target == modal) { closeModal(); } 
        }
    </script>
</body>
</html>