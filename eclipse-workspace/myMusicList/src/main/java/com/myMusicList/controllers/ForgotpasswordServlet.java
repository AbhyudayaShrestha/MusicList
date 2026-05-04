package com.myMusicList.controllers;

import com.myMusicList.service.UserService;
import com.myMusicList.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 3-step forgot password flow (security question method):
 *
 * Step 1 → user enters their email
 * Step 2 → user answers their security question
 * Step 3 → user sets a new password
 */
@WebServlet("/forgot-password")
public class ForgotpasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String SESSION_EMAIL    = "fp_email";
    private static final String SESSION_VERIFIED = "fp_verified";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().removeAttribute(SESSION_EMAIL);
        request.getSession().removeAttribute(SESSION_VERIFIED);
        request.setAttribute("step", 1);
        forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        switch (step == null ? "" : step) {
            case "1": handleStep1(request, response); break;
            case "2": handleStep2(request, response); break;
            case "3": handleStep3(request, response); break;
            default:  response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    // ── Step 1: Find account ──────────────────────────────────────────

    private void handleStep1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email != null) email = email.trim().toLowerCase();

        UserService service = new UserService();

        // FIX: Check email existence separately from security question existence.
        // Previously, if the email existed but had no security question (NULL),
        // it would say "email not found" — which is wrong and confusing.
        if (email == null || email.isEmpty() || !service.emailExists(email)) {
            request.setAttribute("step", 1);
            request.setAttribute("error", "No account found with that email address.");
            forward(request, response);
            return;
        }

        String question = service.getSecurityQuestion(email);

        // Email exists but no security question set (old account before the feature)
        if (question == null || question.trim().isEmpty()) {
            request.setAttribute("step", 1);
            request.setAttribute("error",
                "This account does not have a security question set up. " +
                "Please contact support or re-register to use this feature.");
            forward(request, response);
            return;
        }

        request.getSession().setAttribute(SESSION_EMAIL, email);
        request.setAttribute("step",     2);
        request.setAttribute("email",    email);
        request.setAttribute("question", question);
        forward(request, response);
    }

    // ── Step 2: Verify security answer ───────────────────────────────

    private void handleStep2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute(SESSION_EMAIL);
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String answer = request.getParameter("answer");
        UserService service = new UserService();

        if (answer == null || answer.trim().isEmpty()) {
            request.setAttribute("step",     2);
            request.setAttribute("email",    email);
            request.setAttribute("question", service.getSecurityQuestion(email));
            request.setAttribute("error",    "Please enter your answer.");
            forward(request, response);
            return;
        }

        if (!service.verifySecurityAnswer(email, answer)) {
            request.setAttribute("step",     2);
            request.setAttribute("email",    email);
            request.setAttribute("question", service.getSecurityQuestion(email));
            request.setAttribute("error",    "Incorrect answer. Please try again.");
            forward(request, response);
            return;
        }

        request.getSession().setAttribute(SESSION_VERIFIED, true);
        request.setAttribute("step",  3);
        request.setAttribute("email", email);
        forward(request, response);
    }

    // ── Step 3: Set new password ──────────────────────────────────────

    private void handleStep3(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String  email    = (String)  request.getSession().getAttribute(SESSION_EMAIL);
        Boolean verified = (Boolean) request.getSession().getAttribute(SESSION_VERIFIED);

        if (email == null || !Boolean.TRUE.equals(verified)) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (newPassword == null)     newPassword = "";
        if (confirmPassword == null) confirmPassword = "";

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("step",  3);
            request.setAttribute("email", email);
            request.setAttribute("error", "Password must be at least 8 characters.");
            forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("step",  3);
            request.setAttribute("email", email);
            request.setAttribute("error", "Passwords do not match.");
            forward(request, response);
            return;
        }

        UserService service = new UserService();
        boolean reset = service.resetPassword(email, newPassword);

        request.getSession().removeAttribute(SESSION_EMAIL);
        request.getSession().removeAttribute(SESSION_VERIFIED);

        if (reset) {
            response.sendRedirect(request.getContextPath() + "/login?passwordReset=true");
        } else {
            request.setAttribute("step",  3);
            request.setAttribute("email", email);
            request.setAttribute("error", "Something went wrong. Please try again.");
            forward(request, response);
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(req, res);
    }
}