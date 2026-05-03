<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Management – DigitalBazaar</title>
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

    /* ---------- SIDEBAR (Matching image_6c94db.png) ---------- */
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
    
    .logo { margin-bottom: 36px; }
    .logo h2 { font-size: 18px; font-weight: 700; letter-spacing: -0.02em; }
    .logo small { color: #64748b; font-size: 11px; font-weight: 600; text-transform: uppercase; display: block; margin-top: 4px; }

    .menu { list-style: none; display: flex; flex-direction: column; gap: 8px; }
    .menu li { padding: 12px 16px; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 500; color: #94a3b8; transition: 0.2s; }
    .menu li:hover { background-color: #1e293b; color: #ffffff; }
    .menu li.active { background-color: #2563eb; color: #ffffff; }

    /* ---------- MAIN CONTENT ---------- */
    .main { 
        margin-left: 260px; 
        padding: 32px; 
        width: calc(100% - 260px); 
        height: 100vh;
        overflow-y: auto;
    }

    .main-inner { max-width: 1400px; margin: 0 auto; }

    .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .topbar h2 { font-size: 24px; font-weight: 700; display: flex; align-items: center; gap: 12px; }
    .badge { background: #eff6ff; color: #2563eb; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }

    .logout { background: #ffffff; border: 1px solid #e2e8f0; color: #64748b; padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; }
    .logout:hover { border-color: #ef4444; color: #ef4444; background: #fef2f2; }

    /* ---------- STATS CARDS ---------- */
    .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 24px; }
    .card { background: #ffffff; padding: 24px; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(15, 23, 42, 0.05); }
    .card p { font-size: 11px; font-weight: 600; text-transform: uppercase; color: #64748b; margin-bottom: 8px; }
    .card h3 { font-size: 26px; font-weight: 700; color: #0f172a; }

    /* ---------- TABLE UI ---------- */
    .control-bar {
        display: flex;
        justify-content: space-between;
        background: #ffffff;
        padding: 18px 24px;
        border-radius: 12px 12px 0 0;
        border: 1px solid #e2e8f0;
        align-items: center;
    }
    .search-box input { padding: 8px 12px; border-radius: 6px; border: 1px solid #cbd5e1; width: 250px; font-size: 13px; }

    .container { background: #ffffff; border-radius: 0 0 12px 12px; border: 1px solid #e2e8f0; border-top: none; overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; text-align: left; }
    th, td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
    th { font-size: 11px; font-weight: 600; color: #64748b; background-color: #f8fafc; text-transform: uppercase; }
    td { font-size: 13px; color: #334155; }

    .user-title { font-weight: 600; color: #0f172a; }
    .status-badge-active { background: #eff6ff; color: #2563eb; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }
    .status-badge-inactive { background: #f1f5f9; color: #64748b; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }

    .delete-btn { color: #ef4444; background: none; border: none; font-weight: 600; cursor: pointer; font-size: 12px; }
    .delete-btn:hover { text-decoration: underline; }

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
            <li>Inventory</li>
            <li>Orders</li>
            <li class="active">Customers</li>
        </ul>
    </div>

    <div class="main">
        <div class="main-inner">
            <div class="topbar">
                <h2>User Management <span class="badge">SECURE ACCESS</span></h2>
                <button class="logout">Logout</button>
            </div>

            <div class="stats">
                <div class="card">
                    <p>Total Users</p>
                    <h3>1,248</h3>
                </div>
                <div class="card">
                    <p>Active Now</p>
                    <h3 style="color: #2563eb">42</h3>
                </div>
                <div class="card">
                    <p>Quick Actions</p>
                    <button style="background:#2563eb; color:white; border:none; padding:8px 12px; border-radius:6px; cursor:pointer; font-size:12px;">+ Create Admin</button>
                </div>
            </div>

            <div class="control-bar">
                <div style="font-weight: 600;">Customer Directory</div>
                <div class="search-box">
                    <input type="text" placeholder="Search by username or email...">
                </div>
            </div>

            <div class="container">
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Password</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Mock Row 1 -->
                        <tr>
                            <td>#001</td>
                            <td><span class="user-title">alex_pro</span></td>
                            <td>alex.p@example.com</td>
                            <td style="letter-spacing: 2px;">••••••••</td>
                            <td><span class="status-badge-active">ACTIVE</span></td>
                            <td>2 hours ago</td>
                            <td>Jan 12, 2024</td>
                            <td><button class="delete-btn">Delete</button></td>
                        </tr>
                        <!-- Mock Row 2 -->
                        <tr>
                            <td>#002</td>
                            <td><span class="user-title">sarah_dev</span></td>
                            <td>sarah.smith@web.com</td>
                            <td style="letter-spacing: 2px;">••••••••</td>
                            <td><span class="status-badge-inactive">INACTIVE</span></td>
                            <td>12 days ago</td>
                            <td>Feb 05, 2024</td>
                            <td><button class="delete-btn">Delete</button></td>
                        </tr>
                        <!-- Mock Row 3 -->
                        <tr>
                            <td>#003</td>
                            <td><span class="user-title">mike_retail</span></td>
                            <td>mike88@gmail.com</td>
                            <td style="letter-spacing: 2px;">••••••••</td>
                            <td><span class="status-badge-active">ACTIVE</span></td>
                            <td>Just now</td>
                            <td>Mar 20, 2024</td>
                            <td><button class="delete-btn">Delete</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>