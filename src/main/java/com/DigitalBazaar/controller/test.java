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

/**
 * Servlet implementation class test
 */
@WebServlet("/test")
public class test extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public test() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        request.getRequestDispatcher("/WEB-INF/pages/test.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
