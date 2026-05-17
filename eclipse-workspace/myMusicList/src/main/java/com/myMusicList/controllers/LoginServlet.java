package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import com.myMusicList.service.UserService;
import com.myMusicList.model.UserModel;

// login with 3-strike lockout (1 min cooldown)
// uses PRG pattern — error state goes into session so a page refresh doesn't resubmit
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String REMEMBER_COOKIE = "rememberedEmail";
    private static final int    COOKIE_MAX_AGE  = 7 * 24 * 60 * 60; // 7 days in seconds

    // session keys for passing error state from doPost to doGet
    private static final String SESS_ERROR   = "loginError";
    private static final String SESS_LOCKED  = "loginLocked";
    private static final String SESS_SECONDS = "loginLockSeconds";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // back-button after logout must hit the server, not the browser cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // already logged in — send them to the right place
        HttpSession session = request.getSession(false);
        if (session != null) {
            UserModel loggedUser = (UserModel) session.getAttribute("loggedUser");
            if (loggedUser != null) {
                if ("admin".equals(loggedUser.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
                return;
            }
        }

        // pick up any error the POST put in the session, then wipe it (one-time read)
        if (session != null) {
            String  error       = (String)  session.getAttribute(SESS_ERROR);
            Boolean locked      = (Boolean) session.getAttribute(SESS_LOCKED);
            Long    secondsLeft = (Long)    session.getAttribute(SESS_SECONDS);

            session.removeAttribute(SESS_ERROR);
            session.removeAttribute(SESS_LOCKED);
            session.removeAttribute(SESS_SECONDS);

            if (error != null) {
                request.setAttribute("error",                error);
                request.setAttribute("locked",               locked);
                request.setAttribute("lockSecondsRemaining", secondsLeft != null ? secondsLeft : 0L);
            }
        }

        // pre-fill the email field if remember me was used last time
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

        if (email == null) email = "";
        email = email.trim().toLowerCase();

        UserService service = new UserService();

        // check lockout before even trying the password
        LocalDateTime lockedUntil = service.getLockoutTime(email);
        if (lockedUntil != null) {
            long secondsLeft = ChronoUnit.SECONDS.between(LocalDateTime.now(), lockedUntil);
            if (secondsLeft < 0) secondsLeft = 0;
            String timeStr = lockedUntil.format(DateTimeFormatter.ofPattern("HH:mm:ss"));

            HttpSession session = request.getSession();
            session.setAttribute(SESS_ERROR,   "Account locked. Too many failed attempts. Try again after " + timeStr + ".");
            session.setAttribute(SESS_LOCKED,  true);
            session.setAttribute(SESS_SECONDS, secondsLeft);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserModel user = service.validateUser(email, password);

        if (user != null) {
            service.clearLockout(email);
            request.getSession().setAttribute("loggedUser", user);

            // set or clear the remember-me cookie depending on the checkbox
            Cookie rememberCookie = new Cookie(REMEMBER_COOKIE, email);
            rememberCookie.setMaxAge("on".equals(rememberMe) ? COOKIE_MAX_AGE : 0);
            rememberCookie.setPath(request.getContextPath() + "/");
            rememberCookie.setHttpOnly(true);
            response.addCookie(rememberCookie);

            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?loginSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?loginSuccess=true");
            }

        } else {
            int attempts  = service.recordFailedAttempt(email);
            int remaining = Math.max(0, 3 - attempts);

            HttpSession session = request.getSession();

            if (attempts >= 3) {
                LocalDateTime lockExpiry = LocalDateTime.now().plusMinutes(1);
                long secondsLeft = ChronoUnit.SECONDS.between(LocalDateTime.now(), lockExpiry);
                String timeStr   = lockExpiry.format(DateTimeFormatter.ofPattern("HH:mm:ss"));

                session.setAttribute(SESS_ERROR,   "Too many failed attempts. Account locked until " + timeStr + ".");
                session.setAttribute(SESS_LOCKED,  true);
                session.setAttribute(SESS_SECONDS, secondsLeft);
            } else {
                session.setAttribute(SESS_ERROR,   "Invalid email or password. " + remaining + " attempt(s) remaining before lockout.");
                session.setAttribute(SESS_LOCKED,  false);
                session.setAttribute(SESS_SECONDS, 0L);
            }

            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}