package com.ecommerce.control;

import com.ecommerce.dao.OrderDao;
import com.ecommerce.entity.CartProduct;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "orderDetailControl", value = "/order-detail")
public class orderDetailControl extends HttpServlet {
    // Call DAO class to access with database.
    OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get order id from request.
        String orderIdStr = request.getParameter("order_id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect("order-history");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("order-history");
            return;
        }

        // Get order by id from database.
        List<CartProduct> list = orderDao.getOrderDetailHistory(orderId);
        if (list == null || list.isEmpty()) {
            list = DemoStore.createOrderDetail(orderId);
        }

        request.setAttribute("order_detail_list", list);
        // Get request dispatcher and render to order-detail page.
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("order-detail.jsp");
        requestDispatcher.forward(request, response);
    }
}
