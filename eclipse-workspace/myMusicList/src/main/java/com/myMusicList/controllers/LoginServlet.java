package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import com.myMusicList.service.UserService;
import com.myMusicList.model.UserModel;

/**
 * Handles login with 3-attempt lockout (1 minute).
 *
 * FIX 1: Passes exact seconds remaining to JSP for countdown.
 * FIX 2: Never disables the email/password inputs — only disables the
 *         submit button so the user can still edit the email field or
 *         try a different account while locked.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String REMEMBER_COOKIE = "rememberedEmail";
    private static final int    COOKIE_MAX_AGE  = 7 * 24 * 60 * 60;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rememberedEmail = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (REMEMBER_COOKIE.equals(c.getName())) {
                    rememberedEmail = c.getValue();
                    break;
                }
            }
        }
        request.setAttribute("rememberedEmail", rememberedEmail);
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email      = request.getParameter("email");
        String password   = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Null-safety: if email is missing (shouldn't happen with our JSP fix,
        // but defensive coding)
        if (email == null) email = "";
        email = email.trim().toLowerCase();

        UserService service = new UserService();

        // ── Step 1: Check if account is currently locked ──────────────
        LocalDateTime lockedUntil = service.getLockoutTime(email);
        if (lockedUntil != null) {
            long secondsLeft = ChronoUnit.SECONDS.between(LocalDateTime.now(), lockedUntil);
            if (secondsLeft < 0) secondsLeft = 0;

            String timeStr = lockedUntil.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
            request.setAttribute("rememberedEmail",     email);
            request.setAttribute("error",               "Account locked. Too many failed attempts. Try again after " + timeStr + ".");
            request.setAttribute("locked",              true);
            request.setAttribute("lockSecondsRemaining", secondsLeft);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        // ── Step 2: Validate credentials ──────────────────────────────
        UserModel user = service.validateUser(email, password);

        if (user != null) {
            service.clearLockout(email);
            request.getSession().setAttribute("loggedUser", user);

            Cookie rememberCookie = new Cookie(REMEMBER_COOKIE, email);
            rememberCookie.setMaxAge("on".equals(rememberMe) ? COOKIE_MAX_AGE : 0);
            rememberCookie.setPath(request.getContextPath() + "/");
            response.addCookie(rememberCookie);

            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?loginSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?loginSuccess=true");
            }

        } else {
            // ── Step 3: Record failed attempt ─────────────────────────
            int attempts  = service.recordFailedAttempt(email);
            int remaining = Math.max(0, 3 - attempts);

            request.setAttribute("rememberedEmail", email);

            if (attempts >= 3) {
                // Just got locked — calculate seconds until unlock
                LocalDateTime lockExpiry = LocalDateTime.now().plusMinutes(1);
                long secondsLeft = ChronoUnit.SECONDS.between(LocalDateTime.now(), lockExpiry);
                String timeStr   = lockExpiry.format(DateTimeFormatter.ofPattern("HH:mm:ss"));

                request.setAttribute("error",               "Too many failed attempts. Account locked until " + timeStr + ".");
                request.setAttribute("locked",              true);
                request.setAttribute("lockSecondsRemaining", secondsLeft);
            } else {
                request.setAttribute("error", "Invalid email or password. " + remaining + " attempt(s) remaining before lockout.");
            }

            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }
}