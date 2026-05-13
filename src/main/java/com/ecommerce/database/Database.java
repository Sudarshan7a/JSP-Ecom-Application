package com.ecommerce.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/jsp-servlet-ecommerce-website";

    private String getEnvOrProperty(String envKey, String propertyKey, String defaultValue) {
        String value = System.getenv(envKey);
        if (value == null || value.isBlank()) {
            value = System.getProperty(propertyKey);
        }
        return (value == null || value.isBlank()) ? defaultValue : value;
    }

    public Connection getConnection() throws SQLException {
        String url = getEnvOrProperty("ECOM_DB_URL", "ecom.db.url", DEFAULT_URL);
        String user = getEnvOrProperty("ECOM_DB_USER", "ecom.db.user", null);
        String password = getEnvOrProperty("ECOM_DB_PASSWORD", "ecom.db.password", null);

        if (user == null || password == null) {
            throw new SQLException("Missing DB credentials. Set ECOM_DB_USER/ECOM_DB_PASSWORD env vars or ecom.db.user/ecom.db.password JVM properties.");
        }

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
