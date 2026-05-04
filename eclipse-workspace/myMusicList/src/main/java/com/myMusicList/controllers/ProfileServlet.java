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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel sessionUser = (UserModel) request.getSession().getAttribute("loggedUser");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load full user record including security_question from DB
        UserService service = new UserService();
        UserModel fullUser = service.getUserWithSecurity(sessionUser.getId());
        if (fullUser != null) {
            request.setAttribute("fullUser", fullUser);
        }

        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        UserService service = new UserService();

        switch (action == null ? "" : action) {
            case "updateProfile":     handleProfileUpdate(request, response, user, service);     break;
            case "changePassword":    handlePasswordChange(request, response, user, service);    break;
            case "updateSecurity":    handleSecurityUpdate(request, response, user, service);    break;
            default: response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    // ── Update display name ───────────────────────────────────────────

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response,
                                     UserModel user, UserService service)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        if (name != null) name = name.trim();

        if (!ValidationUtil.isValidName(name)) {
            request.setAttribute("profileError", "Name must be at least 2 characters.");
            loadAndForward(request, response, user, service);
            return;
        }

        if (service.updateName(user.getId(), name)) {
            user.setName(name);
            request.getSession().setAttribute("loggedUser", user);
            request.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            request.setAttribute("profileError", "Update failed. Please try again.");
        }
        loadAndForward(request, response, user, service);
    }

    // ── Change password ───────────────────────────────────────────────

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response,
                                      UserModel user, UserService service)
            throws ServletException, IOException {

        String oldPw  = request.getParameter("oldPassword");
        String newPw  = request.getParameter("newPassword");
        String confPw = request.getParameter("confirmPassword");
        if (oldPw == null) oldPw = "";
        if (newPw == null) newPw = "";
        if (confPw == null) confPw = "";

        if (!service.verifyPassword(user.getId(), oldPw)) {
            request.setAttribute("pwError", "Current password is incorrect.");
            loadAndForward(request, response, user, service);
            return;
        }
        if (!ValidationUtil.isValidPassword(newPw)) {
            request.setAttribute("pwError", "New password must be at least 8 characters.");
            loadAndForward(request, response, user, service);
            return;
        }
        if (!newPw.equals(confPw)) {
            request.setAttribute("pwError", "Passwords do not match.");
            loadAndForward(request, response, user, service);
            return;
        }

        if (service.changePassword(user.getId(), newPw)) {
            request.setAttribute("pwSuccess", "Password changed successfully.");
        } else {
            request.setAttribute("pwError", "Failed to change password. Please try again.");
        }
        loadAndForward(request, response, user, service);
    }

    // ── Update / set security question ───────────────────────────────

    private void handleSecurityUpdate(HttpServletRequest request, HttpServletResponse response,
                                      UserModel user, UserService service)
            throws ServletException, IOException {

        String question = request.getParameter("securityQuestion");
        String answer   = request.getParameter("securityAnswer");

        if (question == null || question.trim().isEmpty()) {
            request.setAttribute("secError", "Please select a security question.");
            loadAndForward(request, response, user, service);
            return;
        }
        if (answer == null || answer.trim().length() < 2) {
            request.setAttribute("secError", "Answer must be at least 2 characters.");
            loadAndForward(request, response, user, service);
            return;
        }

        if (service.updateSecurityQuestion(user.getId(), question, answer)) {
            request.setAttribute("secSuccess", "Security question updated successfully.");
        } else {
            request.setAttribute("secError", "Failed to update. Please try again.");
        }
        loadAndForward(request, response, user, service);
    }

    // ── Helper: reload full user then forward ─────────────────────────

    private void loadAndForward(HttpServletRequest request, HttpServletResponse response,
                                UserModel user, UserService service)
            throws ServletException, IOException {
        UserModel fullUser = service.getUserWithSecurity(user.getId());
        request.setAttribute("fullUser", fullUser != null ? fullUser : user);
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }
}