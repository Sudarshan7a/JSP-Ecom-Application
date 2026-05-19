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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Checkout is reached via a form POST from cart.jsp, but handle GET gracefully
        // (e.g. direct navigation or browser back button)
        HttpSession session = request.getSession();
        if (session.getAttribute("account") == null && !demoMode()) {
            response.sendRedirect("login.jsp");
            return;
        }
        RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
        rd.forward(request, response);
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
            // Prefer the discounted total submitted from the cart form; fall back to session total
            double sessionTotal = session.getAttribute("total_price") != null
                    ? (double) session.getAttribute("total_price") : 0.0;

            String couponCode = request.getParameter("applied-coupon");
            String couponDiscountParam = request.getParameter("coupon-discount");
            String discountedParam = request.getParameter("discounted-total");
            double finalTotal = sessionTotal;
            double discountAmount = 0.0;
            if (discountedParam != null && !discountedParam.isBlank()) {
                try {
                    double submitted = Double.parseDouble(discountedParam);
                    if (submitted >= 0 && submitted <= sessionTotal) {
                        finalTotal = submitted;
                    }
                } catch (NumberFormatException ignored) {}
            }
            // discountAmount here is the percentage (e.g. 25 for RCB25).
            // Compute the actual rupee saving for display purposes.
            double discountPercentage = 0.0;
            if (couponDiscountParam != null && !couponDiscountParam.isBlank()) {
                try {
                    discountPercentage = Double.parseDouble(couponDiscountParam);
                } catch (NumberFormatException ignored) {}
            }
            double rupeeDiscount = Math.round((sessionTotal - finalTotal) * 100.0) / 100.0;
            double subtotal = sessionTotal;

            // Store coupon info in session so checkout.jsp can display the discount row
            if (couponCode != null && !couponCode.isBlank()) {
                session.setAttribute("checkout_coupon_code", couponCode);
                session.setAttribute("checkout_discount_amount", rupeeDiscount);
                session.setAttribute("checkout_final_total", finalTotal);
            } else {
                session.removeAttribute("checkout_coupon_code");
                session.removeAttribute("checkout_discount_amount");
                session.removeAttribute("checkout_final_total");
            }

            Order order = (Order) session.getAttribute("order");
            Account account = (Account) session.getAttribute("account");

            if (demoMode()) {
                account.setFirstName(firstName);
                account.setLastName(lastName);
                account.setAddress(address);
                account.setEmail(email);
                account.setPhone(phone);

                // Save order to session-based history so it appears on order-history page
                @SuppressWarnings("unchecked")
                List<Order> sessionOrders = (List<Order>) session.getAttribute("demo_order_history");
                if (sessionOrders == null) {
                    sessionOrders = new ArrayList<>(DemoStore.createOrders());
                }
                int newOrderId = 1000 + sessionOrders.size() + 1;
                Order placedOrder = new Order(newOrderId, finalTotal, new Date());
                sessionOrders.add(0, placedOrder); // newest first
                session.setAttribute("demo_order_history", sessionOrders);
            } else {
                int accountId = account.getId();
                accountDao.updateProfileInformation(accountId, firstName, lastName, address, email, phone);
                // Pass discountPercentage so createOrderDetail stores the correct per-item paid price
                orderDao.createOrder(account.getId(), subtotal, finalTotal, couponCode, discountPercentage, order != null ? order.getCartProducts() : new java.util.ArrayList<>());
            }

            // Save details for thank-you page display BEFORE clearing session
            if (order != null) {
                session.setAttribute("placed_order_items", order.getCartProducts());
            }
            session.setAttribute("placed_order_total", finalTotal);
            session.setAttribute("placed_order_subtotal", subtotal);
            session.setAttribute("placed_order_coupon_code", couponCode);
            session.setAttribute("placed_order_discount", rupeeDiscount);
            session.setAttribute("placed_order_name", (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : ""));

            // Clear cart and checkout coupon state
            session.removeAttribute("order");
            session.removeAttribute("total_price");
            session.removeAttribute("checkout_coupon_code");
            session.removeAttribute("checkout_discount_amount");
            session.removeAttribute("checkout_final_total");

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("thankyou.jsp");
            requestDispatcher.forward(request, response);
        }
    }
}

