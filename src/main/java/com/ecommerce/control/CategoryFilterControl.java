package com.ecommerce.control;

import com.ecommerce.dao.CategoryDao;
import com.ecommerce.dao.ProductDao;
import com.ecommerce.entity.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CategoryFilterControl", value = "/api/category-filter")
public class CategoryFilterControl extends HttpServlet {
    ProductDao productDao = new ProductDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String categoryIdStr = request.getParameter("category_id");
            int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;

            List<Product> productList;
            if (demoMode()) {
                productList = (categoryId > 0) ? DemoStore.productsForCategory(categoryId) : DemoStore.createProducts();
            } else {
                productList = (categoryId > 0) ? productDao.getAllCategoryProducts(categoryId) : productDao.getFirstPageProducts();
            }

            if (productList == null || productList.isEmpty()) {
                productList = (categoryId > 0) ? DemoStore.productsForCategory(categoryId) : DemoStore.createProducts();
            }

            // Build JSON response manually
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\": true,");
            json.append("\"count\": ").append(productList.size()).append(",");
            json.append("\"products\": [");

            for (int i = 0; i < productList.size(); i++) {
                Product p = productList.get(i);
                json.append("{");
                json.append("\"id\": ").append(p.getId()).append(",");
                json.append("\"name\": \"").append(escapeJson(p.getName())).append("\",");
                json.append("\"description\": \"").append(escapeJson(p.getDescription())).append("\",");
                json.append("\"imageSource\": \"").append(escapeJson(p.getImageSource())).append("\",");
                json.append("\"price\": ").append(p.getPrice()).append(",");
                if (p.getCategory() != null) {
                    json.append("\"category\": {");
                    json.append("\"id\": ").append(p.getCategory().getId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(p.getCategory().getName())).append("\"");
                    json.append("}");
                } else {
                    json.append("\"category\": null");
                }
                json.append("}");
                if (i < productList.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]");
            json.append("}");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            out.print("{");
            out.print("\"success\": false,");
            out.print("\"error\": \"" + escapeJson(e.getMessage()) + "\"");
            out.print("}");
            out.flush();
        }
    }
}

