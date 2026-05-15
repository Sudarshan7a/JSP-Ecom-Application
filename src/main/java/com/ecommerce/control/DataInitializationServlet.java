package com.ecommerce.control;

import com.ecommerce.dao.CategoryDao;
import com.ecommerce.dao.ProductDao;
import com.ecommerce.entity.Category;
import com.ecommerce.entity.Product;
import com.ecommerce.entity.Account;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import java.util.List;

@WebListener
public class DataInitializationServlet implements ServletContextListener {
    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Always enforce the RCB merchandise as the core dataset
        initializeProducts();
    }

    private void initializeProducts() {
        try {
            // Create categories
            Category rcbCategory = new Category();
            rcbCategory.setId(1);
            rcbCategory.setName("RCB Merchandise");
            
            Category jerseyCategory = new Category();
            jerseyCategory.setId(2);
            jerseyCategory.setName("Jerseys");
            
            Category accessoriesCategory = new Category();
            accessoriesCategory.setId(3);
            accessoriesCategory.setName("Accessories");
            
            // Create seller account
            Account seller = new Account();
            seller.setId(1);
            seller.setUsername("RCB Store");

            // Premium RCB Products
            Product[] rcbProducts = {
                new Product(1, "RCB Premium Home Jersey 2024", null, 
                    "static/images/puma-rcb-jersey.png",
                    4999, "Official RCB home jersey with premium fabric and embroidered badge.",
                    rcbCategory, seller, false, 150),

                new Product(2, "RCB Away Jersey 2024", null,
                    "static/images/rcb_away_jersey.png",
                    4999, "Official RCB away jersey in a clean, premium finish.",
                    rcbCategory, seller, false, 120),

                new Product(3, "RCB Captain's Polo Shirt", null,
                    "static/images/rcb_polo_shirt.png",
                    2499, "Premium cotton polo with RCB emblem and relaxed fit.",
                    rcbCategory, seller, false, 100),

                new Product(4, "RCB Cricket Cap - Premium", null,
                    "static/images/rcb_cap_1778732725515.png",
                    1299, "Official cricket cap with adjustable strap and UV protection.",
                    accessoriesCategory, seller, false, 200),

                new Product(5, "RCB Beanie Winter Collection", null,
                    "static/images/rcb_beanie_1778732742365.png",
                    899, "Soft premium beanie designed for colder match days.",
                    accessoriesCategory, seller, false, 180),

                new Product(6, "RCB Official Cricket Bat", null,
                    "static/images/rcb_bat_1778732756860.png",
                    8999, "Professional cricket bat with a bold match-day profile.",
                    rcbCategory, seller, false, 50),

                new Product(7, "RCB Luxury Watch", null,
                    "static/images/rcb_watch_1778732771650.png",
                    12999, "Premium sports watch with a luxury finish and water resistance.",
                    accessoriesCategory, seller, false, 30),

                new Product(8, "RCB Hoodie - Premium Fleece", null,
                    "static/images/rcb_hoodie_1778732947801.png",
                    3499, "Comfortable fleece hoodie with embroidered RCB branding.",
                    rcbCategory, seller, false, 85),

                new Product(9, "RCB Track Pants - Premium", null,
                    "static/images/rcb_track_pants_1778732813526.png",
                    2999, "Tailored track pants with clean side branding and premium fit.",
                    rcbCategory, seller, false, 95),

                new Product(10, "RCB Sunglasses - UV Protected", null,
                    "static/images/rcb_sunglasses_1778732829789.png",
                    2499, "Stylish UV-protected sunglasses with a sharp, minimal frame.",
                    accessoriesCategory, seller, false, 70),

                new Product(11, "RCB Cricket Gloves - Professional", null,
                    "static/images/rcb_gloves_1778732842576.png",
                    1899, "Professional batting gloves with superior grip and protection.",
                    rcbCategory, seller, false, 110),

                new Product(12, "RCB Shoulder Bag - Premium", null,
                    "static/images/rcb_shoulder_bag_1778732861300.png",
                    3999, "Premium nylon shoulder bag with multiple pockets and a crisp look.",
                    accessoriesCategory, seller, false, 60),

                new Product(13, "RCB Water Bottle - Insulated", null,
                    "static/images/rcb_water_bottle_1778732876256.png",
                    1499, "Double-walled insulated bottle for long training sessions.",
                    accessoriesCategory, seller, false, 200),

                new Product(14, "RCB Track Jacket - Limited Edition", null,
                    "static/images/rcb_track_jacket_1778732894975.png",
                    4499, "Exclusive track jacket with premium material and a tailored fit.",
                    rcbCategory, seller, false, 40),
                    
                new Product(15, "RCB Match Day Tote", null,
                    "static/images/rcb_tote_1778732921981.png",
                    1799, "Large premium tote made for match-day essentials.",
                    accessoriesCategory, seller, false, 140)
            };

            // Ensure product_image_url column exists
            try {
                java.sql.Connection conn = new com.ecommerce.database.Database().getConnection();
                java.sql.Statement stmt = conn.createStatement();
                try {
                    stmt.execute("ALTER TABLE product ADD COLUMN product_image_url varchar(1000) DEFAULT NULL");
                } catch (Exception ignore) {
                    // Column might already exist
                }
                stmt.close();
                conn.close();
            } catch (Exception e) {
                System.out.println("Could not alter table: " + e.getMessage());
            }

            // Clean up any extra dummy products to ensure pagination is perfect
            try {
                java.sql.Connection conn = new com.ecommerce.database.Database().getConnection();
                java.sql.Statement stmt = conn.createStatement();
                stmt.execute("UPDATE product SET product_is_deleted = true WHERE product_id > 15");
                stmt.close();
                conn.close();
            } catch (Exception ignore) {
                // Ignore if it fails
            }

            // Insert products into database
            for (Product product : rcbProducts) {
                productDao.insertProduct(product);
            }
            
            System.out.println("Database initialized with " + rcbProducts.length + " luxury RCB products!");
        } catch (Exception e) {
            System.out.println("Error initializing products: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
