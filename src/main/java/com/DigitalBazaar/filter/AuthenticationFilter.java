package com.DigitalBazaar.filter;

import com.DigitalBazaar.model.User;
import com.DigitalBazaar.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {
	    "/admin-dashboard",
	    "/admin-products",
	    "/manage-user",
	    "/cart/*",
	    "/checkout"
	})
	public class AuthenticationFilter implements Filter {

	    @Override
	    public void init(FilterConfig filterConfig) throws ServletException {}

	    @Override
	    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
	            throws IOException, ServletException {

	        HttpServletRequest  httpReq  = (HttpServletRequest)  request;
	        HttpServletResponse httpResp = (HttpServletResponse) response;

	        String uri = httpReq.getRequestURI();
	        String ctx = httpReq.getContextPath();

	        User user = (User) SessionUtil.getAttribute(httpReq, "user");

	        // ── ADMIN routes ──────────────────────────────────────────
	        if (uri.contains("/admin-dashboard") ||
	            uri.contains("/admin-products")  ||
	            uri.contains("/manage-user")) {

	            if (user == null || !"ADMIN".equals(user.getRole())) {
	                httpResp.sendRedirect(ctx + "/admin-login");
	                return;
	            }
	        }

	        // ── USER routes (cart / checkout) ─────────────────────────
	        if (uri.contains("/cart") || uri.contains("/checkout")) {
	            if (user == null) {
	                // If it's an AJAX/fetch request, return JSON instead of redirect
	                String requestedWith = httpReq.getHeader("X-Requested-With");
	                boolean isAjax = "XMLHttpRequest".equals(requestedWith);

	                // Cart uses fetch() so check Content-Type and Accept too
	                String accept = httpReq.getHeader("Accept");
	                boolean wantsJson = accept != null && accept.contains("application/json");

	                if (isAjax || wantsJson || uri.contains("/cart/")) {
	                    httpResp.setContentType("application/json");
	                    httpResp.setCharacterEncoding("UTF-8");
	                    httpResp.getWriter().write(
	                        "{\"success\":false,\"loggedIn\":false,\"message\":\"Please login first\"}"
	                    );
	                } else {
	                    httpResp.sendRedirect(ctx + "/login");
	                }
	                return;
	            }
	        }

	        chain.doFilter(request, response);
	    }

	    @Override
	    public void destroy() {}
	}