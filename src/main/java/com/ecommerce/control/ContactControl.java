package com.ecommerce.control;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ContactControl", value = "/contact")
public class ContactControl extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("contact_message_sent", true);
        session.setAttribute("contact_message_name", request.getParameter("c_fname"));
        session.setAttribute("contact_message_email", request.getParameter("c_email"));
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("contact.jsp");
        requestDispatcher.forward(request, response);
    }
}