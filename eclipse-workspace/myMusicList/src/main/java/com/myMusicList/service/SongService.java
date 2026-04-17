package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import com.myMusicList.model.SongModel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SongService {

    public List<SongModel> getAllSongs() {
        List<SongModel> songs = new ArrayList<>();
        String sql = "SELECT id, title, artist, genre FROM songs";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SongModel song = new SongModel(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("artist"),
                    rs.getString("genre")
                );
                songs.add(song);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching songs: " + e.getMessage());
        }
        return songs;
    }

    // NEW: Check if a song with the same title AND artist already exists
    // excludeId is used during edit so we don't flag the song against itself (-1 for add)
    public boolean songExists(String title, String artist, int excludeId) {
        String sql = "SELECT id FROM songs WHERE LOWER(title) = LOWER(?) AND LOWER(artist) = LOWER(?) AND id != ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title.trim());
            ps.setString(2, artist.trim());
            ps.setInt(3, excludeId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Error checking duplicate song: " + e.getMessage());
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