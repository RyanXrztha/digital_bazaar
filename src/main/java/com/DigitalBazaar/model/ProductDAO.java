package com.DigitalBazaar.model;

import com.DigitalBazaar.config.DBConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
	public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT id, name, category, price, stock, image, is_featured FROM products ORDER BY id ASC";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("ProductDAO.getAllProducts error: " + e.getMessage());
        }
        return list;
    }

    // -------------------------------------------------------
    // GET FEATURED PRODUCTS  (used by dashboard.jsp Best Sellers)
    // -------------------------------------------------------
	public List<Product> getFeaturedProducts() {
	    List<Product> list = new ArrayList<>();
	    String query = "SELECT p.id, p.name, p.category, p.price, p.stock, p.image, p.is_featured " +
	                   "FROM products p " +
	                   "LEFT JOIN orders o ON p.id = o.product_id " +
	                   "GROUP BY p.id, p.name, p.category, p.price, p.stock, p.image, p.is_featured " +
	                   "ORDER BY COUNT(o.id) DESC, p.id ASC " +
	                   "LIMIT 4";
	    try (Connection conn = DBConfig.getDbConnection();
	         PreparedStatement pstmt = conn.prepareStatement(query);
	         ResultSet rs = pstmt.executeQuery()) {
	        while (rs.next()) {
	            list.add(mapRow(rs));
	        }
	    } catch (SQLException | ClassNotFoundException e) {
	        System.err.println("ProductDAO.getFeaturedProducts error: " + e.getMessage());
	    }
	    return list;
	}
    
    public List<Product> getNewArrivals(int limit) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT id, name, category, price, stock, image, is_featured " +
                       "FROM products " +
                       "ORDER BY id DESC LIMIT ?";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("ProductDAO.getNewArrivals error: " + e.getMessage());
        }
        return list;
    }

    // -------------------------------------------------------
    // GET ALL PRODUCTS FOR ADMIN  (includes stock info)
    // -------------------------------------------------------
    public List<Product> getAllProductsForAdmin() {
        return getAllProducts(); // same query; admin dashboard uses stock column
    }

    // -------------------------------------------------------
    // MAP A ResultSet ROW → Product object
    // -------------------------------------------------------
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setCategory(rs.getString("category"));
        p.setPrice(rs.getDouble("price"));
        p.setStock(rs.getInt("stock"));
        p.setImage(rs.getString("image"));
        p.setFeatured(rs.getInt("is_featured") == 1);
        return p;
    }
    
    public Product getProductByName(String name) {
        String query = "SELECT id, name, category, price, stock, image, is_featured FROM products WHERE name = ? LIMIT 1";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("ProductDAO.getProductByName error: " + e.getMessage());
        }
        return null;
    }
    
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setImage(rs.getString("image"));
                p.setFeatured(rs.getBoolean("is_featured"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}