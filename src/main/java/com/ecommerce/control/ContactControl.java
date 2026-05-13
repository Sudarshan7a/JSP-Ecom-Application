package com.ecommerce.control;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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

        // Attempt to save to database (non-fatal if table doesn't exist)
        if (!demoMode()) {
            try {
                String dbUser = System.getenv("ECOM_DB_USER");
                String dbPass = System.getenv("ECOM_DB_PASSWORD");
                String url = "jdbc:mysql://localhost:3306/ecommerce";
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                    // Create table if not exists
                    conn.createStatement().executeUpdate(
                        "CREATE TABLE IF NOT EXISTS contact_messages (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "name VARCHAR(100), " +
                        "email VARCHAR(150), " +
                        "subject VARCHAR(200), " +
                        "message TEXT, " +
                        "submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP)"
                    );
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)"
                    );
                    ps.setString(1, name);
                    ps.setString(2, email);
                    ps.setString(3, subject);
                    ps.setString(4, message);
                    ps.executeUpdate();
                    System.out.println("[ContactControl] Message saved to DB.");
                }
            } catch (Exception e) {
                System.err.println("[ContactControl] Could not save to DB: " + e.getMessage());
                // Non-fatal: message was logged above
            }
        }

        // Store success state in session and redirect (PRG pattern to avoid form resubmission)
        HttpSession session = request.getSession();
        session.setAttribute("contact_message_sent", true);
        session.setAttribute("contact_message_name", name);
        session.setAttribute("contact_message_email", email);
        session.setAttribute("contact_message_subject", subject);

        response.sendRedirect(request.getContextPath() + "/contact?sent=true");
    }
}