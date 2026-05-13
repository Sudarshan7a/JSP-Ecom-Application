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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ShopControl", value = "/shop")
public class ShopControl extends HttpServlet {
    // Call DAO class to access with database.
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get page number from request.
        String index = request.getParameter("index");
        if (index == null) {
            index = "1";
        }

        List<Product> fallbackProducts = DemoStore.createProducts();

        List<Product> productList;
        if (demoMode()) {
            int pageIndex = Integer.parseInt(index);
            int fromIndex = Math.max(0, (pageIndex - 1) * 12);
            int toIndex = Math.min(fallbackProducts.size(), fromIndex + 12);
            productList = fromIndex < fallbackProducts.size() ? fallbackProducts.subList(fromIndex, toIndex) : new ArrayList<>();
        } else {
            productList = productDao.get12ProductsOfPage(Integer.parseInt(index));
        }

        if (productList == null || productList.isEmpty()) {
            int pageIndex = Integer.parseInt(index);
            int fromIndex = Math.max(0, (pageIndex - 1) * 12);
            int toIndex = Math.min(fallbackProducts.size(), fromIndex + 12);
            if (fromIndex < fallbackProducts.size()) {
                productList = fallbackProducts.subList(fromIndex, toIndex);
            } else {
                productList = new ArrayList<>();
            }
        }

        List<Category> categoryList = demoMode() ? DemoStore.createCategories() : categoryDao.getAllCategories();
        if (categoryList == null || categoryList.isEmpty()) {
            categoryList = DemoStore.createCategories();
        }

        int totalProduct = demoMode() ? fallbackProducts.size() : productDao.getTotalNumberOfProducts();
        if (totalProduct <= 0) {
            totalProduct = fallbackProducts.size();
        }
        int totalPages = totalProduct / 12;
        if (totalProduct % 12 != 0) {
            totalPages++;
        }

        // Set attribute active class for home in header and page number.
        String active = "active";

        request.setAttribute("product_list", productList);
        request.setAttribute("category_list", categoryList);
        request.setAttribute("total_pages", totalPages);
        request.setAttribute("shop_active", active);
        request.setAttribute("page_active", index);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("shop.jsp");
        requestDispatcher.forward(request, response);
    }
}
