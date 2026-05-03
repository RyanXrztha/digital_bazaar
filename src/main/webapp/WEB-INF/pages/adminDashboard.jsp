<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard – DigitalBazaar</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
*, ::before, ::after { 
    margin: 0; 
    padding: 0; 
    box-sizing: border-box; 
}

body, html {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    background-color: #f8fafc;
    color: #0f172a;
    height: 100vh;
    width: 100vw;
    overflow: hidden;
}

/* ── LAYOUT ENGINE ── */
.app { 
    display: flex; 
    height: 100vh; 
    width: 100%;
}

/* ── SIDEBAR ── */
.sidebar {
    width: 260px;
    background-color: #0f172a;
    color: #ffffff;
    padding: 24px 20px;
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
}

.logo {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 36px;
    letter-spacing: -0.02em;
    color: #ffffff;
}

.menu {
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex-grow: 1;
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

.menu li:hover { 
    background-color: #1e293b; 
    color: #ffffff; 
}

.menu li.active { 
    background-color: #2563eb; 
    color: #ffffff; 
}

/* ── MAIN LAYOUT ── */
.main { 
    flex-grow: 1; 
    display: flex; 
    flex-direction: column; 
    background-color: #f8fafc;
    min-width: 0;
}

/* ── TOPBAR ── */
.topbar {
    height: 64px;
    background-color: #ffffff;
    border-bottom: 1px solid #e2e8f0;
    padding: 0 32px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
}

.topbar-title { 
    font-size: 16px; 
    font-weight: 700; 
    color: #0f172a; 
}

.topbar-subtitle { 
    font-size: 12px; 
    color: #64748b; 
}

/* ── SCROLLABLE REGION ── */
.content-scrollable {
    flex-grow: 1;
    overflow-y: auto;
    overflow-x: hidden;
    padding: 32px;
}

.content-inner {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 24px;
}

/* ── STAT CARDS ── */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
}

.card {
    background: #ffffff;
    padding: 20px;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 1px 3px 0 rgba(15, 23, 42, 0.05);
    display: flex;
    flex-direction: column;
    gap: 12px;
    min-width: 0;
}

.stat-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.stat-label { 
    font-size: 11px; 
    font-weight: 600; 
    text-transform: uppercase;
    letter-spacing: 0.05em; 
    color: #64748b; 
}

.stat-icon {
    font-size: 14px;
    color: #475569;
}

.stat-value { 
    font-size: 26px; 
    font-weight: 700; 
    color: #0f172a; 
    letter-spacing: -0.02em;
}

.stat-trend {
    font-size: 11px;
    font-weight: 500;
}

