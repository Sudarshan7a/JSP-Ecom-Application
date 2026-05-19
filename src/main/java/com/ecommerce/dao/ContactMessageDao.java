package com.ecommerce.dao;

import com.ecommerce.database.Database;
import com.ecommerce.entity.ContactMessage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDao {
    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> messageList = new ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY id DESC";

        try (Connection connection = new Database().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                ContactMessage contactMessage = new ContactMessage();
                contactMessage.setId(resultSet.getInt("id"));
                contactMessage.setFirstName(resultSet.getString("first_name"));
                contactMessage.setLastName(resultSet.getString("last_name"));
                contactMessage.setEmail(resultSet.getString("email"));
                contactMessage.setSubject(resultSet.getString("subject"));
                contactMessage.setMessage(resultSet.getString("message"));
                contactMessage.setSubmittedAt(resultSet.getTimestamp("submitted_at"));
                messageList.add(contactMessage);
            }
        } catch (SQLException e) {
            System.out.println("Get contact messages catch: " + e.getMessage());
        }

        return messageList;
    }
}