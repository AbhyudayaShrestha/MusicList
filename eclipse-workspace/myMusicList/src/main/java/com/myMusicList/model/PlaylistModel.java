package com.myMusicList.model;

import java.time.LocalDateTime;

public class PlaylistModel {

    private int id;
    private int userId;
    private int songId;
    private LocalDateTime addedAt;

    
    private String songTitle;
    private String songArtist;
    private String songGenre;

    public PlaylistModel() {}

    public PlaylistModel(int id, int userId, int songId,
                         String songTitle, String songArtist, String songGenre,
                         LocalDateTime addedAt) {
        this.id         = id;
        this.userId     = userId;
        this.songId     = songId;
        this.songTitle  = songTitle;
        this.songArtist = songArtist;
        this.songGenre  = songGenre;
        this.addedAt    = addedAt;
    }


    public int getId()
    {
        return id;
    }

    public void setId(int id)
    {
        this.id = id;
    }

    public int getUserId()
    {
        return userId;
    }

    public void setUserId(int userId)
    {
        this.userId = userId;
    }

    public int getSongId()
    {
        return songId;
    }

    public void setSongId(int songId)
    {
        this.songId = songId;
    }

    public LocalDateTime getAddedAt()
    {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt)
    {
        this.addedAt = addedAt;
    }

    public String getSongTitle()
    {
        return songTitle;
    }

    public void setSongTitle(String songTitle)
    {
        this.songTitle = songTitle;
    }

    public String getSongArtist()
    {
        return songArtist;
    }

    public void setSongArtist(String songArtist)
    {
        this.songArtist = songArtist;
    }

    public String getSongGenre()
    {
        return songGenre;
    }

    public void setSongGenre(String songGenre)
    {
        this.songGenre = songGenre;
    }   
}