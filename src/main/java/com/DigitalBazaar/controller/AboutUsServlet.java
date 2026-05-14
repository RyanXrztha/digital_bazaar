package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class AboutUsController
 */
@WebServlet("/about-us")
public class AboutUsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AboutUsServlet() {
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
            response.sendRedirect(request.getContextPath() + "/about-us");
            return;
        }
        
        request.setAttribute("isLoggedIn", user != null);

        boolean hasOrders = false;
        if (user != null) {
            java.util.List<java.util.Map<String, Object>> orders =
                new com.DigitalBazaar.model.OrderDAO().getOrdersByUser(user.getId());
            hasOrders = orders != null && !orders.isEmpty();
        }
        request.setAttribute("hasOrders", hasOrders);
        
        
        request.getRequestDispatcher("/WEB-INF/pages/about-us.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
