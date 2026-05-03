<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.List, com.DigitalBazaar.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Inventory Control – DigitalBazaar</title>
<style>
    /* ---------- BASE LAYOUT ---------- */
    *, ::before, ::after { 
        margin: 0; 
        padding: 0; 
        box-sizing: border-box; 
    }

    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background-color: #f8fafc;
        color: #0f172a;
        display: flex; 
        height: 100vh;
        overflow: hidden;
    }

    /* ---------- SIDEBAR ---------- */
    .sidebar { 
        width: 260px; 
        height: 100vh; 
        position: fixed; 
        background-color: #0f172a; 
        color: #ffffff;
        display: flex;
        flex-direction: column;
        z-index: 100; 
        padding: 24px 20px;
    }
    
    .logo { 
        margin-bottom: 36px;
    }
    
    .logo h2 { 
        font-size: 18px; 
        font-weight: 700;
        letter-spacing: -0.02em;
        color: #ffffff;
    }
    
    .logo small {
        color: #64748b;
        font-size: 11px;
        letter-spacing: 0.05em;
        font-weight: 600;
        text-transform: uppercase;
        display: block;
        margin-top: 4px;
    }

    .menu { 
        list-style: none; 
        display: flex;
        flex-direction: column;
        gap: 8px;
    }
    
    .menu li { 
        padding: 12px 16px; 
        border-radius: 8px; 
        cursor: pointer; 
        font-size: 14px; 
        font-weight: 500; 
        color: #94a3b8; 
        transition: all 0.2s ease;
    }
    
    .menu li:hover { background-color: #1e293b; color: #ffffff; }
    .menu li.active { background-color: #2563eb; color: #ffffff; }

    /* ---------- MAIN CONTENT ---------- */
    .main { 
        margin-left: 260px; 
        padding: 32px; 
        width: calc(100% - 260px); 
        height: 100vh;
        overflow-y: auto;
        box-sizing: border-box; 
    }

    .main-inner {
        max-width: 1400px;
        margin: 0 auto;
    }

    .topbar { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-bottom: 32px; 
    }

    .topbar h2 {
        font-size: 24px;
        font-weight: 700;
        letter-spacing: -0.02em;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .badge { 
        background: #eff6ff; 
        color: #2563eb; 
        padding: 4px 10px; 
        border-radius: 6px; 
        font-size: 11px; 
        font-weight: 700;
        letter-spacing: 0.05em; 
    }

    .logout { 
        background: #ffffff; 
        border: 1px solid #e2e8f0; 
        color: #64748b; 
        padding: 8px 16px; 
        border-radius: 6px; 
        font-size: 13px;
        font-weight: 500;
        cursor: pointer; 
        transition: 0.2s; 
    }
    .logout:hover { 
        border-color: #ef4444; 
        color: #ef4444; 
        background: #fef2f2;
    }

    /* ---------- STATS CARDS ---------- */
    .stats { 
        display: grid; 
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
        gap: 20px; 
        margin-bottom: 24px; 
    }
    .card { 
        background: #ffffff; 
        padding: 24px; 
        border-radius: 12px; 
        border: 1px solid #e2e8f0; 
        box-shadow: 0 1px 3px 0 rgba(15, 23, 42, 0.05);
        display: flex; 
        flex-direction: column; 
        justify-content: center; 
    }
    .card p { 
        font-size: 11px; 
        font-weight: 600; 
        text-transform: uppercase;
        letter-spacing: 0.05em; 
        color: #64748b; 
        margin-bottom: 8px;
    }
    .card h3 { 
        font-size: 26px; 
        font-weight: 700; 
        color: #0f172a; 
        letter-spacing: -0.02em;
    }

    /* ---------- CONTROL BAR (SEARCH & FILTER) ---------- */
    .control-bar {
        display: flex;
        justify-content: space-between;
        background: #ffffff;
        padding: 18px 24px;
        border-radius: 12px 12px 0 0;
        border: 1px solid #e2e8f0;
        border-bottom: 1px solid #f1f5f9;
        align-items: center;
    }
    
    .table-title {
        font-size: 16px;
        font-weight: 600;
    }

    .controls-wrapper {
        display: flex;
        gap: 12px;
        align-items: center;
    }

    .search-box input, .filter-box select {
        padding: 8px 12px;
        border-radius: 6px;
        border: 1px solid #cbd5e1;
        background: #ffffff;
        font-size: 13px;
        color: #0f172a;
        outline: none;
        transition: border-color 0.2s;
    }
    
    .search-box input { width: 250px; }
    .search-box input:focus, .filter-box select:focus { border-color: #2563eb; }

    /* ---------- TABLE SECTION ---------- */
    .container { 
        background: #ffffff; 
        border-radius: 0 0 12px 12px; 
        border: 1px solid #e2e8f0; 
        border-top: none;
        overflow-x: auto; 
        box-shadow: 0 1px 3px 0 rgba(15, 23, 42, 0.02);
    }
    table { width: 100%; border-collapse: collapse; text-align: left; }
    th, td { padding: 14px 24px; vertical-align: middle; }
    
    th { 
        font-size: 11px;
        font-weight: 600;
        color: #64748b;
        background-color: #f8fafc;
        border-bottom: 1px solid #e2e8f0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    td {
        font-size: 13px;
        color: #334155;
        border-bottom: 1px solid #f1f5f9;
    }

    tr:last-child td { border-bottom: none; }
    tr:hover { background-color: #f8fafc; }

    th:nth-child(2), td:nth-child(2) { 
        text-align: center; 
        width: 80px; 
    }

    .img-box { 
        width: 40px; 
        height: 40px; 
        background: #f8fafc; 
        border-radius: 8px; 
        overflow: hidden; 
        border: 1px solid #e2e8f0;
        display: inline-block; 
    }
    .img-box img { width: 100%; height: 100%; object-fit: cover; }

    .product-title { font-weight: 600; color: #0f172a; font-size: 14px; }
    .category-tag { background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 12px; color: #475569; font-weight: 500;}

    /* ---------- BUTTONS ---------- */
    .btn-primary { 
        background: #2563eb; 
        border: none; 
        padding: 8px 16px; 
        border-radius: 6px; 
        color: white; 
        cursor: pointer; 
        font-weight: 500; 
        font-size: 13px;
        transition: background 0.2s;
    }
    .btn-primary:hover { background: #1d4ed8; }

    .edit-btn { 
        background: #f1f5f9; 
        border: 1px solid #e2e8f0; 
        padding: 6px 12px; 
        border-radius: 6px; 
        color: #334155; 
        cursor: pointer; 
        font-weight: 500; 
        font-size: 12px;
        transition: 0.2s;
    }
    .edit-btn:hover { background: #e2e8f0; color: #0f172a; }

    .delete-btn { 
        background: transparent; 
        border: 1px solid transparent; 
        color: #ef4444; 
        padding: 6px 12px; 
        border-radius: 6px; 
        cursor: pointer; 
        margin-left: 4px; 
        font-size: 12px;
        font-weight: 500;
        transition: 0.2s;
    }
    .delete-btn:hover { background: #fef2f2; border-color: #fca5a5; }

    /* ---------- MODALS ---------- */
    .modal { 
        display: none; 
        position: fixed; 
        top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(15, 23, 42, 0.4); 
        z-index: 1000; 
        backdrop-filter: blur(2px); 
    }
    .modal-content { 
        background: #ffffff; 
        margin: 5% auto; 
        padding: 32px; 
        width: 440px; 
        border-radius: 16px; 
        border: 1px solid #e2e8f0; 
        box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.1), 0 8px 10px -6px rgba(15, 23, 42, 0.1);
    }
    
    #modalTitle {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 24px;
        color: #0f172a;
    }

    .form-group { margin-bottom: 16px; }
    .form-group label { 
        display: block; 
        font-size: 12px; 
        font-weight: 600;
        color: #475569; 
        margin-bottom: 6px; 
    }
    .modal input { 
        width: 100%; 
        padding: 10px 14px; 
        background: #ffffff; 
        border: 1px solid #cbd5e1; 
        border-radius: 8px; 
        color: #0f172a; 
        font-size: 13px;
        box-sizing: border-box; 
        outline: none;
        transition: border 0.2s;
    }
    .modal input:focus {
        border-color: #2563eb;
    }

    .modal-footer { display: flex; gap: 12px; margin-top: 32px; }
    
    .btn-save { 
        flex: 1; 
        background: #2563eb; 
        border: none; 
        padding: 12px; 
        border-radius: 8px; 
        color: white; 
        cursor: pointer; 
        font-weight: 600; 
        font-size: 14px;
        transition: 0.2s;
    }
    .btn-save:hover { background: #1d4ed8; }

    .btn-close { 
        background: #f1f5f9; 
        border: 1px solid #e2e8f0; 
        padding: 12px 20px; 
        border-radius: 8px; 
        color: #475569; 
        cursor: pointer; 
        font-weight: 600;
        font-size: 14px;
        transition: 0.2s;
    }
    .btn-close:hover { background: #e2e8f0; color: #0f172a; }

</style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">
            <h2>DigitalBazaar</h2>
            <small>Admin Panel</small>
        </div>
        <ul class="menu">
            <li>Dashboard</li>
            <li class="active">Inventory</li>
            <li>Orders</li>
            <li>Customers</li>
        </ul>
    </div>

    <div class="main">
        <div class="main-inner">
            <div class="topbar">
                <h2>Inventory Control <span class="badge">LIVE SYNC</span></h2>
                <button class="logout">Logout</button>
            </div>

            <div class="stats">
			    <div class="card" onclick="showAll()" style="cursor:pointer;" title="Click to show all products">
			        <p>Total Items</p>
			        <h3><%= request.getAttribute("totalItems") %></h3>
			    </div>
			    <div class="card" onclick="showLowStock()" style="cursor:pointer;" title="Click to show low stock only">
			        <p>Low Stock</p>
			        <h3 style="color:#ef4444"><%= String.format("%02d", (Integer)request.getAttribute("lowStockCount")) %></h3>
			    </div>
			    <div class="card">
			        <p>Quick Actions</p>
			        <button class="btn-primary" onclick="openAdd()">+ Add New Product</button>
			    </div>
			</div>

            <div class="control-bar">
                <div class="table-title">Product Catalog</div>
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
					    <%
					        List<Product> products = (List<Product>) request.getAttribute("productList");
					        if (products != null) {
					            for (Product p : products) {
					                String safeName = p.getName().replace("'", "\\'");
					    %>
					    <tr>
					        <td>#<%= p.getId() %></td>
					        <td>
					            <div class="img-box">
					                <img src="<%= request.getContextPath() %>/images/<%= p.getImage() %>" alt="product">
					            </div>
					        </td>
					        <td><span class="product-title"><%= p.getName() %></span></td>
					        <td><span class="category-tag"><%= p.getCategory() %></span></td>
					        <td style="<%= p.getStock() < 10 ? "color:#ef4444; font-weight:bold;" : "" %>">
					            <%= p.getStock() %>
					        </td>
					        <td>$<%= String.format("%.2f", p.getPrice()) %></td>
					        <td>
					            <button class="edit-btn" onclick="openEdit(
					                '<%= p.getId() %>',
					                '<%= safeName %>',
					                '<%= p.getCategory() %>',
					                '<%= p.getStock() %>',
					                '<%= p.getPrice() %>',
					                '<%= p.getImage() %>')">Edit</button>
					            <button class="delete-btn" onclick="deleteProduct('<%= p.getId() %>')">Delete</button>
					        </td>
					    </tr>
					    <%
					            }
					        }
					    %>
					</tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="productModal" class="modal">
	    <div class="modal-content">
	        <h3 id="modalTitle">Product Details</h3>
	        <form id="productForm" method="post" action="<%= request.getContextPath() %>/Order">
	            <input type="hidden" id="prodAction" name="action" value="add">
	            <input type="hidden" id="prodId"     name="id"     value="">
	
	            <div class="form-group">
	                <label>Name</label>
	                <input id="prodName" name="name" type="text" placeholder="Enter product name" required>
	            </div>
	            <div class="form-group">
	                <label>Category</label>
	                <input id="prodCategory" name="category" type="text" placeholder="e.g. GPU, CPU" required>
	            </div>
	            <div style="display:flex; gap:12px">
	                <div class="form-group" style="flex:1">
	                    <label>Stock</label>
	                    <input id="prodStock" name="stock" type="number" placeholder="0" required>
	                </div>
	                <div class="form-group" style="flex:1">
	                    <label>Price</label>
	                    <input id="prodPrice" name="price" type="text" placeholder="0.00" required>
	                </div>
	            </div>
	            <div class="form-group">
	                <label>Image Filename</label>
	                <input id="prodImage" name="image" type="text" placeholder="image.jpg" required>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn-close" onclick="closeModal()">Cancel</button>
	                <button type="submit" class="btn-save">Save Changes</button>
	            </div>
	        </form>
	    </div>
	</div>
	
	<!-- Hidden delete form -->
	<form id="deleteForm" method="post" action="<%= request.getContextPath() %>/Order">
	    <input type="hidden" name="action" value="delete">
	    <input type="hidden" id="deleteId" name="id" value="">
	</form>

    <script>
	    const modal = document.getElementById("productModal");
	
	    // ── SEARCH & FILTER ───────────────────────────────────────────────────────
	    function filterInventory() {
	        var searchValue   = document.getElementById("adminSearch").value.toLowerCase();
	        var categoryValue = document.getElementById("adminCategoryFilter").value.toLowerCase();
	        var rows = document.getElementById("inventoryTable")
	                           .getElementsByTagName("tbody")[0]
	                           .getElementsByTagName("tr");
	
	        for (var i = 0; i < rows.length; i++) {
	            var name     = rows[i].getElementsByTagName("td")[2].textContent.toLowerCase();
	            var category = rows[i].getElementsByTagName("td")[3].textContent.toLowerCase();
	            var matchSearch   = name.includes(searchValue);
	            var matchCategory = (categoryValue === "all" || category.includes(categoryValue));
	            rows[i].style.display = (matchSearch && matchCategory) ? "" : "none";
	        }
	    }
	
	    // ── OPEN ADD MODAL ────────────────────────────────────────────────────────
	    function openAdd() {
	        document.getElementById("modalTitle").innerText   = "Add New Product";
	        document.getElementById("prodAction").value       = "add";
	        document.getElementById("prodId").value           = "";
	        document.getElementById("prodName").value         = "";
	        document.getElementById("prodCategory").value     = "";
	        document.getElementById("prodStock").value        = "";
	        document.getElementById("prodPrice").value        = "";
	        document.getElementById("prodImage").value        = "";
	        modal.style.display = "block";
	    }
	
	    // ── OPEN EDIT MODAL ───────────────────────────────────────────────────────
	    function openEdit(id, name, cat, stock, price, img) {
	        document.getElementById("modalTitle").innerText   = "Edit Product";
	        document.getElementById("prodAction").value       = "edit";
	        document.getElementById("prodId").value           = id;
	        document.getElementById("prodName").value         = name;
	        document.getElementById("prodCategory").value     = cat;
	        document.getElementById("prodStock").value        = stock;
	        document.getElementById("prodPrice").value        = price;
	        document.getElementById("prodImage").value        = img;
	        modal.style.display = "block";
	    }
	
	    // ── DELETE ────────────────────────────────────────────────────────────────
	    function deleteProduct(id) {
	        if (!confirm("Are you sure you want to delete this product?")) return;
	        document.getElementById("deleteId").value = id;
	        document.getElementById("deleteForm").submit();
	    }
	
	    // ── CLOSE MODAL ───────────────────────────────────────────────────────────
	    function closeModal() { modal.style.display = "none"; }
	
	    window.onclick = function(event) {
	        if (event.target === modal) closeModal();
	    }
	    
	 // ── SHOW LOW STOCK ONLY ───────────────────────────────────────────────────
	    function showLowStock() {
	        var rows = document.getElementById("inventoryTable")
	                           .getElementsByTagName("tbody")[0]
	                           .getElementsByTagName("tr");

	        for (var i = 0; i < rows.length; i++) {
	            var stockCell = rows[i].getElementsByTagName("td")[4].textContent.trim();
	            var stock     = parseInt(stockCell);
	            rows[i].style.display = (stock < 10) ? "" : "none";
	        }

	        // Update table title to indicate filter is active
	        document.querySelector(".table-title").textContent = "⚠️ Low Stock Products";

	        // Clear search/filter inputs so they don't interfere
	        document.getElementById("adminSearch").value = "";
	        document.getElementById("adminCategoryFilter").value = "all";
	    }

	    // ── SHOW ALL PRODUCTS ─────────────────────────────────────────────────────
	    function showAll() {
	        var rows = document.getElementById("inventoryTable")
	                           .getElementsByTagName("tbody")[0]
	                           .getElementsByTagName("tr");

	        for (var i = 0; i < rows.length; i++) {
	            rows[i].style.display = "";
	        }

	        document.querySelector(".table-title").textContent = "Product Catalog";

	        document.getElementById("adminSearch").value = "";
	        document.getElementById("adminCategoryFilter").value = "all";
	    }
	</script>
</body>
</html>