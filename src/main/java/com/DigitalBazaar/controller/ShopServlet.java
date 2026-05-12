package com.DigitalBazaar.controller;

import com.DigitalBazaar.config.DBConfig;
import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;
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

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShopServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        
        if (user != null && "ADMIN".equals(user.getRole())) {
		    SessionUtil.invalidateSession(request);
		    response.sendRedirect(request.getContextPath() + "/shop");
		    return;
		}
        
        request.setAttribute("isLoggedIn", user != null);

        String category = request.getParameter("category");
        if (category != null && category.isEmpty()) category = null;

        int pageSize    = 12;
        int currentPage = 1;
        try { currentPage = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (currentPage < 1) currentPage = 1;

        try (Connection conn = DBConfig.getDbConnection()) {

            // Count
            StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1");
            if (category != null) countSql.append(" AND category = ?");

            int totalProducts = 0;
            try (PreparedStatement ps = conn.prepareStatement(countSql.toString())) {
                if (category != null) ps.setString(1, category);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) totalProducts = rs.getInt(1);
            }

            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (currentPage > totalPages) currentPage = totalPages;
            int offset = (currentPage - 1) * pageSize;

            // Fetch — when category is selected, load ALL products in that category (no page limit)
            // so JS brand filter can work across all of them
            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
            if (category != null) sql.append(" AND category = ?");
            sql.append(" ORDER BY id ASC");

            // Only apply LIMIT/OFFSET when no category filter (show all in category for JS filtering)
            if (category == null) sql.append(" LIMIT ? OFFSET ?");

            List<Product> products = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int idx = 1;
                if (category != null) {
                    ps.setString(idx++, category);
                } else {
                    ps.setInt(idx++, pageSize);
                    ps.setInt(idx++, offset);
                }
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                	Product p = new Product();
                	p.setId(rs.getInt("id"));
                	p.setName(rs.getString("name"));
                	p.setCategory(rs.getString("category"));
                	p.setPrice(rs.getDouble("price"));
                	p.setStock(rs.getInt("stock"));
                	p.setImage(rs.getString("image"));

                	String name = p.getName();
                	String brand = "";
                	if      (name.contains("RTX") || name.contains("GTX"))                                          brand = "NVIDIA";
                	else if (name.contains("RX ") || name.contains("Radeon"))                                        brand = "AMD";
                	else if (name.contains("Ryzen"))                                                                  brand = "AMD";
                	else if (name.contains("Arc"))                                                                    brand = "Intel";
                	else if (name.contains("Intel") || name.contains("i9") || name.contains("i7") || name.contains("i5") || name.contains("i3")) brand = "Intel";
                	else if (name.contains("G.Skill") || name.contains("GSkill"))                                   brand = "G.Skill";
                	else if (name.contains("Kingston"))                                                               brand = "Kingston";
                	else if (name.contains("ADATA"))                                                                  brand = "ADATA";
                	else if (name.contains("Samsung"))                                                                brand = "Samsung";
                	else if (name.contains("WD") || name.contains("Western Digital"))                               brand = "WD";
                	else if (name.contains("Seagate"))                                                                brand = "Seagate";
                	else if (name.contains("ASUS"))                                                                   brand = "ASUS";
                	else if (name.contains("MSI"))                                                                    brand = "MSI";
                	else if (name.contains("Gigabyte"))                                                               brand = "Gigabyte";
                	else if (name.contains("Noctua"))                                                                  brand = "Noctua";
                	else if (name.contains("NZXT"))                                                                    brand = "NZXT";
                	else if (name.contains("Seasonic"))                                                                brand = "Seasonic";
                	else if (name.contains("EVGA"))                                                                    brand = "EVGA";
                	else if (name.contains("Lian Li"))                                                                 brand = "Lian Li";
                	else if (name.contains("Fractal"))                                                                 brand = "Fractal";
                	else if (name.contains("Corsair"))                                                                 brand = "Corsair";
                	p.setBrand(brand);

                	products.add(p);
                }
            }

            request.setAttribute("products",    products);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages",  totalPages);
            request.setAttribute("category",    category);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Shop error: " + e.getMessage());
            return;
        }
        
        String sessionUsername = (user != null) ? user.getUsername() : null;
        String initials = "";
        if (sessionUsername != null && !sessionUsername.isEmpty()) {
            String[] parts = sessionUsername.trim().split("\\s+");
            if (parts.length >= 2) {
                initials = ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
            } else {
                initials = String.valueOf(parts[0].charAt(0)).toUpperCase();
            }
        }
        request.setAttribute("initials", initials);

        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}