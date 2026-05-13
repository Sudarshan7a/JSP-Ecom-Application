package com.ecommerce.control;

import com.ecommerce.dao.AccountDao;
import com.ecommerce.dao.OrderDao;
import com.ecommerce.entity.Account;
import com.ecommerce.entity.Order;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CheckoutControl", value = "/checkout")
public class CheckoutControl extends HttpServlet {
    // Call DAO class to access with database.
    OrderDao orderDao = new OrderDao();
    AccountDao accountDao = new AccountDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Get information from input field.
        String firstName = request.getParameter("first-name");
        String lastName = request.getParameter("last-name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (session.getAttribute("account") == null) {
            if (demoMode()) {
                session.setAttribute("account", DemoStore.createDemoAccount());
            } else {
                response.sendRedirect("login.jsp");
                return;
            }
        }
        if (session.getAttribute("account") != null) {
            double totalPrice = (double) session.getAttribute("total_price");
            Order order = (Order) session.getAttribute("order");
            Account account = (Account) session.getAttribute("account");

            if (demoMode()) {
                account.setFirstName(firstName);
                account.setLastName(lastName);
                account.setAddress(address);
                account.setEmail(email);
                account.setPhone(phone);
            } else {
                int accountId = account.getId();
                accountDao.updateProfileInformation(accountId, firstName, lastName, address, email, phone);
                orderDao.createOrder(account.getId(), totalPrice, order.getCartProducts());
            }
            session.removeAttribute("order");
            session.removeAttribute("total_price");

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("thankyou.jsp");
            requestDispatcher.forward(request, response);
        }
    }
}
