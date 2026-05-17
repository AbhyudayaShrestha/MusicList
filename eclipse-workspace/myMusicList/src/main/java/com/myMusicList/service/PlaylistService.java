package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import com.myMusicList.model.PlaylistModel;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

// all DB operations for user playlists
public class PlaylistService {

    // fetch user's playlist joined with song info, newest first
    public List<PlaylistModel> getPlaylistByUser(int userId) {
        List<PlaylistModel> list = new ArrayList<>();
        String sql = "SELECT p.id, p.user_id, p.song_id, p.added_at, " +
                     "s.title, s.artist, s.genre " +
                     "FROM playlists p " +
                     "JOIN songs s ON p.song_id = s.id " +
                     "WHERE p.user_id = ? " +
                     "ORDER BY p.added_at DESC";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Timestamp ts = rs.getTimestamp("added_at");
                list.add(new PlaylistModel(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getInt("song_id"),
                    rs.getString("title"),
                    rs.getString("artist"),
                    rs.getString("genre"),
                    ts != null ? ts.toLocalDateTime() : LocalDateTime.now()
                ));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching playlist: " + e.getMessage());
        }
        return list;
    }

    // returns false if the song is already saved or the DB call fails
    // INSERT IGNORE handles duplicates at the DB level
    public boolean addToPlaylist(int userId, int songId) {
        String sql = "INSERT IGNORE INTO playlists (user_id, song_id) VALUES (?, ?)";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, songId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding to playlist: " + e.getMessage());
            return false;
        }
    }

    public boolean removeFromPlaylist(int userId, int songId) {
        String sql = "DELETE FROM playlists WHERE user_id = ? AND song_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, songId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error removing from playlist: " + e.getMessage());
            return false;
        }
    }

    public boolean isInPlaylist(int userId, int songId) {
        String sql = "SELECT 1 FROM playlists WHERE user_id = ? AND song_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, songId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("Error checking playlist: " + e.getMessage());
            return false;
        }
    }

    // returns just the song IDs — used by the dashboard so it can
    // mark rows without making a separate DB call per row
    public List<Integer> getPlaylistSongIds(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT song_id FROM playlists WHERE user_id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt("song_id"));
        } catch (SQLException e) {
            System.err.println("Error fetching playlist IDs: " + e.getMessage());
        }
        return ids;
    }
}