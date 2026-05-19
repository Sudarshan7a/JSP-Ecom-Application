package com.ecommerce.control;

import com.ecommerce.dao.ContactMessageDao;
import com.ecommerce.database.Database;
import com.ecommerce.entity.ContactMessage;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ContactManagementControl", value = "/contact-management")
public class ContactManagementControl extends HttpServlet {
    private final ContactMessageDao contactMessageDao = new ContactMessageDao();

    private boolean demoMode() {
        return !Database.hasConfiguredCredentials();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ContactMessage> messageList;
        if (demoMode()) {
            // In demo mode, read from application context (populated by ContactControl)
            @SuppressWarnings("unchecked")
            List<ContactMessage> demoMessages = (List<ContactMessage>) getServletContext().getAttribute("demo_contact_messages");
            messageList = demoMessages != null ? demoMessages : new ArrayList<>();
        } else {
            messageList = contactMessageDao.getAllMessages();
        }
        request.setAttribute("message_list", messageList);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("contact-management.jsp");
        requestDispatcher.forward(request, response);
    }
}