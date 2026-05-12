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

import com.DigitalBazaar.config.DBConfig;
import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class OrderController
 */
@WebServlet("/admin-products")
public class AdminProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminProductServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		List<Product> productList = new ArrayList<>();
        int lowStockCount = 0;

        String query = "SELECT * FROM products";

        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setImage(rs.getString("image"));
                p.setFeatured(rs.getBoolean("is_featured")); // fixed column name
                productList.add(p);

                if (p.getStock() < 10) {
                    lowStockCount++;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("productList", productList);
        request.setAttribute("totalItems",  productList.size());
        request.setAttribute("lowStockCount", lowStockCount);

        request.getRequestDispatcher("/WEB-INF/pages/admin-product-management.jsp")
                .forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

        try (Connection conn = DBConfig.getDbConnection()) {

            if ("add".equals(action)) {
                String sql = "INSERT INTO products (name, category, price, stock, image, is_featured) " +
                             "VALUES (?, ?, ?, ?, ?, 0)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("name"));
                    ps.setString(2, request.getParameter("category"));
                    ps.setDouble(3, Double.parseDouble(request.getParameter("price")));
                    ps.setInt(4,    Integer.parseInt(request.getParameter("stock")));
                    ps.setString(5, request.getParameter("image"));
                    ps.executeUpdate();
                }

            } else if ("edit".equals(action)) {
                String sql = "UPDATE products SET name=?, category=?, price=?, stock=?, image=? WHERE id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("name"));
                    ps.setString(2, request.getParameter("category"));
                    ps.setDouble(3, Double.parseDouble(request.getParameter("price")));
                    ps.setInt(4,    Integer.parseInt(request.getParameter("stock")));
                    ps.setString(5, request.getParameter("image"));
                    ps.setInt(6,    Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                }

            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM products WHERE id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to GET to reload the updated list
        response.sendRedirect(request.getContextPath() + "/admin-products");
	}

}
