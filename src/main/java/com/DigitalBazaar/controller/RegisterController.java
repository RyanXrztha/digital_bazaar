package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.DigitalBazaar.model.User;
import com.DigitalBazaar.model.UserDAO;

/**
 * Servlet implementation class RegisterController
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fullname = request.getParameter("fullname");
	    String username = request.getParameter("username");
	    String password = request.getParameter("password");
	    String confirmPassword = request.getParameter("confirmPassword");

	    UserDAO dao = new UserDAO();

	    // 1. Empty fields
	    if (fullname == null || fullname.trim().isEmpty() ||
	        username == null || username.trim().isEmpty() ||
	        password == null || password.trim().isEmpty()) {

	        request.setAttribute("error", "All fields are required.");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	        return;
	    }

	    // 2. Password mismatch
	    if (!password.equals(confirmPassword)) {
	        request.setAttribute("error", "Passwords do not match.");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	        return;
	    }

	    // 3. Username already exists
	    if (dao.isUsernameExists(username)) {
	        request.setAttribute("error", "Username already exists. Try another.");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	        return;
	    }

	    // 4. Save user
	    User user = new User();
	    user.setFullname(fullname);
	    user.setUsername(username);
	    user.setPassword(password);

	    boolean success = dao.registerUser(user);

	    if (success) {
	        // redirect with success message
	        response.sendRedirect(request.getContextPath() + "/login?success=registered");
	    } else {
	        request.setAttribute("error", "Registration failed.");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	    }
    }
}
