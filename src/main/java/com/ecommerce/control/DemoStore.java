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
        categories.add(new Category(1, "RCB Merchandise", 7));
        categories.add(new Category(2, "Jerseys", 4));
        categories.add(new Category(3, "Accessories", 4));
        return categories;
    }

    static List<Product> createProducts() {
        Account seller = createDemoAccount();
        Category rcbCategory = new Category(1, "RCB Merchandise", 7);
        Category jerseyCategory = new Category(2, "Jerseys", 4);
        Category accessoriesCategory = new Category(3, "Accessories", 4);

        List<Product> products = new ArrayList<>();
        products.add(new Product(1, "RCB Premium Home Jersey 2024", null, "static/images/puma-rcb-jersey.png", 4999, "Official RCB home jersey with premium fabric and embroidered badge.", jerseyCategory, seller, false, 150));
        products.add(new Product(2, "RCB Away Jersey 2024", null, "static/images/cloth_1.jpg", 4999, "Official RCB away jersey in a clean, premium finish.", jerseyCategory, seller, false, 120));
        products.add(new Product(3, "RCB Captain's Polo Shirt", null, "static/images/cloth_2.jpg", 2499, "Premium cotton polo with RCB emblem and relaxed fit.", rcbCategory, seller, false, 100));
        products.add(new Product(4, "RCB Cricket Cap - Premium", null, "static/images/cloth_3.jpg", 1299, "Official cricket cap with adjustable strap and UV protection.", accessoriesCategory, seller, false, 200));
        products.add(new Product(5, "RCB Beanie Winter Collection", null, "static/images/Women.jpg", 899, "Soft premium beanie designed for colder match days.", accessoriesCategory, seller, false, 180));
        products.add(new Product(6, "RCB Official Cricket Bat", null, "static/images/hero_1.jpg", 8999, "Professional cricket bat with a bold match-day profile.", rcbCategory, seller, false, 50));
        products.add(new Product(7, "RCB Luxury Watch", null, "static/images/logo.png", 12999, "Premium sports watch with a luxury finish and water resistance.", accessoriesCategory, seller, false, 30));
        products.add(new Product(8, "RCB Hoodie - Premium Fleece", null, "static/images/Men.jpg", 3499, "Comfortable fleece hoodie with embroidered RCB branding.", rcbCategory, seller, false, 85));
        products.add(new Product(9, "RCB Track Pants - Premium", null, "static/images/person_1.jpg", 2999, "Tailored track pants with clean side branding and premium fit.", rcbCategory, seller, false, 95));
        products.add(new Product(10, "RCB Sunglasses - UV Protected", null, "static/images/shoe.png", 2499, "Stylish UV-protected sunglasses with a sharp, minimal frame.", accessoriesCategory, seller, false, 70));
        products.add(new Product(11, "RCB Cricket Gloves - Professional", null, "static/images/shoe_1.jpg", 1899, "Professional batting gloves with superior grip and protection.", rcbCategory, seller, false, 110));
        products.add(new Product(12, "RCB Shoulder Bag - Premium", null, "static/images/person_2.jpg", 3999, "Premium nylon shoulder bag with multiple pockets and a crisp look.", accessoriesCategory, seller, false, 60));
        products.add(new Product(13, "RCB Water Bottle - Insulated", null, "static/images/person_3.jpg", 1499, "Double-walled insulated bottle for long training sessions.", accessoriesCategory, seller, false, 200));
        products.add(new Product(14, "RCB Track Jacket - Limited Edition", null, "static/images/person_4.jpg", 4499, "Exclusive track jacket with premium material and a tailored fit.", rcbCategory, seller, false, 40));
        products.add(new Product(15, "RCB Match Day Tote", null, "static/images/red-bull-racing-capsule.svg", 1799, "Large premium tote made for match-day essentials.", accessoriesCategory, seller, false, 140));
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