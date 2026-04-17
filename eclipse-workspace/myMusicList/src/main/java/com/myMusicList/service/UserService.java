package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import java.util.ArrayList;
import java.util.List;
import com.myMusicList.model.UserModel;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Service class for user-related database operations.
 * Handles registration, login validation, and fetching users.
 */
public class UserService {

    /**
     * Registers a new user by saving their details to the database.
     * Password is hashed using BCrypt before storing.
     */
    public boolean registerUser(UserModel user) {
        String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Registration error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Checks if an email address is already registered in the database.
     * Used to prevent duplicate accounts.
     */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            return ps.executeQuery().next();

        } catch (SQLException e) {
            System.err.println("Email check error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Validates login credentials.
     * Fetches the user by email and checks the password against the stored BCrypt hash.
     * Returns the UserModel if valid, null if invalid.
     */
    public UserModel validateUser(String email, String password) {
        String sql = "SELECT id, name, email, password, role FROM users WHERE email = ?";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                // Verify the entered password against the stored hash
                if (BCrypt.checkpw(password, storedHash)) {
                    UserModel user = new UserModel();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all users from the database.
     * Used by the admin dashboard to display the users list.
     */
    public List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        String sql = "SELECT id, name, email, role FROM users";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UserModel user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching users: " + e.getMessage());
        }
        return users;
    }
}