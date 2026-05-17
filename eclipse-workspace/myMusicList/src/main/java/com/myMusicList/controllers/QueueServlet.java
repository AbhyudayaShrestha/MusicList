package com.myMusicList.controllers;

import com.myMusicList.model.SongModel;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.QueueService;
import com.myMusicList.service.SongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

// play queue — stored in DB so it survives logout
// hitting "play" dequeues the first song and adds it to recently played
public class QueueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        if (search == null) search = "";

        SongService songService = new SongService();
        List<SongModel> allSongs = songService.searchAndSort(search.trim(), "title");

        QueueService queueService = new QueueService();
        LinkedList<SongModel> queue = queueService.loadQueue(user.getId());

        // keep session copy in sync for JSP access
        request.getSession().setAttribute("songQueue", queue);
        request.setAttribute("allSongs", allSongs);
        request.setAttribute("search",   search);

        request.getRequestDispatcher("/WEB-INF/pages/queue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QueueService queueService = new QueueService();
        String action = request.getParameter("action");
        String msg    = "";

        if ("add".equals(action)) {
            int songId = parseSongId(request);
            if (songId > 0) {
                boolean added = queueService.addToQueue(user.getId(), songId);
                msg = added ? "added" : "alreadyInQueue";
            }

        } else if ("remove".equals(action)) {
            int songId = parseSongId(request);
            if (songId > 0) {
                queueService.removeFromQueue(user.getId(), songId);
                msg = "removed";
            }

        } else if ("play".equals(action)) {
            // pop front song and record it as recently played
            SongModel played = queueService.playNext(user.getId());
            msg = (played != null) ? "played" : "emptyQueue";

        } else if ("clear".equals(action)) {
            queueService.clearQueue(user.getId());
            msg = "cleared";
        }

        request.getSession().setAttribute("songQueue", queueService.loadQueue(user.getId()));
        response.sendRedirect(request.getContextPath() + "/queue?queueMsg=" + msg);
    }

    private int parseSongId(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("songId"));
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}