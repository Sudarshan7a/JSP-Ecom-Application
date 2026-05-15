package com.ecommerce.control;

import com.ecommerce.entity.Account;
import com.ecommerce.entity.CartProduct;
import com.ecommerce.entity.Category;
import com.ecommerce.entity.Order;
import com.ecommerce.entity.Product;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

final class DemoStore {
    private DemoStore() {
    }

    static Account createDemoAccount() {
        Account account = new Account();
        account.setId(1);
        account.setUsername("demo");
        account.setPassword("demo123");
        account.setFirstName("RCB");
        account.setLastName("Fan");
        account.setEmail("demo@jsp-ecom.local");
        account.setPhone("9999999999");
        account.setAddress("RCB Stadium, Bengaluru");
        account.setIsSeller(0);
        account.setIsAdmin(0);
        return account;
    }

    static List<Category> createCategories() {
        List<Category> categories = new ArrayList<>();
        categories.add(new Category(1, "Men", 6));
        categories.add(new Category(2, "Women", 2));
        categories.add(new Category(3, "Children", 7));
        return categories;
    }

    static List<Product> createProducts() {
        Account seller = createDemoAccount();
        Category rcbCategory = new Category(1, "Men", 6);
        Category jerseyCategory = new Category(2, "Women", 2);
        Category accessoriesCategory = new Category(3, "Children", 7);

        List<Product> products = new ArrayList<>();
        products.add(new Product(1, "RCB Premium Home Jersey 2024", null, "static/images/puma-rcb-jersey.png", 4999, "Official RCB home jersey with premium fabric and embroidered badge.", jerseyCategory, seller, false, 150));
        products.add(new Product(2, "RCB Away Jersey 2024", null, "static/images/rcb_away_jersey.png", 4999, "Official RCB away jersey in a clean, premium finish.", jerseyCategory, seller, false, 120));
        products.add(new Product(3, "RCB Captain's Polo Shirt", null, "static/images/rcb_polo_shirt.png", 2499, "Premium cotton polo with RCB emblem and relaxed fit.", rcbCategory, seller, false, 100));
        products.add(new Product(4, "RCB Cricket Cap - Premium", null, "static/images/rcb_cap_1778732725515.png", 1299, "Official cricket cap with adjustable strap and UV protection.", accessoriesCategory, seller, false, 200));
        products.add(new Product(5, "RCB Beanie Winter Collection", null, "static/images/rcb_beanie_1778732742365.png", 899, "Soft premium beanie designed for colder match days.", accessoriesCategory, seller, false, 180));
        products.add(new Product(6, "RCB Official Cricket Bat", null, "static/images/rcb_bat_1778732756860.png", 8999, "Professional cricket bat with a bold match-day profile.", rcbCategory, seller, false, 50));
        products.add(new Product(7, "RCB Luxury Watch", null, "static/images/rcb_watch_1778732771650.png", 12999, "Premium sports watch with a luxury finish and water resistance.", accessoriesCategory, seller, false, 30));
        products.add(new Product(8, "RCB Hoodie - Premium Fleece", null, "static/images/rcb_hoodie_1778732947801.png", 3499, "Comfortable fleece hoodie with embroidered RCB branding.", rcbCategory, seller, false, 85));
        products.add(new Product(9, "RCB Track Pants - Premium", null, "static/images/rcb_track_pants_1778732813526.png", 2999, "Tailored track pants with clean side branding and premium fit.", rcbCategory, seller, false, 95));
        products.add(new Product(10, "RCB Sunglasses - UV Protected", null, "static/images/rcb_sunglasses_1778732829789.png", 2499, "Stylish UV-protected sunglasses with a sharp, minimal frame.", accessoriesCategory, seller, false, 70));
        products.add(new Product(11, "RCB Cricket Gloves - Professional", null, "static/images/rcb_gloves_1778732842576.png", 1899, "Professional batting gloves with superior grip and protection.", rcbCategory, seller, false, 110));
        products.add(new Product(12, "RCB Shoulder Bag - Premium", null, "static/images/rcb_shoulder_bag_1778732861300.png", 3999, "Premium nylon shoulder bag with multiple pockets and a crisp look.", accessoriesCategory, seller, false, 60));
        products.add(new Product(13, "RCB Water Bottle - Insulated", null, "static/images/rcb_water_bottle_1778732876256.png", 1499, "Double-walled insulated bottle for long training sessions.", accessoriesCategory, seller, false, 200));
        products.add(new Product(14, "RCB Track Jacket - Limited Edition", null, "static/images/rcb_track_jacket_1778732894975.png", 4499, "Exclusive track jacket with premium material and a tailored fit.", rcbCategory, seller, false, 40));
        products.add(new Product(15, "RCB Match Day Tote", null, "static/images/rcb_tote_1778732921981.png", 1799, "Large premium tote made for match-day essentials.", accessoriesCategory, seller, false, 140));

        return products;
    }

    static Product findProduct(int productId) {
        for (Product product : createProducts()) {
            if (product.getId() == productId) {
                return product;
            }
        }
        return null;
    }

    static List<Product> productsForCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        for (Product product : createProducts()) {
            if (product.getCategory() != null && product.getCategory().getId() == categoryId) {
                products.add(product);
            }
        }
        return products;
    }

    static List<Product> searchProduct(String keyword) {
        List<Product> products = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return createProducts();
        }
        String lowerKeyword = keyword.toLowerCase();
        for (Product product : createProducts()) {
            if ((product.getName() != null && product.getName().toLowerCase().contains(lowerKeyword)) ||
                (product.getDescription() != null && product.getDescription().toLowerCase().contains(lowerKeyword))) {
                products.add(product);
            }
        }
        return products;
    }

    static List<Product> firstPageProducts() {
        return new ArrayList<>(createProducts().subList(0, Math.min(12, createProducts().size())));
    }

    static List<Order> createOrders() {
        List<Order> orders = new ArrayList<>();
        orders.add(new Order(1001, 10497, new Date()));
        orders.add(new Order(1002, 7498, new Date()));
        return orders;
    }

    static List<CartProduct> createOrderDetail(int orderId) {
        Map<Integer, CartProduct> orderItems = new LinkedHashMap<>();
        if (orderId == 1001) {
            addCartProduct(orderItems, 1, 2);
            addCartProduct(orderItems, 4, 1);
        } else {
            addCartProduct(orderItems, 8, 1);
            addCartProduct(orderItems, 10, 2);
        }
        return new ArrayList<>(orderItems.values());
    }

    static List<CartProduct> createCartFromProduct(Product product, int quantity) {
        List<CartProduct> cartProducts = new ArrayList<>();
        if (product != null) {
            cartProducts.add(new CartProduct(product, quantity, product.getPrice()));
        }
        return cartProducts;
    }

    private static void addCartProduct(Map<Integer, CartProduct> orderItems, int productId, int quantity) {
        Product product = findProduct(productId);
        if (product != null) {
            orderItems.put(productId, new CartProduct(product, quantity, product.getPrice()));
        }
    }
}