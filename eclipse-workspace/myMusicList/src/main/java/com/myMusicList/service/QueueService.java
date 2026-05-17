package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import com.myMusicList.model.SongModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

// manages the play queue (FIFO) and recently played history (newest first)
// both are stored in the DB so they survive logout and session expiry
//
// Tables:
//   user_queue           — queued songs ordered by position
//   user_recently_played — played songs with timestamp
public class QueueService {

    private static final int MAX_RECENTLY_PLAYED = 20;

    // ── Queue (FIFO / LinkedList) ─────────────────────────────────────

    // load the queue in position order
    public LinkedList<SongModel> loadQueue(int userId) {
        LinkedList<SongModel> queue = new LinkedList<>();
        String sql = "SELECT s.id, s.title, s.artist, s.genre " +
                     "FROM user_queue uq " +
                     "JOIN songs s ON uq.song_id = s.id " +
                     "WHERE uq.user_id = ? " +
                     "ORDER BY uq.position ASC";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.loadQueue: DB connection is null"); return queue; }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    queue.addLast(new SongModel(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("artist"),
                        rs.getString("genre")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("QueueService.loadQueue error: " + e.getMessage());
        }
        return queue;
    }

    // add to the back of the queue; returns false if already queued
    // max position fetched separately to avoid a MySQL subquery-on-same-table error
    public boolean addToQueue(int userId, int songId) {
        String checkSql  = "SELECT 1 FROM user_queue WHERE user_id = ? AND song_id = ?";
        String maxPosSql = "SELECT COALESCE(MAX(position), 0) AS maxPos FROM user_queue WHERE user_id = ?";
        String insertSql = "INSERT INTO user_queue (user_id, song_id, position) VALUES (?, ?, ?)";

        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) {
                System.err.println("QueueService.addToQueue: DB connection is null – check DB config");
                return false;
            }

            // already in queue?
            try (PreparedStatement check = conn.prepareStatement(checkSql)) {
                check.setInt(1, userId);
                check.setInt(2, songId);
                if (check.executeQuery().next()) return false;
            }

            int nextPosition = 1;
            try (PreparedStatement maxPs = conn.prepareStatement(maxPosSql)) {
                maxPs.setInt(1, userId);
                ResultSet rs = maxPs.executeQuery();
                if (rs.next()) nextPosition = rs.getInt("maxPos") + 1;
            }

            try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                ins.setInt(1, userId);
                ins.setInt(2, songId);
                ins.setInt(3, nextPosition);
                return ins.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.err.println("QueueService.addToQueue DB error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public void removeFromQueue(int userId, int songId) {
        String sql = "DELETE FROM user_queue WHERE user_id = ? AND song_id = ?";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.removeFromQueue: DB connection is null"); return; }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, songId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("QueueService.removeFromQueue error: " + e.getMessage());
        }
    }

    // pop the front song, record it as recently played, return it
    public SongModel playNext(int userId) {
        String selectSql = "SELECT uq.id AS queue_id, s.id, s.title, s.artist, s.genre " +
                           "FROM user_queue uq " +
                           "JOIN songs s ON uq.song_id = s.id " +
                           "WHERE uq.user_id = ? " +
                           "ORDER BY uq.position ASC LIMIT 1";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.playNext: DB connection is null"); return null; }
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) return null; // queue is empty

                int queueRowId = rs.getInt("queue_id");
                SongModel song = new SongModel(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("artist"),
                    rs.getString("genre")
                );

                try (PreparedStatement del = conn.prepareStatement("DELETE FROM user_queue WHERE id = ?")) {
                    del.setInt(1, queueRowId);
                    del.executeUpdate();
                }

                pushRecentlyPlayed(userId, song.getId());
                return song;
            }
        } catch (SQLException e) {
            System.err.println("QueueService.playNext error: " + e.getMessage());
            return null;
        }
    }

    public void clearQueue(int userId) {
        String sql = "DELETE FROM user_queue WHERE user_id = ?";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.clearQueue: DB connection is null"); return; }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("QueueService.clearQueue error: " + e.getMessage());
        }
    }

    // ── Recently Played (newest first, capped at MAX_RECENTLY_PLAYED) ─

    public List<SongModel> loadRecentlyPlayed(int userId) {
        List<SongModel> list = new ArrayList<>();
        String sql = "SELECT s.id, s.title, s.artist, s.genre " +
                     "FROM user_recently_played urp " +
                     "JOIN songs s ON urp.song_id = s.id " +
                     "WHERE urp.user_id = ? " +
                     "ORDER BY urp.played_at DESC " +
                     "LIMIT " + MAX_RECENTLY_PLAYED;
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.loadRecentlyPlayed: DB connection is null"); return list; }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new SongModel(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("artist"),
                        rs.getString("genre")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("QueueService.loadRecentlyPlayed error: " + e.getMessage());
        }
        return list;
    }

    // upsert — if the song is already in history just bump its timestamp to the top
    public void pushRecentlyPlayed(int userId, int songId) {
        String upsertSql = "INSERT INTO user_recently_played (user_id, song_id, played_at) " +
                           "VALUES (?, ?, NOW()) " +
                           "ON DUPLICATE KEY UPDATE played_at = NOW()";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) { System.err.println("QueueService.pushRecentlyPlayed: DB connection is null"); return; }
            try (PreparedStatement ps = conn.prepareStatement(upsertSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, songId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("QueueService.pushRecentlyPlayed upsert error: " + e.getMessage());
            return;
        }

        // trim anything older than the cap
        String trimSql = "DELETE FROM user_recently_played " +
                         "WHERE user_id = ? AND id NOT IN (" +
                         "  SELECT id FROM (" +
                         "    SELECT id FROM user_recently_played " +
                         "    WHERE user_id = ? " +
                         "    ORDER BY played_at DESC " +
                         "    LIMIT " + MAX_RECENTLY_PLAYED +
                         "  ) AS keep" +
                         ")";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(trimSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("QueueService.pushRecentlyPlayed trim error: " + e.getMessage());
        }
    }

    public void clearRecentlyPlayed(int userId) {
        String sql = "DELETE FROM user_recently_played WHERE user_id = ?";
        try (Connection conn = DbConfig.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("QueueService.clearRecentlyPlayed error: " + e.getMessage());
        }
    }
}