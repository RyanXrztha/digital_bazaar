<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.List, com.DigitalBazaar.model.User" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
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

@keyframes modalUp {
  from { opacity:0; transform:translateY(12px); }
  to   { opacity:1; transform:translateY(0); }
}

    
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

    .user-title { font-weight: 600; color: #0f172a; }
    .status-badge-active { background: #eff6ff; color: #2563eb; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }
    .status-badge-inactive { background: #f1f5f9; color: #64748b; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }

    .delete-btn { color: #ef4444; background: none; border: none; font-weight: 600; cursor: pointer; font-size: 12px; margin-left: 6px; }
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
		    <li onclick="goTo('admin-dashboard')">Dashboard</li>
		    <li onclick="goTo('admin-products')">Inventory</li>
		    <li class="active">Manage Customers</li>
		</ul>
    </div>

    <div class="main">
        <div class="main-inner">
            <div class="topbar">
                <h2>User Management <span class="badge">SECURE ACCESS</span></h2>
                <button class="logout" onclick="window.location.href='${pageContext.request.contextPath}/logout'">Logout</button>
            </div>

            <div class="stats">
                <div class="card">
				    <p>Total Users</p>
				    <h3>${totalUsers}</h3>
				</div>
				<div class="card">
				    <p>Active Now</p>
				    <h3 style="color: #2563eb">${activeUsers}</h3>
				</div>
                <div class="card">
				    <p>Quick Actions</p>
				    <button onclick="openCreateAdmin()" style="background:#2563eb; color:white; border:none; padding:8px 12px; border-radius:6px; cursor:pointer; font-size:12px;">+ Create Admin</button>
				</div>
            </div>

            <div class="control-bar">
                <div style="font-weight: 600;">Customer Directory</div>
                <div class="search-box">
                    <input type="text" id="userSearch" placeholder="Search by username..." onkeyup="filterUsers()">
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
					    <c:forEach var="u" items="${users}">
					    <c:set var="statusClass" value="${u.status == 'ACTIVE' ? 'status-badge-active' : 'status-badge-inactive'}" />
					    <tr>
					        <td>#${u.id}</td>
					        <td><span class="user-title">${u.username}</span></td>
					        <td>${u.email}</td>
					        <td style="letter-spacing: 2px;">••••••••</td>
					        <td><span class="${statusClass}">${u.status}</span></td>
					        <td>${not empty u.lastLogin ? u.lastLogin : 'Never'}</td>
					        <td>${not empty u.createdDate ? u.createdDate : '—'}</td>
					        <td>
							    <form method="post" action="${pageContext.request.contextPath}/manage-user" style="display:inline">
							        <input type="hidden" name="action" value="toggleStatus">
							        <input type="hidden" name="userId" value="${u.id}">
							        <button type="submit" class="edit-btn">Toggle</button>
							    </form>
							    <button class="delete-btn" onclick="deleteUser(${u.id})">Delete</button>
							</td>
					    </tr>
					</c:forEach>
					</tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Create Admin Modal -->
<div id="adminModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(15,23,42,0.4); z-index:1000; backdrop-filter:blur(2px);">
    <div style="background:#ffffff; margin:5% auto; padding:32px; width:440px; border-radius:16px; border:1px solid #e2e8f0; box-shadow:0 10px 25px -5px rgba(15,23,42,0.1);">
        
        <h3 id="adminModalTitle" style="font-size:18px; font-weight:700; margin-bottom:24px; color:#0f172a;">
            Create Admin Account
        </h3>

        <c:if test="${not empty adminError}">
            <p style="color:#ef4444; margin-bottom:16px; font-size:13px; background:#fef2f2; padding:10px 14px; border-radius:8px;">
                ⚠ ${adminError}
            </p>
        </c:if>
        <c:if test="${not empty adminSuccess}">
            <p style="color:#16a34a; margin-bottom:16px; font-size:13px; background:#f0fdf4; padding:10px 14px; border-radius:8px;">
                ✓ ${adminSuccess}
            </p>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/manage-user">
            <input type="hidden" name="action" value="createAdmin">

            <div style="margin-bottom:16px;">
                <label style="display:block; font-size:12px; font-weight:600; color:#475569; margin-bottom:6px;">
                    Username
                </label>
                <input type="text" name="adminUsername" placeholder="Enter admin username" required
                       style="width:100%; padding:10px 14px; border:1px solid #cbd5e1; border-radius:8px; font-size:13px; outline:none; box-sizing:border-box; transition:border 0.2s;"
                       onfocus="this.style.borderColor='#2563eb'" 
                       onblur="this.style.borderColor='#cbd5e1'">
            </div>

            <div style="margin-bottom:16px;">
                <label style="display:block; font-size:12px; font-weight:600; color:#475569; margin-bottom:6px;">
                    Password
                </label>
                <input type="password" name="adminPassword" placeholder="Enter password" required
                       style="width:100%; padding:10px 14px; border:1px solid #cbd5e1; border-radius:8px; font-size:13px; outline:none; box-sizing:border-box; transition:border 0.2s;"
                       onfocus="this.style.borderColor='#2563eb'" 
                       onblur="this.style.borderColor='#cbd5e1'">
            </div>

            <div style="margin-bottom:32px;">
                <label style="display:block; font-size:12px; font-weight:600; color:#475569; margin-bottom:6px;">
                    Confirm Password
                </label>
                <input type="password" name="adminConfirm" placeholder="Confirm password" required
                       style="width:100%; padding:10px 14px; border:1px solid #cbd5e1; border-radius:8px; font-size:13px; outline:none; box-sizing:border-box; transition:border 0.2s;"
                       onfocus="this.style.borderColor='#2563eb'" 
                       onblur="this.style.borderColor='#cbd5e1'">
            </div>

            <div style="display:flex; gap:12px;">
                <button type="button" onclick="closeAdminModal()"
                        style="flex:1; background:#f1f5f9; border:1px solid #e2e8f0; padding:12px; border-radius:8px; color:#475569; cursor:pointer; font-weight:600; font-size:14px;">
                    Cancel
                </button>
                <button type="submit"
                        style="flex:1; background:#2563eb; border:none; padding:12px; border-radius:8px; color:white; cursor:pointer; font-weight:600; font-size:14px;">
                    Create Admin
                </button>
            </div>
        </form>
    </div>
</div>
<script>
function goTo(p) {
    window.location.href = "${pageContext.request.contextPath}/" + p;
}

function filterUsers() {
    var search = document.getElementById("userSearch").value.toLowerCase();
    var rows = document.querySelectorAll("tbody tr");
    rows.forEach(function(row) {
        var username = row.getElementsByTagName("td")[1].textContent.toLowerCase();
        row.style.display = username.includes(search) ? "" : "none";
    });
}

function openCreateAdmin() {
    document.getElementById('adminModal').style.display = 'block';
}

function closeAdminModal() {
    document.getElementById('adminModal').style.display = 'none';
}

// Auto-open modal if server returned error or success message
window.addEventListener('load', function() {
    var hasError   = '${not empty adminError}';
    var hasSuccess = '${not empty adminSuccess}';
    if (hasError === 'true' || hasSuccess === 'true') {
        openCreateAdmin();
    }
});

// Close when clicking backdrop
window.onclick = function(e) {
    var modal = document.getElementById('adminModal');
    if (e.target === modal) closeAdminModal();
}
var pendingDeleteUserId = null;

function deleteUser(id) {
    pendingDeleteUserId = id;
    document.getElementById('deleteUserModal').style.display = 'flex';
}

function confirmUserDelete() {
    if (!pendingDeleteUserId) return;
    document.getElementById('deleteUserId').value = pendingDeleteUserId;
    document.getElementById('deleteUserForm').submit();
}

function closeDeleteUserModal() {
    pendingDeleteUserId = null;
    document.getElementById('deleteUserModal').style.display = 'none';
}

document.getElementById('deleteUserModal').addEventListener('click', function(e) {
    if (e.target === this) closeDeleteUserModal();
});
</script>
<!-- Delete User Confirmation Modal -->
<div id="deleteUserModal" style="display:none; position:fixed; inset:0; background:rgba(15,23,42,0.45); z-index:2000; align-items:center; justify-content:center; backdrop-filter:blur(2px);">
  <div onclick="event.stopPropagation()" style="background:#fff; border-radius:16px; border:1px solid #e2e8f0; width:380px; overflow:hidden; box-shadow:0 10px 25px -5px rgba(15,23,42,0.15); animation:modalUp 0.25s ease; font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
    <div style="padding:28px 28px 0;">
      <div style="font-size:17px; font-weight:700; color:#0f172a; margin-bottom:8px;">Delete User?</div>
      <div style="font-size:13px; color:#64748b; line-height:1.6;">This action cannot be undone. The user account will be permanently removed from the system.</div>
    </div>
    <div style="padding:24px 28px 28px; display:flex; gap:10px;">
      <button onclick="closeDeleteUserModal()" style="flex:1; padding:11px; background:#f1f5f9; border:1px solid #e2e8f0; border-radius:8px; color:#475569; font-size:13px; font-weight:600; cursor:pointer;">Cancel</button>
      <button onclick="confirmUserDelete()" style="flex:1; padding:11px; background:#ef4444; border:none; border-radius:8px; color:#fff; font-size:13px; font-weight:600; cursor:pointer;">Yes, Delete</button>
    </div>
  </div>
</div>

<!-- Hidden delete form -->
<form id="deleteUserForm" method="post" action="${pageContext.request.contextPath}/manage-user">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" id="deleteUserId" name="userId" value="">
</form>
</body>
</html>