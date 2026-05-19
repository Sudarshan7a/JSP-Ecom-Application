package com.ecommerce.dao;

import com.ecommerce.database.Database;
import com.ecommerce.entity.Account;
import com.ecommerce.entity.Category;
import com.ecommerce.entity.Product;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class ProductDao {
    private static final String ONLINE_PRODUCTS_FIRST = " ORDER BY product_id ASC";

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    // Call DAO class to access other entities' database.
    AccountDao accountDao = new AccountDao();
    CategoryDao categoryDao = new CategoryDao();

    public static void main(String[] args) {
        ProductDao productDao = new ProductDao();
        List<Product> list = productDao.getSellerProducts(1);
        for (Product product : list) {
            System.out.println(product.toString());
        }
    }

    // Method to get blob image from database.
    private String getBase64Image(Blob blob) throws SQLException, IOException {
        if (blob == null) {
            return null;
        }
        try (InputStream inputStream = blob.getBinaryStream();
             ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                byteArrayOutputStream.write(buffer, 0, bytesRead);
            }
            byte[] imageBytes = byteArrayOutputStream.toByteArray();

            return Base64.getEncoder().encodeToString(imageBytes);
        }
    }

    private boolean hasColumn(ResultSet resultSet, String columnName) throws SQLException {
        ResultSetMetaData metaData = resultSet.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))) {
                return true;
            }
        }
        return false;
    }

    private String getOptionalString(ResultSet resultSet, String columnName) throws SQLException {
        if (!hasColumn(resultSet, columnName)) {
            return null;
        }
        return resultSet.getString(columnName);
    }

    // Method to execute query to get list products.
    private List<Product> getListProductQuery(String query) {
        List<Product> list = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int id = resultSet.getInt("product_id");
                String name = resultSet.getString("product_name");
                double price = resultSet.getDouble("product_price");
                String description = resultSet.getString("product_description");
                Category category = categoryDao.getCategory(resultSet.getInt("fk_category_id"));
                Account account = accountDao.getAccount(resultSet.getInt("fk_account_id"));
                boolean isDelete = resultSet.getBoolean("product_is_deleted");
                int amount = resultSet.getInt("product_amount");

                // Get base64 image to display.
                Blob blob = resultSet.getBlob("product_image");
                String base64Image = getBase64Image(blob);
                String imageUrl = getOptionalString(resultSet, "product_image_url");

                list.add(new Product(id, name, base64Image, imageUrl, price, description, category, account, isDelete, amount));
            }
        } catch (SQLException | ClassNotFoundException | IOException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    // Method to get all products from database.
    public List<Product> getAllProducts() {
        String query = "SELECT * FROM product WHERE product_is_deleted = false" + ONLINE_PRODUCTS_FIRST;
        return getListProductQuery(query);
    }

    // Method to get a product by its id from database.
    public Product getProduct(int productId) {
        Product product = new Product();
        String query = "SELECT * FROM product WHERE product_id = " + productId;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                product.setId(resultSet.getInt("product_id"));
                product.setName(resultSet.getString("product_name"));
                product.setBase64Image(getBase64Image(resultSet.getBlob("product_image")));
                product.setImageUrl(getOptionalString(resultSet, "product_image_url"));
                product.setPrice(resultSet.getDouble("product_price"));
                product.setDescription(resultSet.getString("product_description"));
                product.setCategory(categoryDao.getCategory(resultSet.getInt("fk_category_id")));
                product.setAccount(accountDao.getAccount(resultSet.getInt("fk_account_id")));
                product.setDeleted(resultSet.getBoolean("product_is_deleted"));
                product.setAmount(resultSet.getInt("product_amount"));
            }
        } catch (SQLException | ClassNotFoundException | IOException e) {
            System.out.println(e.getMessage());
        }
        return product;
    }

    // Method to get a categories by its id from database.
    public List<Product> getAllCategoryProducts(int category_id) {
        String query = "SELECT * FROM product WHERE fk_category_id = " + category_id + " AND product_is_deleted = false" + ONLINE_PRODUCTS_FIRST;
        return getListProductQuery(query);
    }

    // Method to search a product by a keyword.
    public List<Product> searchProduct(String keyword) {
        String query = "SELECT * FROM product WHERE product_name like '%" + keyword + "%' AND product_is_deleted = false" + ONLINE_PRODUCTS_FIRST;
        return getListProductQuery(query);
    }

    // Method to get all products of a seller.
    public List<Product> getSellerProducts(int sellerId) {
        String query = "SELECT * FROM product WHERE fk_account_id = " + sellerId + ONLINE_PRODUCTS_FIRST;
        return getListProductQuery(query);
    }

    // Method to remove a product from database by its id.
    public void removeProduct(Product product) {
        // Get id of the product.
        int productId = product.getId();

        String query = "UPDATE product SET product_is_deleted = true WHERE product_id = " + productId;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to add product to database.
    public void addProduct(String productName, InputStream productImage, double productPrice, String productDescription, int productCategory, int sellerId, int productAmount) {
        String query = "INSERT INTO product (product_name, product_image, product_price, product_description, fk_category_id, fk_account_id, product_is_deleted, product_amount) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, productName);
            preparedStatement.setBinaryStream(2, productImage);
            preparedStatement.setDouble(3, productPrice);
            preparedStatement.setString(4, productDescription);
            preparedStatement.setInt(5, productCategory);
            preparedStatement.setInt(6, sellerId);
            preparedStatement.setBoolean(7, false);
            preparedStatement.setInt(8, productAmount);
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to edit product in database.
    public void editProduct(int productId, String productName, InputStream productImage, double productPrice, String productDescription, int productCategory, int productAmount) {
        String query = "UPDATE product SET product_name = ?, product_image = ?, product_price = ?, product_description = ?, fk_category_id = ?, product_amount = ? WHERE product_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, productName);
            preparedStatement.setBinaryStream(2, productImage);
            preparedStatement.setDouble(3, productPrice);
            preparedStatement.setString(4, productDescription);
            preparedStatement.setInt(5, productCategory);
            preparedStatement.setInt(6, productAmount);
            preparedStatement.setInt(7, productId);
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to get 12 products to display on each page.
    public List<Product> get12ProductsOfPage(int index) {
        String query = "SELECT * FROM product WHERE product_is_deleted = false" + ONLINE_PRODUCTS_FIRST + " LIMIT " + ((index - 1) * 12) + ", 12";
        return getListProductQuery(query);
    }

    // Method to get total products in database.
    public int getTotalNumberOfProducts() {
        int totalProduct = 0;
        String query = "SELECT COUNT(*) FROM product WHERE product_is_deleted = false";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                totalProduct = resultSet.getInt(1);
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
        return totalProduct;
    }

    // Method to decrease new amount of products.
    public void decreaseProductAmount(int productId, int productAmount) {
        String query = "UPDATE product SET product_amount = product_amount - ? WHERE product_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, productAmount);
            preparedStatement.setInt(2, productId);
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void insertProduct(Product product) {
        String query = "INSERT INTO product (product_id, product_name, product_price, product_description, fk_category_id, fk_account_id, product_is_deleted, product_amount, product_image_url) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE product_name=VALUES(product_name), product_price=VALUES(product_price), product_description=VALUES(product_description), product_image_url=VALUES(product_image_url), product_is_deleted=VALUES(product_is_deleted), product_amount=VALUES(product_amount), fk_category_id=VALUES(fk_category_id), fk_account_id=VALUES(fk_account_id), product_image=NULL";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = new Database().getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, product.getId());
            preparedStatement.setString(2, product.getName());
            preparedStatement.setDouble(3, product.getPrice());
            preparedStatement.setString(4, product.getDescription());
            preparedStatement.setInt(5, product.getCategory() != null ? product.getCategory().getId() : 1);
            preparedStatement.setInt(6, product.getAccount() != null ? product.getAccount().getId() : 1);
            preparedStatement.setBoolean(7, product.getIsDeleted());
            preparedStatement.setInt(8, product.getAmount());
            preparedStatement.setString(9, product.getImageUrl());
            preparedStatement.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
