package com.DigitalBazaar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.DigitalBazaar.model.Product;
import com.DigitalBazaar.model.ProductDAO;

/**
 * Servlet implementation class PCBuilderController
 */
@WebServlet("/pcbuilder")
public class PCBuilderController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PCBuilderController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDAO dao = new ProductDAO();
        List<Product> allProducts = dao.getAllProducts();

        // Group products by category so JSP can build per-category dropdowns
        Map<String, List<Product>> byCategory = allProducts.stream()
        	    .collect(Collectors.groupingBy(
        	        Product::getCategory,
        	        LinkedHashMap::new,
        	        Collectors.toList()
        	    ));

        request.setAttribute("productsByCategory", byCategory);
        request.setAttribute("allProducts", allProducts);
        
        request.getRequestDispatcher("/WEB-INF/pages/pcBuilder.jsp")
               .forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
