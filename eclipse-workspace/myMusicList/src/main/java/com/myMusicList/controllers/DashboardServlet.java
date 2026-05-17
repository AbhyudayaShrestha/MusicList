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

// main page for logged-in users — song library with search/sort
// also pulls playlist song IDs so each row knows if it's already saved
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // back button after logout must not show a cached version
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        UserModel user = (UserModel) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String sort   = request.getParameter("sort");
        String order  = request.getParameter("order");

        if (search == null) search = "";
        if (sort == null || !sort.equals("artist")) sort = "title";
        if (order == null || !order.equals("desc"))  order = "asc";

        SongService songService = new SongService();
        List<SongModel> songs = songService.searchAndSortAdmin(search.trim(), sort, order);

        PlaylistService playlistService = new PlaylistService();
        List<PlaylistModel> playlist = playlistService.getPlaylistByUser(user.getId());
        // load IDs separately so we don't need a DB call per song row
        List<Integer> playlistIds = playlistService.getPlaylistSongIds(user.getId());

        request.setAttribute("songs",       songs);
        request.setAttribute("playlist",    playlist);
        request.setAttribute("playlistIds", playlistIds);
        request.setAttribute("search",      search);
        request.setAttribute("sort",        sort);
        request.setAttribute("order",       order);

        request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp").forward(request, response);
    }
}