package com.myMusicList.service;

import com.myMusicList.config.DbConfig;
import java.util.ArrayList;
import java.util.List;
import com.myMusicList.model.UserModel;
import java.sql.*;
import java.time.LocalDateTime;
import org.mindrot.jbcrypt.BCrypt;

// all DB operations for users — registration, login, lockout, profile, admin
public class UserService {

    private static final int MAX_ATTEMPTS    = 3;
    private static final int LOCKOUT_MINUTES = 1;

    // ── Registration ──────────────────────────────────────────────────

    // passwords and security answers are both BCrypt hashed before storing
    public boolean registerUser(UserModel user) {
        String sql = "INSERT INTO users (name, email, password, security_question, security_answer) " +
                     "VALUES (?, ?, ?, ?, ?)";
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        String hashedAnswer   = user.getSecurityAnswer() != null
            ? BCrypt.hashpw(user.getSecurityAnswer().trim().toLowerCase(), BCrypt.gensalt())
            : null;
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getSecurityQuestion());
            ps.setString(5, hashedAnswer);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Registration error: " + e.getMessage());
            return false;
        }
    }

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

    // ── Login + Lockout ───────────────────────────────────────────────

    // returns null if credentials don't match
    public UserModel validateUser(String email, String password) {
        String sql = "SELECT id, name, email, password, role FROM users WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && BCrypt.checkpw(password, rs.getString("password"))) {
                UserModel user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }

    // returns the lockout expiry time if still active, null otherwise
    public LocalDateTime getLockoutTime(String email) {
        String sql = "SELECT locked_until FROM login_attempts WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp ts = rs.getTimestamp("locked_until");
                if (ts != null) {
                    LocalDateTime until = ts.toLocalDateTime();
                    if (until.isAfter(LocalDateTime.now())) return until;
                    clearLockout(email); // expired — clean it up
                }
            }
        } catch (SQLException e) {
            System.err.println("Lockout check error: " + e.getMessage());
        }
        return null;
    }

    // increments failed attempt counter; locks the account after MAX_ATTEMPTS
    public int recordFailedAttempt(String email) {
        String upsert = "INSERT INTO login_attempts (email, attempts) VALUES (?, 1) " +
                        "ON DUPLICATE KEY UPDATE attempts = attempts + 1";
        String select = "SELECT attempts FROM login_attempts WHERE email = ?";
        String lock   = "UPDATE login_attempts SET locked_until = ? WHERE email = ?";
        try (Connection conn = DbConfig.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(upsert)) {
                ps.setString(1, email);
                ps.executeUpdate();
            }
            int attempts = 0;
            try (PreparedStatement ps = conn.prepareStatement(select)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) attempts = rs.getInt("attempts");
            }
            if (attempts >= MAX_ATTEMPTS) {
                try (PreparedStatement ps = conn.prepareStatement(lock)) {
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now().plusMinutes(LOCKOUT_MINUTES)));
                    ps.setString(2, email);
                    ps.executeUpdate();
                }
            }
            return attempts;
        } catch (SQLException e) {
            System.err.println("Failed attempt error: " + e.getMessage());
            return 0;
        }
    }

    public void clearLockout(String email) {
        String sql = "DELETE FROM login_attempts WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Clear lockout error: " + e.getMessage());
        }
    }

    // ── User Lists ────────────────────────────────────────────────────

    public List<UserModel> getAllUsers() {
        return searchAndSortUsers("", "name", "asc");
    }

    // admin user table — searchable and sortable
    public List<UserModel> searchAndSortUsers(String keyword, String sortBy, String order) {
        List<UserModel> users = new ArrayList<>();

        // whitelist columns to prevent injection in ORDER BY
        String col = "name";
        if ("email".equals(sortBy)) col = "email";
        else if ("role".equals(sortBy)) col = "role";

        String dir = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";

        String sql = "SELECT id, name, email, role, security_question FROM users " +
                     "WHERE LOWER(name)  LIKE LOWER(?) " +
                     "   OR LOWER(email) LIKE LOWER(?) " +
                     "   OR LOWER(role)  LIKE LOWER(?) " +
                     "ORDER BY " + col + " " + dir;

        String like = "%" + keyword + "%";

        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserModel u = new UserModel();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setSecurityQuestion(rs.getString("security_question"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error searching users: " + e.getMessage());
        }
        return users;
    }

    // ── Admin: delete a user ──────────────────────────────────────────

    // also removes any lockout record for that email; caller checks admin != self
    public boolean deleteUser(int userId) {
        String getEmail = "SELECT email FROM users WHERE id = ?";
        String delLock  = "DELETE FROM login_attempts WHERE email = ?";
        String delUser  = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DbConfig.getConnection()) {
            String email = null;
            try (PreparedStatement ps = conn.prepareStatement(getEmail)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) email = rs.getString("email");
            }
            if (email != null) {
                try (PreparedStatement ps = conn.prepareStatement(delLock)) {
                    ps.setString(1, email);
                    ps.executeUpdate();
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(delUser)) {
                ps.setInt(1, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("Delete user error: " + e.getMessage());
            return false;
        }
    }

    // ── Admin: update name + role ─────────────────────────────────────

    public boolean updateUser(int userId, String newName, String newRole) {
        String sql = "UPDATE users SET name = ?, role = ? WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setString(2, newRole);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update user error: " + e.getMessage());
            return false;
        }
    }

    // ── Profile ───────────────────────────────────────────────────────

    // loads the full user including security_question (answer hash is never returned)
    public UserModel getUserWithSecurity(int userId) {
        String sql = "SELECT id, name, email, role, security_question FROM users WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserModel u = new UserModel();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setSecurityQuestion(rs.getString("security_question"));
                return u;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user: " + e.getMessage());
        }
        return null;
    }

    public boolean updateName(int userId, String newName) {
        String sql = "UPDATE users SET name = ? WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName.trim());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Name update error: " + e.getMessage());
            return false;
        }
    }

    public boolean verifyPassword(int userId, String plainPassword) {
        String sql = "SELECT password FROM users WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return BCrypt.checkpw(plainPassword, rs.getString("password"));
        } catch (SQLException e) {
            System.err.println("Password verify error: " + e.getMessage());
        }
        return false;
    }

    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Password change error: " + e.getMessage());
            return false;
        }
    }

    // lets older accounts (created before security questions existed) set one up
    public boolean updateSecurityQuestion(int userId, String question, String plainAnswer) {
        String hashed = BCrypt.hashpw(plainAnswer.trim().toLowerCase(), BCrypt.gensalt());
        String sql = "UPDATE users SET security_question = ?, security_answer = ? WHERE id = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, question.trim());
            ps.setString(2, hashed);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Security question update error: " + e.getMessage());
            return false;
        }
    }

    // ── Forgot Password ───────────────────────────────────────────────

    public String getSecurityQuestion(String email) {
        String sql = "SELECT security_question FROM users WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("security_question");
        } catch (SQLException e) {
            System.err.println("Security question error: " + e.getMessage());
        }
        return null;
    }

    // answer is compared case-insensitively (trimmed + lowercased at registration)
    public boolean verifySecurityAnswer(String email, String answer) {
        String sql = "SELECT security_answer FROM users WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String stored = rs.getString("security_answer");
                if (stored != null) return BCrypt.checkpw(answer.trim().toLowerCase(), stored);
            }
        } catch (SQLException e) {
            System.err.println("Security answer error: " + e.getMessage());
        }
        return false;
    }

    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DbConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Password reset error: " + e.getMessage());
            return false;
        }
    }
}