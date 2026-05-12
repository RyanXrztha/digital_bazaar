package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import com.DigitalBazaar.model.ProductDAO;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class DashboardController
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DashboardServlet() {
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
		    response.sendRedirect(request.getContextPath() + "/dashboard");
		    return;
		}
		
		request.setAttribute("isLoggedIn", user != null);

		String orderSuccess = request.getParameter("orderSuccess");
		String orderError   = request.getParameter("orderError");
		if ("true".equals(orderSuccess)) request.setAttribute("orderSuccess", true);
		if ("true".equals(orderError))   request.setAttribute("orderError", true);

		// Fetch products for dashboard sections
		ProductDAO dao = new ProductDAO();
		request.setAttribute("bestSellers", dao.getFeaturedProducts());
		request.setAttribute("newArrivals", dao.getNewArrivals(8));
		
		// Order history
		if (user != null) {
		    com.DigitalBazaar.model.OrderDAO orderDAO = new com.DigitalBazaar.model.OrderDAO();
		    request.setAttribute("orderHistory", orderDAO.getOrdersByUser(user.getId()));
		}
		
		User userObj = (User) SessionUtil.getAttribute(request, "user");
		String sessionUsername = (userObj != null) ? userObj.getUsername() : null;
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

		request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
