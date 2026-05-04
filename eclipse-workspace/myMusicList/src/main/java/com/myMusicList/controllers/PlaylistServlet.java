package com.myMusicList.controllers;

import com.myMusicList.model.UserModel;
import com.myMusicList.model.PlaylistModel;
import com.myMusicList.service.PlaylistService;
import com.myMusicList.service.SongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Handles add/remove playlist actions AND serves the /playlist page.
 *
 * GET  /playlist          → display the user's playlist page
 * POST /playlist (add)    → add song, redirect to dashboard
 * POST /playlist (remove) → remove song, redirect back to caller (dashboard or playlist)
 */
@WebServlet("/playlist")
public class PlaylistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** GET → serve the My Playlist page */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PlaylistService ps = new PlaylistService();
        List<PlaylistModel> playlist = ps.getPlaylistByUser(user.getId());
        request.setAttribute("playlist", playlist);
        request.getRequestDispatcher("/WEB-INF/pages/playlist.jsp").forward(request, response);
    }

    /** POST → add or remove a song from the playlist */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action     = request.getParameter("action");
        String songIdStr  = request.getParameter("songId");
        String redirectTo = request.getParameter("redirect"); // "playlist" or null (→ dashboard)

        if (songIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int songId = Integer.parseInt(songIdStr);
            PlaylistService service = new PlaylistService();
            String backUrl = "playlist".equals(redirectTo)
                    ? request.getContextPath() + "/playlist"
                    : request.getContextPath() + "/dashboard";

            if ("add".equals(action)) {
                boolean added = service.addToPlaylist(user.getId(), songId);
                response.sendRedirect(backUrl + "?playlistMsg=" + (added ? "added" : "already"));

            } else if ("remove".equals(action)) {
                service.removeFromPlaylist(user.getId(), songId);
                response.sendRedirect(backUrl + "?playlistMsg=removed");

            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}