package com.ecommerce.dao;

import com.ecommerce.database.Database;
import com.ecommerce.entity.Account;
import com.ecommerce.entity.CartProduct;
import com.ecommerce.entity.Order;
import com.ecommerce.entity.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    // Call ProductDao class to access with database.
    ProductDao productDao = new ProductDao();
    AccountDao accountDao = new AccountDao();

    public static void main(String[] args) {
        OrderDao orderDao = new OrderDao();
        List<CartProduct> list = orderDao.getOrderDetailHistory(1);
        for (CartProduct cartProduct : list) {
            System.out.println(cartProduct.toString());
        }
    }

    // Method to get last order id in database.
    public int getLastOrderId() {
        String query = "SELECT order_id FROM `order` ORDER BY order_id DESC LIMIT 1";
        int orderId = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                orderId = resultSet.getInt(1);
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
        return orderId;
    }

    // Method to insert order detail information and store per-item paid price
    private void createOrderDetail(List<CartProduct> cartProducts, double discountPercentage) {
        String query = "INSERT INTO order_detail (fk_order_id, fk_product_id, product_quantity, product_price) VALUES (?, ?, ?, ?);";
        // Get latest orderId to insert list of cartProduct to order.
        int orderId = getLastOrderId();
        for (CartProduct cartProduct : cartProducts) {
            productDao.decreaseProductAmount(cartProduct.getProduct().getId(), cartProduct.getQuantity());
            try {
                // Compute the discounted unit price once and store it directly.
                // getOrderDetailHistory() reads this stored price as-is — no second discount pass.
                double unitPrice = cartProduct.getPrice();
                if (discountPercentage > 0) {
                    double factor = (100.0 - discountPercentage) / 100.0;
                    unitPrice = Math.round(unitPrice * factor * 100.0) / 100.0;
                }

                Class.forName("com.mysql.cj.jdbc.Driver");
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, orderId);
                preparedStatement.setInt(2, cartProduct.getProduct().getId());
                preparedStatement.setInt(3, cartProduct.getQuantity());
                preparedStatement.setDouble(4, unitPrice);
                preparedStatement.executeUpdate();
            } catch (SQLException | ClassNotFoundException e) {
                System.out.println("Create order_detail catch:");
                System.out.println(e.getMessage());
            }
        }
    }

    // Method to insert order information to database.
    public void createOrder(int accountId, double subtotalPrice, double totalPrice, String couponCode, double discountAmount, List<CartProduct> cartProducts) {
        String query = "INSERT INTO `order` (fk_account_id, order_total, order_subtotal, coupon_code, discount_amount) VALUES (?, ?, ?, ?, ?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, accountId);
            preparedStatement.setDouble(2, totalPrice);
            preparedStatement.setDouble(3, subtotalPrice);
            preparedStatement.setString(4, couponCode);
            preparedStatement.setDouble(5, discountAmount);
            preparedStatement.executeUpdate();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Create order catch:");
            System.out.println(e.getMessage());
        }

        // Call create order detail method and pass discount percentage so per-item paid price is stored.
        createOrderDetail(cartProducts, discountAmount);
    }

    // Method to get order detail list of a seller.
    public List<CartProduct> getSellerOrderDetail(int productId) {
        List<CartProduct> list = new ArrayList<>();
        String query = "SELECT * FROM order_detail WHERE fk_product_id = " + productId;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Product product = productDao.getProduct(resultSet.getInt(1));
                int productQuantity = resultSet.getInt(3);
                double productPrice = resultSet.getDouble(4);

                list.add(new CartProduct(product, productQuantity, productPrice));
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Query cart product list catch:");
            System.out.println(e.getMessage());
        }
        return list;
    }

    // Method to get order history of a customer.
    public List<Order> getOrderHistory(int accountId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM `order` WHERE fk_account_id = " + accountId;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int orderId = resultSet.getInt(1);
                double orderTotal = resultSet.getDouble(3);
                Date orderDate = resultSet.getDate(4);

                list.add(new Order(orderId, orderTotal, orderDate));
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Order history catch:");
            System.out.println(e.getMessage());
        }
        return list;
    }

    // Method to get order detail history.
    public List<CartProduct> getOrderDetailHistory(int orderId) {
        List<CartProduct> list = new ArrayList<>();
        // product_price in order_detail already stores the final paid price (discounted at order time).
        // Do NOT re-apply any discount here — just read the stored price directly.
        String detailQuery = "SELECT fk_product_id, product_quantity, product_price FROM order_detail WHERE fk_order_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();

            preparedStatement = connection.prepareStatement(detailQuery);
            preparedStatement.setInt(1, orderId);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int productId = resultSet.getInt("fk_product_id");
                int quantity = resultSet.getInt("product_quantity");
                double unitPrice = resultSet.getDouble("product_price");

                Product product = productDao.getProduct(productId);
                list.add(new CartProduct(product, quantity, unitPrice));
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Get order detail catch:");
            System.out.println(e.getMessage());
        }
        return list;
    }
}
