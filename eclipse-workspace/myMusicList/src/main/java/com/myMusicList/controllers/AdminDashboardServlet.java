package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.myMusicList.model.UserModel;
import com.myMusicList.model.SongModel;
import com.myMusicList.service.SongService;
import com.myMusicList.service.UserService;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        
     // Get which tab is active, default to songs
        String tab = request.getParameter("tab");
        if (tab == null) tab = "songs";
        request.setAttribute("activeTab", tab);

        SongService songService = new SongService();
        UserService userService = new UserService();

        if ("songs".equals(tab)) {
            request.setAttribute("songs", songService.getAllSongs());
        } else if ("users".equals(tab)) {
            request.setAttribute("users", userService.getAllUsers());
        }

        request.getRequestDispatcher("/WEB-INF/pages/admin.jsp")
               .forward(request, response);
    }
}