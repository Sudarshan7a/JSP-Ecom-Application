package com.ecommerce.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/jsp-servlet-ecommerce-website", "root", "root");
    }

    public static void main(String[] args) {
        try {
            System.out.println(new Database().getConnection());
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
