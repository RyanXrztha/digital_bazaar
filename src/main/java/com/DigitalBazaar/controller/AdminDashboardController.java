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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.DigitalBazaar.config.DBConfig;

/**
 * Servlet implementation class AdminDashboardController
 */
@WebServlet("/adminDashboard")
public class AdminDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminDashboardController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
        try {
        	conn = DBConfig.getDbConnection();

            // ── Total orders ──────────────────────────────────────────
            int totalOrders = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalOrders = rs.getInt(1);
            }

            // ── Total sales ───────────────────────────────────────────
            double totalSales = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(total_price), 0) FROM orders WHERE status = 'completed'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalSales = rs.getDouble(1);
            }

            // ── Total customers ───────────────────────────────────────
            int totalCustomers = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM users");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalCustomers = rs.getInt(1);
            }

            // ── Low stock products (stock < 10) ───────────────────────
            List<Map<String, Object>> lowStock = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT name, category, stock FROM products WHERE stock < 10 ORDER BY stock ASC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("name",     rs.getString("name"));
                    row.put("category", rs.getString("category"));
                    row.put("stock",    rs.getInt("stock"));
                    lowStock.add(row);
                }
            }

            // ── Sales over last 7 days (for line chart) ───────────────
            List<String> chartLabels = new ArrayList<>();
            List<Double> chartData   = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DATE(order_date) AS day, COALESCE(SUM(total_price), 0) AS revenue " +
                    "FROM orders " +
                    "WHERE order_date >= CURDATE() - INTERVAL 6 DAY " +
                    "GROUP BY DATE(order_date) " +
                    "ORDER BY day ASC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    chartLabels.add(rs.getString("day"));
                    chartData.add(rs.getDouble("revenue"));
                }
            }

            // ── Top-selling categories ────────────────────────────────
            List<String> catLabels = new ArrayList<>();
            List<Integer> catData  = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT p.category, COALESCE(SUM(o.quantity), 0) AS total_sold " +
                    "FROM products p " +
                    "LEFT JOIN orders o ON p.id = o.product_id " +
                    "GROUP BY p.category " +
                    "ORDER BY total_sold DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    catLabels.add(rs.getString("category"));
                    catData.add(rs.getInt("total_sold"));
                }
            }

            // ── Pass to JSP ───────────────────────────────────────────
            request.setAttribute("totalOrders",    totalOrders);
            request.setAttribute("totalSales",     totalSales);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("lowStock",       lowStock);
            request.setAttribute("chartLabels",    chartLabels);
            request.setAttribute("chartData",      chartData);
            request.setAttribute("catLabels",      catLabels);
            request.setAttribute("catData",        catData);

            request.getRequestDispatcher("/WEB-INF/pages/adminDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Dashboard error: " + e.getMessage());
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
