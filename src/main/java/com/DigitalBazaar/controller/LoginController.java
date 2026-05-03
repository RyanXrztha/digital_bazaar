package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.DigitalBazaar.util.SessionUtil;
import com.DigitalBazaar.util.CookieUtil;

import com.DigitalBazaar.model.User;
import com.DigitalBazaar.model.UserDAO;

/**
 * Servlet implementation class LoginController
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
	    String password = request.getParameter("password");

	    UserDAO dao = new UserDAO();

	    // Check if username exists first
	    if (!dao.isUsernameExists(username)) {
	        request.setAttribute("error", "User not found. Please register first.");
	        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	        return;
	    }

	    User user = dao.validateUser(username, password);

	    if (user != null) {

	        // ✅ CREATE SESSION
	        SessionUtil.setAttribute(request, "user", user);

	        // ✅ OPTIONAL COOKIE (remember user)
	        CookieUtil.addCookie(response, "username", user.getUsername(), 60 * 60);

	        // ✅ REDIRECT (NOT forward)
	        response.sendRedirect(request.getContextPath() + "/dashboard");
	        
	        dao.updateLastLogin(user.getId());

	    } else {
	        request.setAttribute("error", "Incorrect password.");
	        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	    }
	}
}
