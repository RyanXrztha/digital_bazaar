package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.ProductDAO;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class test
 */
@WebServlet("/build-pc")
public class BuildPcServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BuildPcServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) SessionUtil.getAttribute(request, "user");
		
		if (user != null && "ADMIN".equals(user.getRole())) {
		    SessionUtil.invalidateSession(request);
		    response.sendRedirect(request.getContextPath() + "/build-pc");
		    return;
		}
		
		request.setAttribute("isLoggedIn", user != null);
		
		ProductDAO dao = new ProductDAO();
        List<Product> allProducts = dao.getAllProducts();

        // 2. Group by category
        Map<String, List<Product>> byCategory = new LinkedHashMap<>();
        for (Product p : allProducts) {
            byCategory
                .computeIfAbsent(p.getCategory(), k -> new ArrayList<>())
                .add(p);
        }

        // 3. Pass to JSP
        request.setAttribute("productsByCategory", byCategory);
        
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
        
        
        request.getRequestDispatcher("/WEB-INF/pages/build-pc.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
