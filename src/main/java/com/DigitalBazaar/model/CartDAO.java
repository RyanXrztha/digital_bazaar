package com.DigitalBazaar.model;

import com.DigitalBazaar.config.DBConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Add to cart — if product already in cart, increment qty
    public boolean addToCart(int userId, int productId, int quantity, double unitPrice) {
        String check = "SELECT id, quantity FROM orders WHERE user_id=? AND product_id=? AND status='cart'";
        String update = "UPDATE orders SET quantity=?, total_price=? WHERE id=?";
        String insert = "INSERT INTO orders (user_id, product_id, quantity, total_price, status) VALUES (?,?,?,?,'cart')";
        try (Connection conn = DBConfig.getDbConnection()) {
            // Check if already in cart
            try (PreparedStatement ps = conn.prepareStatement(check)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int existingId  = rs.getInt("id");
                    int newQty      = rs.getInt("quantity") + quantity;
                    double newTotal = newQty * unitPrice;
                    try (PreparedStatement ups = conn.prepareStatement(update)) {
                        ups.setInt(1, newQty);
                        ups.setDouble(2, newTotal);
                        ups.setInt(3, existingId);
                        return ups.executeUpdate() > 0;
                    }
                }
            }
            // Not in cart yet — insert
            try (PreparedStatement ps = conn.prepareStatement(insert)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
                ps.setDouble(4, quantity * unitPrice);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all cart items for a user (joined with products for name/image/category)
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT o.id, o.product_id, o.quantity, o.total_price, " +
                     "p.name, p.price, p.image, p.category " +
                     "FROM orders o " +
                     "JOIN products p ON o.product_id = p.id " +
                     "WHERE o.user_id = ? AND o.status = 'cart' " +
                     "ORDER BY o.id ASC";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotalPrice(rs.getDouble("total_price"));
                item.setProductName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setImage(rs.getString("image"));
                item.setCategory(rs.getString("category"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Remove a single cart item by its order row id
    public boolean removeCartItem(int orderId, int userId) {
        String sql = "DELETE FROM orders WHERE id=? AND user_id=? AND status='cart'";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Clear entire cart for a user
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM orders WHERE user_id=? AND status='cart'";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // On checkout — mark all cart items as 'pending'
    public boolean checkoutCart(int userId) {
        String sql = "UPDATE orders SET status='pending' WHERE user_id=? AND status='cart'";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
