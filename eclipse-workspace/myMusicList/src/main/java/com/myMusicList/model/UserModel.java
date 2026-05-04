package com.myMusicList.model;

/**
 * Represents a registered user.
 * Includes security question/answer fields added for Milestone 2 forgot-password flow.
 */
public class UserModel {

    private int id;
    private String name;
    private String email;
    private String password;
    private String role;
    private String securityQuestion;
    private String securityAnswer;   // stored as BCrypt hash in DB

    public UserModel() {}

    // ── Getters & Setters ──────────────────────────────────────────────

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getSecurityQuestion() {
        return securityQuestion;
    }

    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }

    public String getSecurityAnswer() {
        return securityAnswer;
    }

    public void setSecurityAnswer(String securityAnswer) {
        this.securityAnswer = securityAnswer;
    }
}