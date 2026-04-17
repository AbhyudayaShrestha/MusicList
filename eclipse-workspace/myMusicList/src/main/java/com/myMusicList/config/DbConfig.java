package com.myMusicList.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database configuration class.
 * Provides a central method to get a MySQL connection.
 */
public class DbConfig {

    private static final String URL = "jdbc:mysql://localhost:3306/mymusiclist";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    /**
     * Creates and returns a connection to the MySQL database.
     * Returns null if the connection fails.
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected Successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Database Connection Failed!");
            e.printStackTrace();
        }
        return conn;
    }
}