.trend-up { color: #16a34a; }
.trend-down { color: #dc2626; }
.trend-neutral { color: #64748b; }

/* ── FILTERS ── */
.filters {
    display: flex;
    gap: 12px;
    padding: 18px 24px;
    background-color: #f8fafc;
    border-bottom: 1px solid #f1f5f9;
}

.filters input, .filters select {
    padding: 8px 12px;
    border-radius: 6px;
    border: 1px solid #cbd5e1;
    background: #ffffff;
    font-size: 13px;
    color: #0f172a;
}

/* ── TABLE ── */
.table-responsive {
    width: 100%;
    overflow-x: auto;
}

.table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
}

.table th {
    font-size: 11px;
    font-weight: 600;
    color: #64748b;
    padding: 12px 24px;
    background-color: #f8fafc;
    border-bottom: 1px solid #e2e8f0;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.table td {
    padding: 14px 24px;
    font-size: 13px;
    color: #334155;
    border-bottom: 1px solid #f1f5f9;
    vertical-align: middle;
}

.table tr:last-child td { border-bottom: none; }
.table tr:hover { background-color: #f8fafc; }

/* ── BADGES ── */
.badge {
    padding: 4px 10px;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 600;
    display: inline-flex;
}

.critical { background-color: #fef2f2; color: #b91c1c; }
.low { background-color: #fffbeb; color: #b45309; }
.ok { background-color: #f0fdf4; color: #15803d; }

.btn-action {
    color: #2563eb;
    background: none;
    border: none;
    font-family: inherit;
    font-weight: 500;
    cursor: pointer;
    font-size: 13px;
}

.btn-action:hover {
    text-decoration: underline;
}

/* ── CHART ── */
.chart-card { min-height: 380px; }
.chart-box { 
    height: 300px; 
    margin-top: 12px; 
}

@media (max-width: 768px) {
    .sidebar { display: none; }
    .content-scrollable { padding: 16px; }
}
</style>
</head>

<body>

<%
int totalOrders = (Integer)(request.getAttribute("totalOrders")!=null?request.getAttribute("totalOrders"):0);
double totalSales = (Double)(request.getAttribute("totalSales")!=null?request.getAttribute("totalSales"):0.0);
int totalCustomers = (Integer)(request.getAttribute("totalCustomers")!=null?request.getAttribute("totalCustomers"):0);

List<Map<String,Object>> lowStock = (List<Map<String,Object>>)request.getAttribute("lowStock");
List<String> chartLabels = (List<String>)request.getAttribute("chartLabels");
List<Double> chartData = (List<Double>)request.getAttribute("chartData");
List<String> catLabels = (List<String>)request.getAttribute("catLabels");
%>

<div class="app">

    <aside class="sidebar">
        <div class="logo">DigitalBazaar</div>
        <ul class="menu">
            <li class="active">Dashboard</li>
            <li onclick="goTo('products')">Products</li>
            <li onclick="goTo('orders')">Orders</li>
            <li onclick="goTo('customers')">Customers</li>
        </ul>
    </aside>

    <div class="main">

        <header class="topbar">
            <div>
                <h1 class="topbar-title">Admin Dashboard</h1>
                <span class="topbar-subtitle">Manage inventory and monitor store health</span>
            </div>
        </header>

        <main class="content-scrollable">
            <div class="content-inner">

                <div class="grid">
                    <div class="card">
                        <div class="stat-header">
                            <span class="stat-label">Total Revenue</span>
                            <span class="stat-icon">💰</span>
                        </div>
                        <div class="stat-value">$<%= totalSales %></div>
                        <div class="stat-trend trend-up">▲ +12.5% vs last week</div>
                    </div>

                    <div class="card">
                        <div class="stat-header">
                            <span class="stat-label">Total Orders</span>
                            <span class="stat-icon">🛒</span>
                        </div>
                        <div class="stat-value"><%= totalOrders %></div>
                        <div class="stat-trend trend-up">▲ +8.2% vs last week</div>
                    </div>

                    <div class="card">
                        <div class="stat-header">
                            <span class="stat-label">Customers</span>
                            <span class="stat-icon">👥</span>
                        </div>
                        <div class="stat-value"><%= totalCustomers %></div>
                        <div class="stat-trend trend-down">▼ -2.1% vs last week</div>
                    </div>

                    <div class="card">
                        <div class="stat-header">
                            <span class="stat-label">Inventory Alerts</span>
                            <span class="stat-icon">⚠️</span>
                        </div>
                        <div class="stat-value"><%= (lowStock!=null?lowStock.size():0) %></div>
                        <div class="stat-trend trend-neutral">0% vs last week</div>
                    </div>
                </div>

                <div class="card chart-card">
                    <span class="card-title">Weekly Revenue</span>
                    <div class="chart-box">
                        <canvas id="chart"></canvas>
                    </div>
                </div>

                <div class="card">
                    <div class="filters">
                        <input type="text" id="search" placeholder="Search product...">
                        <select id="category">
                            <option value="">All Categories</option>
                            <% if(catLabels!=null){
                                for(String c:catLabels){ %>
                                    <option value="<%=c%>"><%=c%></option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Stock Level</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <% if(lowStock!=null){
                                    for(Map<String,Object> item:lowStock){
                                        int stock = (Integer)item.get("stock");
                                        String cls = stock==0?"critical":stock<5?"low":"ok";
                                %>
                                <tr>
                                    <td class="item-name"><%= item.get("name") %></td>
                                    <td><%= item.get("category") %></td>
                                    <td><%= stock %> units</td>
                                    <td>
                                        <span class="badge <%= cls %>">
                                            <%= stock==0 ? "Critical" : stock<5 ? "Low" : "OK" %>
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn-action" onclick="goTo('products')">Restock</button>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
function goTo(p){
    window.location.href = "<%=request.getContextPath()%>/"+p;
}

// SEARCH/FILTER
document.getElementById('search').addEventListener('keyup', filter);
document.getElementById('category').addEventListener('change', filter);

function filter(){
    let s = document.getElementById('search').value.toLowerCase();
    let c = document.getElementById('category').value.toLowerCase();

    document.querySelectorAll("#tableBody tr").forEach(row=>{
        let name = row.children[0].innerText.toLowerCase();
        let cat  = row.children[1].innerText.toLowerCase();

        row.style.display = (name.includes(s) && (c === "" || cat === c)) ? "" : "none";
    });
}

// CHART
new Chart(document.getElementById('chart'), {
    type: 'line',
    data: {
        labels: <%= chartLabels %>,
        datasets: [{
            data: <%= chartData %>,
            borderColor: '#2563eb',
            backgroundColor: 'rgba(37, 99, 235, 0.06)',
            fill: true,
            tension: 0.3,
            borderWidth: 2,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#2563eb',
            pointRadius: 4
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false }
        },
        scales: {
            x: {
                grid: { display: false }
            },
            y: {
                beginAtZero: true,
                grid: { color: '#f1f5f9' },
                ticks: {
                    callback: function(v) { return '$' + v; }
                }
            }
        }
    }
});
</script>

</body>
</html>