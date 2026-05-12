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
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class AdminDashboardController
 */
@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminDashboardServlet() {
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
            		"SELECT COALESCE(SUM(total_price), 0) FROM orders WHERE status = 'bought'");
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
         // ── Monthly sales for last 6 months (line chart) ──────────────
            StringBuilder labelsSb = new StringBuilder("[");
            StringBuilder dataSb   = new StringBuilder("[");
            StringBuilder orderSb  = new StringBuilder("[");

         // REPLACE WITH:
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DATE_FORMAT(order_date, '%b %Y') AS day, " +
                    "DATE_FORMAT(order_date, '%Y-%m') AS sort_key, " +
                    "COALESCE(SUM(total_price), 0) AS revenue, " +
                    "COUNT(id) AS order_count " +
                    "FROM orders WHERE status = 'bought' " +
                    "AND order_date >= DATE_SUB(NOW(), INTERVAL 7 MONTH) " +
                    "GROUP BY sort_key, day ORDER BY sort_key ASC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String day = rs.getString("day");
                    double rev = rs.getDouble("revenue");
                    int    cnt = rs.getInt("order_count");
                    labelsSb.append("'").append(day).append("',");
                    dataSb.append(rev).append(",");
                    orderSb.append(cnt).append(",");
                }
            }

            String labelsJson = labelsSb.length() > 1
                ? labelsSb.deleteCharAt(labelsSb.length()-1).append("]").toString() : "[]";
            String dataJson = dataSb.length() > 1
                ? dataSb.deleteCharAt(dataSb.length()-1).append("]").toString() : "[]";
            String orderJson = orderSb.length() > 1
                ? orderSb.deleteCharAt(orderSb.length()-1).append("]").toString() : "[]";

            // ── Pass to JSP ───────────────────────────────────────────────
            request.setAttribute("chartLabels",    labelsJson);   // ← JSON string, not List
            request.setAttribute("chartData",      dataJson);     // ← JSON string, not List
            request.setAttribute("chartOrderData", orderJson);    // ← new: order count line

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
         // REPLACE WITH (keep only catLabels/catData, chartLabels/chartData already set above):
            request.setAttribute("catLabels",      catLabels);
            request.setAttribute("catData",        catData);

            request.getRequestDispatcher("/WEB-INF/pages/admin-dashboard.jsp").forward(request, response);

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
