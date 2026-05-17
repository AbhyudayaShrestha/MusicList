package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import com.myMusicList.model.SongModel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// all DB operations for songs
public class SongService {

    public List<SongModel> getAllSongs() {
        return searchAndSort("", "title");
    }

    // used by the member dashboard — search + sort, always ascending
    public List<SongModel> searchAndSort(String keyword, String sortBy) {
        return searchAndSortAdmin(keyword, sortBy, "asc");
    }

    // used by the admin dashboard — supports both sort directions
    public List<SongModel> searchAndSortAdmin(String keyword, String sortBy, String order) {
        List<SongModel> songs = new ArrayList<>();

        // whitelist the column to prevent SQL injection in ORDER BY
        String col = "title";
        if ("artist".equals(sortBy)) col = "artist";
        else if ("genre".equals(sortBy)) col = "genre";

        String dir = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";

        String sql = "SELECT id, title, artist, genre FROM songs " +
                     "WHERE LOWER(title)  LIKE LOWER(?) " +
                     "   OR LOWER(artist) LIKE LOWER(?) " +
                     "   OR LOWER(genre)  LIKE LOWER(?) " +
                     "ORDER BY " + col + " " + dir;

        String like = "%" + keyword + "%";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                songs.add(new SongModel(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("artist"),
                    rs.getString("genre")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error searching songs: " + e.getMessage());
        }
        return songs;
    }

    // excludeId skips the current song when checking duplicates during an edit
    public boolean songExists(String title, String artist, int excludeId) {
        String sql = "SELECT id FROM songs WHERE LOWER(title) = LOWER(?) " +
                     "AND LOWER(artist) = LOWER(?) AND id != ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title.trim());
            ps.setString(2, artist.trim());
            ps.setInt(3, excludeId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("Error checking duplicate: " + e.getMessage());
            return false;
        }
    }

    public boolean addSong(SongModel song) {
        String sql = "INSERT INTO songs (title, artist, genre) VALUES (?, ?, ?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, song.getTitle().trim());
            ps.setString(2, song.getArtist().trim());
            ps.setString(3, song.getGenre().trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding song: " + e.getMessage());
            return false;
        }
    }

    public boolean updateSong(SongModel song) {
        String sql = "UPDATE songs SET title=?, artist=?, genre=? WHERE id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, song.getTitle().trim());
            ps.setString(2, song.getArtist().trim());
            ps.setString(3, song.getGenre().trim());
            ps.setInt(4, song.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating song: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteSong(int id) {
        String sql = "DELETE FROM songs WHERE id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting song: " + e.getMessage());
            return false;
        }
    }

    public SongModel getSongById(int id) {
        String sql = "SELECT id, title, artist, genre FROM songs WHERE id=?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new SongModel(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("artist"),
                    rs.getString("genre")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error fetching song: " + e.getMessage());
        }
        return null;
    }
}