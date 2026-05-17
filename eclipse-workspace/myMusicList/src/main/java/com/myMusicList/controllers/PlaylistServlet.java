package com.myMusicList.controllers;

import com.myMusicList.model.UserModel;
import com.myMusicList.model.PlaylistModel;
import com.myMusicList.model.SongModel;
import com.myMusicList.service.PlaylistService;
import com.myMusicList.service.SongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

// shows the user's saved playlist and handles add/remove actions
// the "redirect" param controls where you land after the action (dashboard or playlist page)
@WebServlet("/playlist")
public class PlaylistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PlaylistService ps = new PlaylistService();
        List<PlaylistModel> playlist     = ps.getPlaylistByUser(user.getId());
        List<Integer> playlistSongIds    = ps.getPlaylistSongIds(user.getId());

        SongService ss = new SongService();
        List<SongModel> allSongs = ss.getAllSongs();

        request.setAttribute("playlist",       playlist);
        request.setAttribute("playlistSongIds", playlistSongIds);
        request.setAttribute("allSongs",        allSongs);
        request.getRequestDispatcher("/WEB-INF/pages/playlist.jsp").forward(request, response);
    }

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
        String redirectTo = request.getParameter("redirect");

        if (songIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int songId = Integer.parseInt(songIdStr);
            PlaylistService service = new PlaylistService();

            // go back to wherever the request came from
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