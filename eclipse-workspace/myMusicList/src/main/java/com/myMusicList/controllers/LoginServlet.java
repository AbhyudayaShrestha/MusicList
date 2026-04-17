package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myMusicList.service.UserService;
import com.myMusicList.model.UserModel;

/**
 * Handles user login — GET loads the form, POST validates credentials.
 * Cookie: reads rememberedEmail on GET to pre-fill email field.
 *         sets/clears rememberedEmail on POST based on "remember me" checkbox.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String REMEMBER_COOKIE = "rememberedEmail";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 days in seconds

    /**
     * Loads the login page.
     * Reads the rememberedEmail cookie and passes it as a request attribute
     * so the JSP can pre-fill the email input.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rememberedEmail = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_COOKIE.equals(cookie.getName())) {
                    rememberedEmail = cookie.getValue();
                    break;
                }
            }
        }
        // Pass to JSP so it can pre-fill the email field
        request.setAttribute("rememberedEmail", rememberedEmail);

        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    /**
     * Validates email and password against the database.
     * On success: creates session, handles remember-me cookie, redirects by role.
     * On failure: shows error message on login page.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email      = request.getParameter("email");
        String password   = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe"); // checkbox value

        UserService service = new UserService();
        UserModel user = service.validateUser(email, password);

        if (user != null) {
            // Store logged-in user in session
            request.getSession().setAttribute("loggedUser", user);

            // Handle Remember Me cookie
            Cookie rememberCookie = new Cookie(REMEMBER_COOKIE, email);
            if ("on".equals(rememberMe)) {
                rememberCookie.setMaxAge(COOKIE_MAX_AGE); // persist for 7 days
            } else {
                rememberCookie.setMaxAge(0); // delete the cookie if unchecked
            }
            rememberCookie.setPath(request.getContextPath() + "/");
            response.addCookie(rememberCookie);

            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?loginSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?loginSuccess=true");
            }
        } else {
            // Pass remembered email back so the form stays filled even on error
            request.setAttribute("rememberedEmail", email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }
}