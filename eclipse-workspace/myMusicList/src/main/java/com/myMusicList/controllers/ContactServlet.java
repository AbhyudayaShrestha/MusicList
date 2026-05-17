package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import com.myMusicList.model.UserModel;
import java.io.IOException;

// URL mapped in web.xml
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        // contact page is for regular users only
        if ("admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if ("admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        // read and trim all fields
        String name    = req.getParameter("name")    != null ? req.getParameter("name").trim()    : "";
        String email   = req.getParameter("email")   != null ? req.getParameter("email").trim()   : "";
        String subject = req.getParameter("subject") != null ? req.getParameter("subject").trim() : "";
        String message = req.getParameter("message") != null ? req.getParameter("message").trim() : "";

        // all fields required
        if (name.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            req.setAttribute("contactError", "All fields are required. Please fill in the form completely.");
            req.setAttribute("formName",    name);
            req.setAttribute("formEmail",   email);
            req.setAttribute("formSubject", subject);
            req.setAttribute("formMessage", message);
            req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(req, res);
            return;
        }

        // basic email format check
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            req.setAttribute("contactError", "Please enter a valid email address.");
            req.setAttribute("formName",    name);
            req.setAttribute("formEmail",   email);
            req.setAttribute("formSubject", subject);
            req.setAttribute("formMessage", message);
            req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(req, res);
            return;
        }

        req.setAttribute("contactSuccess", true);
        req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(req, res);
    }
}