package com.ecommerce.entity;

import java.util.Date;

public class ContactMessage {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String subject;
    private String message;
    private Date submittedAt;

    public ContactMessage() {
    }

    public ContactMessage(int id, String firstName, String lastName, String email, String subject, String message, Date submittedAt) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.subject = subject;
        this.message = message;
        this.submittedAt = submittedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Date submittedAt) {
        this.submittedAt = submittedAt;
    }
}