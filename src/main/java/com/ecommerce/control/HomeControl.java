package com.ecommerce.control;

import com.ecommerce.dao.CategoryDao;
import com.ecommerce.dao.ProductDao;
import com.ecommerce.entity.Category;
import com.ecommerce.entity.Product;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeControl", value = "")
public class HomeControl extends HttpServlet {
    // Call DAO class to access with database.
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Product> productList = demoMode() ? DemoStore.createProducts() : productDao.getAllProducts();
        if (productList == null || productList.isEmpty()) {
            productList = DemoStore.createProducts();
        }

        List<Category> categoryList = demoMode() ? DemoStore.createCategories() : categoryDao.getAllCategories();
        if (categoryList == null || categoryList.isEmpty()) {
            categoryList = DemoStore.createCategories();
        }


        request.setAttribute("product_list", productList);
        request.setAttribute("category_list", categoryList);
        // Set attribute active class for home in header.
        request.setAttribute("home_active", "active");
        // Get request dispatcher and render to index page.
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("index.jsp");
        requestDispatcher.forward(request, response);
    }
}