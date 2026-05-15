package com.ecommerce.control;

import com.ecommerce.dao.ProductDao;
import com.ecommerce.entity.Product;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "RemoveProduct", value = "/remove-product")
public class RemoveProductControl extends HttpServlet {
    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (demoMode()) { response.sendRedirect("/"); return; }
        // Get the id of the product that need to remove from request.
        int productId = Integer.parseInt(request.getParameter("product-id"));
        // Remove product from database.
        ProductDao productDao = new ProductDao();
        Product product = productDao.getProduct(productId);
        productDao.removeProduct(product);

        response.sendRedirect("product-management");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
