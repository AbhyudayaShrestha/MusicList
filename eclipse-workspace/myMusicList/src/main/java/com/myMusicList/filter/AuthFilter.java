package com.myMusicList.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.myMusicList.model.UserModel;

// runs on every request — enforces login and role-based access
// public paths (login, register, forgot-password, static assets) pass straight through
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse res  = (HttpServletResponse) response;

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserModel loggedUser = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;

        boolean isPublic = path.equals("/login")
            || path.equals("/register")
            || path.equals("/forgot-password")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/images/");

        if (isPublic) {
            chain.doFilter(request, response);
        } else if (loggedUser == null) {
            // not logged in — redirect to login
            res.sendRedirect(req.getContextPath() + "/login");
        } else if (path.startsWith("/admin") && !"admin".equals(loggedUser.getRole())) {
            // regular user trying to hit an admin URL
            res.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}
}