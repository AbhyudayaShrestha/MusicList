package com.myMusicList.util;

public class ValidationUtil {

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidName(String name) {
        return !isEmpty(name) && name.trim().length() >= 2;
    }

    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.contains("@") && email.contains(".");
    }

    public static boolean isValidPassword(String password) {
        return !isEmpty(password) && password.length() >= 8;
    }

    // NEW: Song title must be at least 1 char and max 100
    public static boolean isValidSongTitle(String title) {
        return !isEmpty(title) && title.trim().length() >= 1 && title.trim().length() <= 100;
    }

    // NEW: Artist name must be at least 2 chars
    public static boolean isValidArtistName(String artist) {
        return !isEmpty(artist) && artist.trim().length() >= 2 && artist.trim().length() <= 100;
    }

    // NEW: Genre must not be empty and max 50 chars
    public static boolean isValidGenre(String genre) {
        return !isEmpty(genre) && genre.trim().length() >= 1 && genre.trim().length() <= 50;
    }
}