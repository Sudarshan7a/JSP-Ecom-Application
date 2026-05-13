package com.ecommerce.control;

import com.ecommerce.dao.ProductDao;
import com.ecommerce.entity.Product;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetail", value = "/product-detail")
public class ProductDetail extends HttpServlet {
    // Call DAO class to access with database.
    ProductDao productDao = new ProductDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the sending link from out of stock request or not.
        boolean alert = request.getParameter("invalid-quantity") != null;
        // Get the id of selected product.
        int id = Integer.parseInt(request.getParameter("id"));

        // Get product from database with the given id.
        Product product;
        if (demoMode()) {
            product = DemoStore.findProduct(id);
        } else {
            product = productDao.getProduct(id);
        }
        
        if (product == null || product.getName() == null || product.getName().trim().isEmpty()) {
            product = DemoStore.findProduct(id);
        }

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Check number product available.
        String disabled = "";
        if (product.getAmount() <= 0) {
            disabled = "disabled";
        }

        // Get all products for feature section.
        List<Product> productList;
        if (demoMode()) {
            productList = DemoStore.createProducts();
        } else {
            productList = productDao.getAllProducts();
        }
        
        if (productList == null || productList.isEmpty()) {
            productList = DemoStore.createProducts();
        }

        // Set attribute active class for home in header.
        String active = "active";

        request.setAttribute("alert", alert);
        request.setAttribute("disabled", disabled);
        request.setAttribute("shop_active", active);
        request.setAttribute("product", product);
        request.setAttribute("product_list", productList);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("product-detail.jsp");
        requestDispatcher.forward(request, response);
    }
}
