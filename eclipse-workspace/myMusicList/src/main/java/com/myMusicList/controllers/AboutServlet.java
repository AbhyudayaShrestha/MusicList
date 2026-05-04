package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import com.myMusicList.model.UserModel;
import java.io.IOException;

// URL mapped explicitly in web.xml
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Admin has no About page — send them back to their dashboard
        if ("admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/pages/about.jsp").forward(req, res);
    }
}