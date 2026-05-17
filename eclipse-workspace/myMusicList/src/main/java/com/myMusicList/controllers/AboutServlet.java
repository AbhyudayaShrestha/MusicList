package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import com.myMusicList.model.UserModel;
import java.io.IOException;

// URL mapped in web.xml
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;

        // not logged in — send to login
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // admins go back to their dashboard, no about page for them
        if ("admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/pages/about.jsp").forward(req, res);
    }
}