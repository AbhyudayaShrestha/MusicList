package com.myMusicList.model;

// basic song record — maps to the songs table
public class SongModel {

    private int    id;
    private String title;
    private String artist;
    private String genre;

    public SongModel() {}

    public SongModel(int id, String title, String artist, String genre) {
        this.id     = id;
        this.title  = title;
        this.artist = artist;
        this.genre  = genre;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getArtist() { return artist; }
    public void setArtist(String artist) { this.artist = artist; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }
}