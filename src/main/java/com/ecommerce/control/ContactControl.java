package com.ecommerce.control;

import com.ecommerce.database.Database;
import com.ecommerce.entity.ContactMessage;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ContactControl", value = "/contact")
public class ContactControl extends HttpServlet {

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("contact.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("c_fname");
        String lastName = request.getParameter("c_lname");
        String email = request.getParameter("c_email");
        String subject = request.getParameter("c_subject");
        String message = request.getParameter("c_message");
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        // Always log to server console for demo visibility
        System.out.println("=== CONTACT FORM SUBMISSION [" + timestamp + "] ===");
        System.out.println("  Name   : " + name);
        System.out.println("  Email  : " + email);
        System.out.println("  Subject: " + subject);
        System.out.println("  Message: " + message);
        System.out.println("=================================================");

        if (demoMode()) {
            // In demo mode, store messages in the application context so contact-management can display them
            @SuppressWarnings("unchecked")
            List<ContactMessage> demoMessages = (List<ContactMessage>) getServletContext().getAttribute("demo_contact_messages");
            if (demoMessages == null) {
                demoMessages = new ArrayList<>();
            }
            ContactMessage cm = new ContactMessage(
                demoMessages.size() + 1, name, lastName, email, subject, message, new Date()
            );
            demoMessages.add(0, cm); // newest first
            getServletContext().setAttribute("demo_contact_messages", demoMessages);
            System.out.println("[ContactControl] Demo mode: message stored in application context.");
        } else {
            // Attempt to save to database (non-fatal if table doesn't exist)
            try {
                Database database = new Database();
                try (Connection conn = database.getConnection()) {
                    // Create table if not exists
                    conn.createStatement().executeUpdate(
                        "CREATE TABLE IF NOT EXISTS contact_messages (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "first_name VARCHAR(100), " +
                        "last_name VARCHAR(100), " +
                        "email VARCHAR(150), " +
                        "subject VARCHAR(200), " +
                        "message TEXT, " +
                        "submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP)"
                    );
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO contact_messages (first_name, last_name, email, subject, message) VALUES (?, ?, ?, ?, ?)"
                    );
                    ps.setString(1, name);
                    ps.setString(2, lastName);
                    ps.setString(3, email);
                    ps.setString(4, subject);
                    ps.setString(5, message);
                    ps.executeUpdate();
                    System.out.println("[ContactControl] Message saved to DB.");
                }
            } catch (Exception e) {
                System.err.println("[ContactControl] Could not save to DB: " + e.getMessage());
            }
        }

        // Store success state in session and redirect (PRG pattern to avoid form resubmission)
        HttpSession session = request.getSession();
        session.setAttribute("contact_message_sent", true);
        session.setAttribute("contact_message_name", name);
        session.setAttribute("contact_message_last_name", lastName);
        session.setAttribute("contact_message_email", email);
        session.setAttribute("contact_message_subject", subject);

        response.sendRedirect(request.getContextPath() + "/contact?sent=true");
    }
}