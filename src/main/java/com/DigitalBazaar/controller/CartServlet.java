package com.DigitalBazaar.controller;

import com.DigitalBazaar.model.CartDAO;
import com.DigitalBazaar.model.CartItem;
import com.DigitalBazaar.model.ProductDAO;
import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET /cart/items — returns cart as JSON for page load
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        User user = (User) SessionUtil.getAttribute(request, "user");

        CartDAO dao = new CartDAO();
        List<CartItem> items = dao.getCartItems(user.getId());

        StringBuilder sb = new StringBuilder();
        sb.append("{\"loggedIn\":true,\"items\":[");
        for (int i = 0; i < items.size(); i++) {
            CartItem c = items.get(i);
            sb.append("{");
            sb.append("\"id\":").append(c.getId()).append(",");
            sb.append("\"productId\":").append(c.getProductId()).append(",");
            sb.append("\"name\":\"").append(escape(c.getProductName())).append("\",");
            sb.append("\"category\":\"").append(escape(c.getCategory())).append("\",");
            sb.append("\"price\":").append(c.getPrice()).append(",");
            sb.append("\"quantity\":").append(c.getQuantity()).append(",");
            sb.append("\"totalPrice\":").append(c.getTotalPrice()).append(",");
            sb.append("\"image\":\"").append(escape(c.getImage())).append("\"");
            sb.append("}");
            if (i < items.size() - 1) sb.append(",");
        }
        sb.append("]}");
        out.print(sb.toString());
    }

    // POST /cart/add      — add item
    // POST /cart/remove   — remove one item
    // POST /cart/clear    — clear entire cart
    // POST /cart/checkout — mark all as pending
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	System.out.println("PATH INFO: " + request.getPathInfo());
    	System.out.println("PRODUCT ID PARAM: " + request.getParameter("productId"));
    	
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        User user = (User) SessionUtil.getAttribute(request, "user");

        String path = request.getPathInfo();
        CartDAO cartDAO = new CartDAO();

        if ("/add".equals(path)) {
            String productIdStr = request.getParameter("productId");
            String qtyStr = request.getParameter("quantity");

            if (productIdStr == null || productIdStr.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Missing productId\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;

            ProductDAO productDAO = new ProductDAO();
            Product p = productDAO.getProductById(productId);

            if (p == null) {
                out.print("{\"success\":false,\"message\":\"Product not found for id: " + productId + "\"}");
                return;
            }

            boolean ok = cartDAO.addToCart(user.getId(), productId, qty, p.getPrice());

            if (!ok) {
                int stock = p.getStock();
                int inCart = cartDAO.getCartQuantity(user.getId(), productId);
                String msg = "Only " + stock + " in stock" +
                             (inCart > 0 ? " (" + inCart + " already in your cart)" : "");
                out.print("{\"success\":false,\"message\":\"" + msg + "\"}");
                return;
            }

            out.print("{\"success\":true}");

        } else if ("/remove".equals(path)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            boolean ok = cartDAO.removeCartItem(orderId, user.getId());
            out.print("{\"success\":" + ok + "}");

        } else if ("/clear".equals(path)) {
            boolean ok = cartDAO.clearCart(user.getId());
            out.print("{\"success\":" + ok + "}");

        } else if ("/checkout".equals(path)) {
            boolean ok = cartDAO.checkoutCart(user.getId());
            out.print("{\"success\":" + ok + "}");

        } else {
            out.print("{\"success\":false,\"message\":\"Unknown action\"}");
        }
    }

    // Escape special characters for JSON string values
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
