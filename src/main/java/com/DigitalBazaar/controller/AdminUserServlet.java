package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.DigitalBazaar.config.DBConfig;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

@WebServlet("/manage-user")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminUserServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = new ArrayList<>();
        int totalUsers = 0, activeUsers = 0;

        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT id, fullname, username, email, status, last_login, created_date " +
                 "FROM users ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullname(rs.getString("fullname"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setStatus(rs.getString("status"));
                u.setLastLogin(rs.getString("last_login"));
                u.setCreatedDate(rs.getString("created_date"));
                users.add(u);
                totalUsers++;
                if ("ACTIVE".equals(u.getStatus())) activeUsers++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("users", users);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.getRequestDispatcher("/WEB-INF/pages/admin-user-management.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ── CREATE ADMIN ──────────────────────────────────────────────────────
        if ("createAdmin".equals(action)) {
            String adminUsername = request.getParameter("adminUsername");
            String adminPassword = request.getParameter("adminPassword");
            String adminConfirm  = request.getParameter("adminConfirm");

            // Validate inputs
            if (adminUsername == null || adminUsername.trim().isEmpty()) {
                request.setAttribute("adminError", "Username cannot be empty");
                doGet(request, response);
                return;
            }
            if (adminPassword == null || adminPassword.trim().isEmpty()) {
                request.setAttribute("adminError", "Password cannot be empty");
                doGet(request, response);
                return;
            }
            if (!adminPassword.equals(adminConfirm)) {
                request.setAttribute("adminError", "Passwords do not match");
                doGet(request, response);
                return;
            }

            try (Connection conn = DBConfig.getDbConnection()) {

                // Check if username already exists in admins table
                try (PreparedStatement check = conn.prepareStatement(
                        "SELECT id FROM admins WHERE username = ?")) {
                    check.setString(1, adminUsername.trim());
                    ResultSet rs = check.executeQuery();
                    if (rs.next()) {
                        request.setAttribute("adminError", "Username '" + adminUsername + "' already exists");
                        doGet(request, response);
                        return;
                    }
                }

                // Hash password with BCrypt and insert
                String hashed = BCrypt.hashpw(adminPassword.trim(), BCrypt.gensalt());
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO admins (username, password) VALUES (?, ?)")) {
                    ps.setString(1, adminUsername.trim());
                    ps.setString(2, hashed);
                    ps.executeUpdate();
                }

                request.setAttribute("adminSuccess", "Admin '" + adminUsername + "' created successfully");
                doGet(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("adminError", "Server error: " + e.getMessage());
                doGet(request, response);
            }
            return;
        }

        // ── DELETE USER ───────────────────────────────────────────────────────
        try (Connection conn = DBConfig.getDbConnection()) {

            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));

                try (PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM orders WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM users WHERE id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }

            // ── TOGGLE STATUS ─────────────────────────────────────────────────
            } else if ("toggleStatus".equals(action)) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE users SET status = CASE WHEN status='ACTIVE' " +
                        "THEN 'INACTIVE' ELSE 'ACTIVE' END WHERE id = ?")) {
                    ps.setInt(1, Integer.parseInt(request.getParameter("userId")));
                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Action failed: " + e.getMessage());
            return;
        }

        response.sendRedirect(request.getContextPath() + "/manage-user");
    }
}
