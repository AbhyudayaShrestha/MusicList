package com.myMusicList.controllers;

import com.myMusicList.model.SongModel;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.QueueService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

// shows the user's listening history — persisted in DB, not just the session
// songs appear here when you press play in the queue
public class RecentlyPlayedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QueueService queueService = new QueueService();
        List<SongModel> recentList = queueService.loadRecentlyPlayed(user.getId());

        request.setAttribute("recentList", recentList);
        request.getSession().setAttribute("recentlyPlayedList", recentList);

        request.getRequestDispatcher("/WEB-INF/pages/recentlyPlayed.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("clear".equals(request.getParameter("action"))) {
            QueueService queueService = new QueueService();
            queueService.clearRecentlyPlayed(user.getId());
            request.getSession().removeAttribute("recentlyPlayedList");
        }

        response.sendRedirect(request.getContextPath() + "/recentlyPlayed");
    }
}