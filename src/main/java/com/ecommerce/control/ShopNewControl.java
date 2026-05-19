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

@WebServlet(name = "ShopNewControl", value = "/shop-new")
public class ShopNewControl extends HttpServlet {
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();

    private boolean demoMode() {
        String user = System.getenv("ECOM_DB_USER");
        String password = System.getenv("ECOM_DB_PASSWORD");
        return (user == null || user.isBlank() || password == null || password.isBlank());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String index = request.getParameter("index");
        if (index == null) index = "1";

        List<Product> fallbackProducts = DemoStore.createProducts();

        List<Product> productList;
        if (demoMode()) {
            int pageIndex = Integer.parseInt(index);
            int fromIndex = Math.max(0, (pageIndex - 1) * 12);
            int toIndex = Math.min(fallbackProducts.size(), fromIndex + 12);
            productList = fromIndex < fallbackProducts.size()
                    ? fallbackProducts.subList(fromIndex, toIndex)
                    : new ArrayList<>();
        } else {
            productList = productDao.get12ProductsOfPage(Integer.parseInt(index));
            if (productList == null || productList.isEmpty()) {
                productList = fallbackProducts;
            }
        }

        List<Category> categoryList = demoMode() ? DemoStore.createCategories() : categoryDao.getAllCategories();
        if (categoryList == null || categoryList.isEmpty()) {
            categoryList = DemoStore.createCategories();
        }

        int totalProduct = demoMode() ? fallbackProducts.size() : productDao.getTotalNumberOfProducts();
        if (totalProduct <= 0) totalProduct = fallbackProducts.size();
        int totalPages = totalProduct / 12 + (totalProduct % 12 != 0 ? 1 : 0);

        request.setAttribute("product_list", productList);
        request.setAttribute("category_list", categoryList);
        request.setAttribute("total_pages", totalPages);
        request.setAttribute("page_active", index);
        request.setAttribute("shop_active", "active");

        RequestDispatcher rd = request.getRequestDispatcher("shop-new.jsp");
        rd.forward(request, response);
    }
}
