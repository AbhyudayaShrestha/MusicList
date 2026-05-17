package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// kills the session and wipes the remember-me cookie
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String REMEMBER_COOKIE = "rememberedEmail";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession(false) != null) {
            request.getSession().invalidate();
        }

        // max-age 0 tells the browser to delete the cookie immediately
        Cookie clearCookie = new Cookie(REMEMBER_COOKIE, "");
        clearCookie.setMaxAge(0);
        clearCookie.setPath(request.getContextPath() + "/");
        response.addCookie(clearCookie);

        response.sendRedirect(request.getContextPath() + "/login");
    }
}