package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.DigitalBazaar.config.DBConfig;
import com.DigitalBazaar.model.OrderDAO;
import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.ProductDAO;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class CheckoutController
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckoutServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(request.getContextPath() + "/shop");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) SessionUtil.getAttribute(request, "user");

        String[] productNames = request.getParameterValues("productName");
        String[] quantities   = request.getParameterValues("quantity");
        String[] totalPrices  = request.getParameterValues("totalPrice");

        if (productNames == null || productNames.length == 0) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        OrderDAO   orderDAO   = new OrderDAO();
        ProductDAO productDAO = new ProductDAO();
        boolean allSuccess = true;
        for (int i = 0; i < productNames.length; i++) {
            try {
                Product p = productDAO.getProductByName(productNames[i]);
                if (p == null) { allSuccess = false; continue; }

                int qty = Integer.parseInt(quantities[i]);

                // ── Stock check BEFORE placing order ──
                if (p.getStock() < qty) {
                    allSuccess = false;
                    continue; // skip this item, not enough stock
                }

                double totalPrice = p.getPrice() * qty;
                boolean ok = orderDAO.placeOrder(user.getId(), p.getId(), qty, totalPrice);

                if (ok) {
                    // Decrement stock only if order was placed successfully
                    String updateStock = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
                    try (Connection conn2 = DBConfig.getDbConnection();
                         PreparedStatement ps = conn2.prepareStatement(updateStock)) {
                        ps.setInt(1, qty);
                        ps.setInt(2, p.getId());
                        ps.setInt(3, qty);
                        int rows = ps.executeUpdate();
                        if (rows == 0) {
                            // Stock ran out between check and update (race condition)
                            allSuccess = false;
                        }
                    } catch (Exception e) {
                        System.err.println("Stock update error: " + e.getMessage());
                        allSuccess = false;
                    }
                } else {
                    allSuccess = false;
                }

            } catch (NumberFormatException e) {
                System.err.println("CheckoutController parse error: " + e.getMessage());
                allSuccess = false;
            }
        }

        try {
            new com.DigitalBazaar.model.CartDAO().clearCart(user.getId());
        } catch (Exception e) {
            System.err.println("Cart clear error: " + e.getMessage());
        }

        if (allSuccess) {
            response.sendRedirect(request.getContextPath() + "/dashboard?orderSuccess=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/shop?orderError=true");
        }
    }
}
