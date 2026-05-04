package com.myMusicList.controllers;

import com.myMusicList.model.PlaylistModel;
import com.myMusicList.model.SongModel;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.PlaylistService;
import com.myMusicList.service.SongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Dashboard controller – serves the main member landing page.
 *
 * Supports:
 *  - Search: ?search=keyword  (searches title, artist, genre)
 *  - Sort:   ?sort=title|artist|genre  (default: title)
 *  - Playlist data for the logged-in user
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Search & Sort parameters ────────────────────────────────────
        String search = request.getParameter("search");
        String sort   = request.getParameter("sort");

        if (search == null) search = "";
        if (sort == null || (!sort.equals("artist") && !sort.equals("genre"))) {
            sort = "title";   // safe default
        }

        // ── Fetch songs (filtered + sorted at DB level) ─────────────────
        SongService songService = new SongService();
        List<SongModel> songs = songService.searchAndSort(search.trim(), sort);

        // ── Fetch this user's playlist ──────────────────────────────────
        PlaylistService playlistService = new PlaylistService();
        List<PlaylistModel> playlist = playlistService.getPlaylistByUser(user.getId());

        // A Set of song IDs already in the playlist – lets the JSP mark rows
        List<Integer> playlistIds = playlistService.getPlaylistSongIds(user.getId());

        // ── Pass to JSP ─────────────────────────────────────────────────
        request.setAttribute("songs",       songs);
        request.setAttribute("playlist",    playlist);
        request.setAttribute("playlistIds", playlistIds);
        request.setAttribute("search",      search);
        request.setAttribute("sort",        sort);

        request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp")
               .forward(request, response);
    }
}