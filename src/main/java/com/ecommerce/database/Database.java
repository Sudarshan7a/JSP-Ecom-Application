package com.ecommerce.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/jsp-servlet-ecommerce-website";
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    private void ensureDriverLoaded() throws SQLException {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver is not available on the classpath.", e);
        }
    }

    public static boolean hasConfiguredCredentials() {
        String user = System.getenv("ECOM_DB_USER");
        if (user == null || user.isBlank()) {
            user = System.getProperty("ecom.db.user");
        }

        String password = System.getenv("ECOM_DB_PASSWORD");
        if (password == null || password.isBlank()) {
            password = System.getProperty("ecom.db.password");
        }

        return user != null && !user.isBlank() && password != null && !password.isBlank();
    }

    private String getEnvOrProperty(String envKey, String propertyKey, String defaultValue) {
        String value = System.getenv(envKey);
        if (value == null || value.isBlank()) {
            value = System.getProperty(propertyKey);
        }
        if (value != null) {
            value = value.trim();
        }
        return (value == null || value.isBlank()) ? defaultValue : value;
    }

    public Connection getConnection() throws SQLException {
        String url = getEnvOrProperty("ECOM_DB_URL", "ecom.db.url", DEFAULT_URL);
        String user = getEnvOrProperty("ECOM_DB_USER", "ecom.db.user", null);
        String password = getEnvOrProperty("ECOM_DB_PASSWORD", "ecom.db.password", null);

        ensureDriverLoaded();

        if (user == null && password == null) {
            throw new SQLException("Missing DB user and password. Set ECOM_DB_USER/ECOM_DB_PASSWORD env vars or ecom.db.user/ecom.db.password JVM properties.");
        }
        if (user == null) {
            throw new SQLException("Missing DB user. Set ECOM_DB_USER env var or ecom.db.user JVM property.");
        }
        if (password == null) {
            throw new SQLException("Missing DB password. Set ECOM_DB_PASSWORD env var or ecom.db.password JVM property.");
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
