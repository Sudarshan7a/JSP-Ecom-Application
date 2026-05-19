package com.ecommerce.control;

import com.ecommerce.dao.OrderDao;
import com.ecommerce.entity.Account;
import com.ecommerce.entity.Order;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderHistoryControl", value = "/order-history")
public class OrderHistoryControl extends HttpServlet {
    // Call DAO class to access with database.
    OrderDao orderDao = new OrderDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get account from session.
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            account = DemoStore.createDemoAccount();
            session.setAttribute("account", account);
        }

        List<Order> orderList;

        if (demoMode()) {
            // In demo mode, use session-stored orders (includes any placed during this session)
            @SuppressWarnings("unchecked")
            List<Order> sessionOrders = (List<Order>) session.getAttribute("demo_order_history");
            if (sessionOrders != null) {
                orderList = sessionOrders;
            } else {
                orderList = DemoStore.createOrders();
            }
        } else {
            // In DB mode, query from database — show empty state for new users, no fake data
            orderList = orderDao.getOrderHistory(account.getId());
            if (orderList == null) {
                orderList = new java.util.ArrayList<>();
            }
        }

        request.setAttribute("order_list", orderList);
        // Set attribute active for order history tab.
        request.setAttribute("order_history_active", "active");
        // Get request dispatcher and render to order-history page.
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("order-history.jsp");
        requestDispatcher.forward(request, response);
    }
}
