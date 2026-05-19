package com.ecommerce.control;

import com.ecommerce.dao.AccountDao;
import com.ecommerce.entity.Account;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet(name = "ProfileControl", value = "/profile-page")
@MultipartConfig
public class ProfileControl extends HttpServlet {
    // Call DAO class to access with the database.
    AccountDao accountDao = new AccountDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("profile-page.jsp");
        requestDispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Guard: if not logged in, redirect to login
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String firstName = request.getParameter("first-name");
        String lastName = request.getParameter("last-name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Set default profile image for account.
        Part part = request.getPart("profile-image");
        InputStream inputStream = null;
        if (part != null) {
            inputStream = part.getInputStream();
        }

        if (demoMode()) {
            account.setFirstName(firstName);
            account.setLastName(lastName);
            account.setAddress(address);
            account.setEmail(email);
            account.setPhone(phone);
            session.setAttribute("account", account);
        } else {
            accountDao.editProfileInformation(account.getId(), firstName, lastName, address, email, phone, inputStream);
        }
        
        response.sendRedirect("profile-page");
    }
}
