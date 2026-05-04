package com.myMusicList.controllers;

import com.myMusicList.model.UserModel;
import com.myMusicList.service.UserService;
import com.myMusicList.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles user registration.
 * Now collects security question + answer for the forgot-password flow.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name             = request.getParameter("name");
        String email            = request.getParameter("email");
        String password         = request.getParameter("password");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer   = request.getParameter("securityAnswer");

        UserService service = new UserService();

        // ── Validation ────────────────────────────────────────────────
        if (!ValidationUtil.isValidName(name)) {
            request.setAttribute("error", "Name must be at least 2 characters.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 8 characters.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (securityQuestion == null || securityQuestion.trim().isEmpty()) {
            request.setAttribute("error", "Please select a security question.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (securityAnswer == null || securityAnswer.trim().length() < 2) {
            request.setAttribute("error", "Security answer must be at least 2 characters.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (service.emailExists(email)) {
            request.setAttribute("error", "That email address is already registered.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        // ── Create user ───────────────────────────────────────────────
        UserModel user = new UserModel();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(password);
        user.setSecurityQuestion(securityQuestion.trim());
        user.setSecurityAnswer(securityAnswer.trim());

        if (service.registerUser(user)) {
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }
}