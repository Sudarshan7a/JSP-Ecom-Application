package com.ecommerce.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/jsp-servlet-ecommerce-website";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "root";

    private String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? defaultValue : value;
    }

    public Connection getConnection() throws SQLException {
        String url = getEnvOrDefault("ECOM_DB_URL", DEFAULT_URL);
        String user = getEnvOrDefault("ECOM_DB_USER", DEFAULT_USER);
        String password = getEnvOrDefault("ECOM_DB_PASSWORD", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, user, password);
    }

    public static void main(String[] args) {
        try {
            System.out.println(new Database().getConnection());
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
