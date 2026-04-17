package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles logout — destroys session and clears the rememberedEmail cookie.
 * Note: the cookie is only cleared if "Remember Me" was NOT checked.
 * If it was checked, the cookie stays so email is pre-filled on next visit.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String REMEMBER_COOKIE = "rememberedEmail";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Destroy the session
        if (request.getSession(false) != null) {
            request.getSession().invalidate();
        }

        // Clear the rememberedEmail cookie on logout
        Cookie clearCookie = new Cookie(REMEMBER_COOKIE, "");
        clearCookie.setMaxAge(0); // delete immediately
        clearCookie.setPath(request.getContextPath() + "/");
        response.addCookie(clearCookie);

        response.sendRedirect(request.getContextPath() + "/login");
    }
}