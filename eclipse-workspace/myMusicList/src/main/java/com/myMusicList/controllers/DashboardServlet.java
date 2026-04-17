package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.myMusicList.model.SongModel;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.SongService;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");

        SongService songService = new SongService();
        List<SongModel> songs = songService.getAllSongs();
        request.setAttribute("songs", songs);

        request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp")
               .forward(request, response);
    }
}