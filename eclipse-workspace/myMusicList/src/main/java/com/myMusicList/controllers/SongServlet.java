package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myMusicList.model.SongModel;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.SongService;
import com.myMusicList.util.ValidationUtil;

// admin song management — add, edit, delete
@WebServlet("/admin/songs")
public class SongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        SongService service = new SongService();

        switch (action) {
            case "add":
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
                break;

            case "edit":
                // bad or missing ID? redirect cleanly rather than throw a 500
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    SongModel song = service.getSongById(id);
                    if (song == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs");
                        return;
                    }
                    request.setAttribute("song", song);
                    request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        SongService service = new SongService();

        if ("delete".equals(action)) {
            try {
                int deleteId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = service.deleteSong(deleteId);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs&songSuccess=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs&songError=notfound");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs");
            }
            return;
        }

        String title  = request.getParameter("title");
        String artist = request.getParameter("artist");
        String genre  = request.getParameter("genre");

        if ("add".equals(action)) {

            if (ValidationUtil.isEmpty(title)) {
                request.setAttribute("error", "Song title is required.");
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
                return;
            }
            // isValidArtistName enforces min 2 chars (isEmpty alone let single chars through)
            if (!ValidationUtil.isValidArtistName(artist)) {
                request.setAttribute("error", "Artist name must be at least 2 characters.");
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
                return;
            }
            if (!ValidationUtil.isValidGenre(genre)) {
                request.setAttribute("error", "Genre is required.");
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
                return;
            }

            if (service.songExists(title, artist, -1)) {
                request.setAttribute("error", "A song with the same title and artist already exists.");
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
                return;
            }

            SongModel song = new SongModel(0, title, artist, genre);
            boolean success = service.addSong(song);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs&songSuccess=added");
            } else {
                request.setAttribute("error", "Failed to add song. Please try again.");
                request.getRequestDispatcher("/WEB-INF/pages/addSong.jsp").forward(request, response);
            }

        } else if ("edit".equals(action)) {
            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs");
                return;
            }

            if (ValidationUtil.isEmpty(title)) {
                request.setAttribute("error", "Song title is required.");
                request.setAttribute("song", service.getSongById(id));
                request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
                return;
            }
            if (!ValidationUtil.isValidArtistName(artist)) {
                request.setAttribute("error", "Artist name must be at least 2 characters.");
                request.setAttribute("song", service.getSongById(id));
                request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
                return;
            }
            if (!ValidationUtil.isValidGenre(genre)) {
                request.setAttribute("error", "Genre is required.");
                request.setAttribute("song", service.getSongById(id));
                request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
                return;
            }

            // pass current song ID so we don't flag it as a duplicate of itself
            if (service.songExists(title, artist, id)) {
                request.setAttribute("error", "Another song with the same title and artist already exists.");
                request.setAttribute("song", service.getSongById(id));
                request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
                return;
            }

            SongModel song = new SongModel(id, title, artist, genre);
            boolean success = service.updateSong(song);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=songs&songSuccess=edited");
            } else {
                request.setAttribute("error", "Failed to update song. Please try again.");
                request.setAttribute("song", service.getSongById(id));
                request.getRequestDispatcher("/WEB-INF/pages/editSong.jsp").forward(request, response);
            }
        }
    }
}