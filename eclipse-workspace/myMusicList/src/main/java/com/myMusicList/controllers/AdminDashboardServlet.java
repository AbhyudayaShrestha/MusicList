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

/**
 * Admin dashboard controller.
 * Supports tab switching, search and sort (asc/desc) for both songs and users.
 *
 * URL params:
 *   tab        = songs | users          (default: songs)
 *   search     = keyword               (searches title+artist+genre or name+email)
 *   sort       = title|artist|genre    (songs) | name|email|role (users)
 *   order      = asc | desc            (default: asc)
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Tab ───────────────────────────────────────────────────────
        String tab = request.getParameter("tab");
        if (tab == null || (!tab.equals("users"))) tab = "songs";
        request.setAttribute("activeTab", tab);

        // ── Search / Sort / Order params ──────────────────────────────
        String search = request.getParameter("search");
        String sort   = request.getParameter("sort");
        String order  = request.getParameter("order");

        if (search == null) search = "";
        if (order  == null || !order.equals("desc")) order = "asc";

        SongService songService = new SongService();
        UserService userService = new UserService();

        if ("songs".equals(tab)) {
            if (sort == null || (!sort.equals("artist") && !sort.equals("genre"))) sort = "title";
            List<SongModel> songs = songService.searchAndSortAdmin(search.trim(), sort, order);
            request.setAttribute("songs", songs);

        } else {
            if (sort == null || (!sort.equals("email") && !sort.equals("role"))) sort = "name";
            List<UserModel> users = userService.searchAndSortUsers(search.trim(), sort, order);
            request.setAttribute("users", users);
        }

        // Pass back to JSP so form fields stay populated
        request.setAttribute("search", search);
        request.setAttribute("sort",   sort);
        request.setAttribute("order",  order);

        request.getRequestDispatcher("/WEB-INF/pages/admin.jsp").forward(request, response);
    }
}