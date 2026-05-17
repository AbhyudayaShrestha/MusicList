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

// admin dashboard — two tabs (songs / users), both support search + sort
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // prevent back-button after logout from serving a cached page
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // default to songs tab if nothing is specified
        String tab = request.getParameter("tab");
        if (tab == null || !tab.equals("users")) tab = "songs";
        request.setAttribute("activeTab", tab);

        String search = request.getParameter("search");
        String sort   = request.getParameter("sort");
        String order  = request.getParameter("order");

        if (search == null) search = "";
        if (order == null || !order.equals("desc")) order = "asc";

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

        // pass params back so the JSP can keep the form fields populated
        request.setAttribute("search", search);
        request.setAttribute("sort",   sort);
        request.setAttribute("order",  order);

        request.getRequestDispatcher("/WEB-INF/pages/admin.jsp").forward(request, response);
    }
}