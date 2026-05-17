package com.myMusicList.util;

// shared input validation helpers used across servlets
public class ValidationUtil {

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // name needs at least 2 chars
    public static boolean isValidName(String name) {
        return !isEmpty(name) && name.trim().length() >= 2;
    }

    // basic check — just needs @ and a dot
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.contains("@") && email.contains(".");
    }

    // min 8 characters
    public static boolean isValidPassword(String password) {
        return !isEmpty(password) && password.length() >= 8;
    }

    // song title: 1–100 chars
    public static boolean isValidSongTitle(String title) {
        return !isEmpty(title) && title.trim().length() >= 1 && title.trim().length() <= 100;
    }

    // artist name: 2–100 chars (stricter than isEmpty to catch single-char names)
    public static boolean isValidArtistName(String artist) {
        return !isEmpty(artist) && artist.trim().length() >= 2 && artist.trim().length() <= 100;
    }

    // genre: 1–50 chars
    public static boolean isValidGenre(String genre) {
        return !isEmpty(genre) && genre.trim().length() >= 1 && genre.trim().length() <= 50;
    }
}