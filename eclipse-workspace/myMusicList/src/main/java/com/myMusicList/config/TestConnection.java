package com.myMusicList.config;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        Connection conn = DbConfig.getConnection();
        if (conn != null) {
            System.out.println("Connection Successful!");
        } else {
            System.out.println("Connection Failed!");
        }
    }
}