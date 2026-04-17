package com.myMusicList.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.myMusicList.model.UserModel;

/**
 * Authentication and Authorization Filter.
 * Intercepts every request before it reaches a servlet.
 * Ensures only authenticated users can access protected pages,
 * and only admins can access admin pages.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    /**
     * Checks each incoming request:
     * - Public paths (login, register, css) are allowed through freely.
     * - Unauthenticated users are redirected to the login page.
     * - Non-admin users trying to access /admin pages are redirected to dashboard.
     * - All other authenticated requests are allowed through.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);

        // Get logged in user from session if exists
        UserModel loggedUser = (session != null) ?
            (UserModel) session.getAttribute("loggedUser") : null;

        // Define paths that don't require login
        boolean isPublicPath = path.equals("/login")
            || path.equals("/register")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/images/");

        if (isPublicPath) {
            // No authentication needed — let through
            chain.doFilter(request, response);

        } else if (loggedUser == null) {
            // Not logged in — redirect to login page
            res.sendRedirect(req.getContextPath() + "/login");

        } else if (path.startsWith("/admin") && !"admin".equals(loggedUser.getRole())) {
            // Logged in as regular user trying to access admin area — block
            res.sendRedirect(req.getContextPath() + "/dashboard");

        } else {
            // Authenticated and authorized — allow through
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {}
}