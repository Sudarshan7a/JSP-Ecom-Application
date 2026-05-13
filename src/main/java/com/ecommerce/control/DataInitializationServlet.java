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
        // Check if products exist, if not, initialize with luxury sports merchandise
        List<Product> existingProducts = productDao.getAllProducts();
        if (existingProducts == null || existingProducts.isEmpty()) {
            initializeProducts();
        }
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
                    "https://images.puma.com/image/upload/f_auto,q_auto/products/rcb-jersey-home.jpg",
                    4999, "Official RCB home jersey with premium fabric and embroidered badge. 100% polyester with moisture-wicking technology.",
                    rcbCategory, seller, false, 150),

                new Product(2, "RCB Away Jersey 2024", null,
                    "https://images.puma.com/image/upload/f_auto,q_auto/products/rcb-jersey-away.jpg",
                    4999, "Official RCB away jersey in elegant white. Perfect for match day and casual wear.",
                    rcbCategory, seller, false, 120),

                new Product(3, "RCB Captain's Polo Shirt", null,
                    "https://images.unsplash.com/photo-1618762052596-8df5ff6abae2?w=500&h=500&fit=crop",
                    2499, "Premium cotton polo with RCB emblem. Ideal for corporate events and casual outings.",
                    rcbCategory, seller, false, 100),

                new Product(4, "RCB Cricket Cap - Premium", null,
                    "https://images.unsplash.com/photo-1616076543084-e2d18d7af33d?w=500&h=500&fit=crop",
                    1299, "Official RCB cricket cap with adjustable strap. UV protected fabric.",
                    accessoriesCategory, seller, false, 200),

                new Product(5, "RCB Beanie Winter Collection", null,
                    "https://images.unsplash.com/photo-1584515933487-c61b8f1b912f?w=500&h=500&fit=crop",
                    899, "Premium winter beanie in RCB colors. Soft acrylic blend, perfect for cold weather.",
                    accessoriesCategory, seller, false, 180),

                new Product(6, "RCB Official Cricket Bat", null,
                    "https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=500&h=500&fit=crop",
                    8999, "Professional cricket bat with RCB branding. Suitable for all level players.",
                    rcbCategory, seller, false, 50),

                new Product(7, "RCB Cricket Ball - Tournament Grade", null,
                    "https://images.unsplash.com/photo-1618595032151-cf04bbc2b2f0?w=500&h=500&fit=crop",
                    699, "Official tournament grade cricket ball with RCB embossing.",
                    rcbCategory, seller, false, 300),

                new Product(8, "RCB Luxury Watch", null,
                    "https://images.unsplash.com/photo-1523170335684-f042070fe1c7?w=500&h=500&fit=crop",
                    12999, "Premium sports watch with RCB logo. Water resistant up to 50m.",
                    accessoriesCategory, seller, false, 30),

                new Product(9, "RCB Hoodie - Premium Fleece", null,
                    "https://images.unsplash.com/photo-1556821840-108801c026d6?w=500&h=500&fit=crop",
                    3499, "Comfortable premium fleece hoodie with RCB embroidery.",
                    rcbCategory, seller, false, 85),

                new Product(10, "RCB Track Pants - Premium", null,
                    "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&h=500&fit=crop",
                    2999, "Premium track pants with RCB branding and side pockets.",
                    rcbCategory, seller, false, 95),

                new Product(11, "RCB Sunglasses - UV Protected", null,
                    "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&h=500&fit=crop",
                    2499, "Stylish UV protected sunglasses with RCB design.",
                    accessoriesCategory, seller, false, 70),

                new Product(12, "RCB Cricket Gloves - Professional", null,
                    "https://images.unsplash.com/photo-1604987556176-b34ee4e4eb0e?w=500&h=500&fit=crop",
                    1899, "Professional cricket batting gloves with superior grip and protection.",
                    rcbCategory, seller, false, 110),

                new Product(13, "RCB Shoulder Bag - Premium", null,
                    "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop",
                    3999, "Premium nylon shoulder bag with RCB emblem and multiple pockets.",
                    accessoriesCategory, seller, false, 60),

                new Product(14, "RCB Water Bottle - Insulated", null,
                    "https://images.unsplash.com/photo-1598905088695-cd9fbcee40ce?w=500&h=500&fit=crop",
                    1499, "Double-walled insulated water bottle keeps drinks cool for 24 hours.",
                    accessoriesCategory, seller, false, 200),

                new Product(15, "RCB Track Jacket - Limited Edition", null,
                    "https://images.unsplash.com/photo-1542272604-787c62d465d1?w=500&h=500&fit=crop",
                    4499, "Exclusive limited edition track jacket with premium material.",
                    rcbCategory, seller, false, 40)
            };

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
