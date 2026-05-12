package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

import com.DigitalBazaar.config.DBConfig;
import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;

/**
 * Servlet implementation class AdminLoginController
 */
@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		User existing = (User) SessionUtil.getAttribute(request, "user");
        if (existing != null && "ADMIN".equals(existing.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        
        
		request.getRequestDispatcher("/WEB-INF/pages/admin-login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    String username = request.getParameter("username");
	    String password = request.getParameter("password");

	    System.out.println("=== ADMIN LOGIN ATTEMPT ===");
	    System.out.println("Username: [" + username + "]");
	    System.out.println("Password length: " + (password != null ? password.length() : "null"));

	    if (username == null || username.trim().isEmpty() ||
	        password == null || password.trim().isEmpty()) {
	        request.setAttribute("error", "Username and password are required");
	        request.getRequestDispatcher("/WEB-INF/pages/admin-login.jsp").forward(request, response);
	        return;
	    }

	    try (Connection conn = DBConfig.getDbConnection();
	         PreparedStatement ps = conn.prepareStatement(
	             "SELECT id, username, password FROM admins WHERE username = ?")) {

	        ps.setString(1, username.trim());
	        System.out.println("Querying for username: [" + username.trim() + "]");

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                String storedHash = rs.getString("password");
	                System.out.println("Found user. Hash from DB: [" + storedHash + "]");
	                System.out.println("Hash length: " + storedHash.length());
	                System.out.println("Password to check: [" + password.trim() + "]");

	                boolean match = BCrypt.checkpw(password.trim(), storedHash);
	                System.out.println("BCrypt match result: " + match);

	                if (match) {
	                    User user = new User();
	                    user.setId(rs.getInt("id"));
	                    user.setUsername(rs.getString("username"));
	                    user.setFullname("Administrator");
	                    user.setEmail("");
	                    user.setRole("ADMIN");
	                    user.setStatus("ACTIVE");
	                    SessionUtil.setAttribute(request, "user", user);
	                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
	                } else {
	                    System.out.println("Password mismatch!");
	                    request.setAttribute("error", "Invalid username or password");
	                    request.getRequestDispatcher("/WEB-INF/pages/admin-login.jsp").forward(request, response);
	                }
	            } else {
	                System.out.println("No user found with username: [" + username.trim() + "]");
	                request.setAttribute("error", "Invalid username or password");
	                request.getRequestDispatcher("/WEB-INF/pages/admin-login.jsp").forward(request, response);
	            }
	        }
	    } catch (Exception e) {
	        System.out.println("EXCEPTION: " + e.getMessage());
	        e.printStackTrace();
	        request.setAttribute("error", "Server error: " + e.getMessage());
	        request.getRequestDispatcher("/WEB-INF/pages/admin-login.jsp").forward(request, response);
	    }
	}

}
