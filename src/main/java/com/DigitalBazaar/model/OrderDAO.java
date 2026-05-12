package com.DigitalBazaar.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.DigitalBazaar.config.DBConfig;

public class OrderDAO {

    public boolean placeOrder(int userId, int productId, int quantity, double totalPrice) {
        String query = "INSERT INTO orders (user_id, product_id, quantity, total_price, status) VALUES (?, ?, ?, ?, 'bought')";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.setDouble(4, totalPrice);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("OrderDAO.placeOrder error: " + e.getMessage());
            return false;
        }
    }
    
    public List<Map<String, Object>> getOrdersByUser(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT o.id, p.name, o.quantity, o.total_price, o.status, o.order_date " +
                       "FROM orders o JOIN products p ON o.product_id = p.id " +
                       "WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new java.util.LinkedHashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("product", rs.getString("name"));
                row.put("qty", rs.getInt("quantity"));
                row.put("total", rs.getDouble("total_price"));
                row.put("status", rs.getString("status"));
                row.put("date", rs.getString("order_date"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
