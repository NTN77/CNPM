package model.dao;

import model.adapter.InventoryProduct;
import model.adapter.InventoryProductMappers;
import model.bean.*;
import model.db.JDBIConnector;
import java.util.Collections;
import java.util.List;
import model.service.ImageService;
import java.util.*;
public class ProductDAO {
    //Tất cả các sản phẩm
    public static List<Product> getAll() {
        List<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT p.* " +
                                "FROM product p " +
                                "LEFT JOIN inventory i ON p.id = i.productId " +
                                "LEFT JOIN discount d ON p.discountId = d.id " +
                                "WHERE p.isSale IN (1, 3) " +
                                "ORDER BY i.createDate DESC, d.percentageOff DESC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList()
        );
        return product;
    }

    public static List<Product> getAllProducts() {
        List<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT p.* " +
                                "FROM product p " +
                                "LEFT JOIN inventory i ON p.id = i.productId " +
                                "LEFT JOIN discount d ON p.discountId = d.id " +
                                "WHERE p.isSale IN (1, 3) " +
                                "ORDER BY i.createDate DESC, d.percentageOff DESC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList()
        );
        return product;
    }

    public static Product getProductById(final String id) {
        Optional<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where id= :id ")
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .stream()
                        .findFirst()
        );
        return product.isEmpty() ? null : product.get();
    }



    public static void deleteProduct(String product_id) {
        //delete products image
        ImageService.deleteProductImage(product_id);
        //delete order_details has products
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM order_details WHERE productId=?")
                        .bind(0, product_id)
                        .execute()
        );
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM product WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }

    public static void switchIsSale(String product_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE product SET isSale = CASE WHEN isSale = 0 THEN 1 ELSE 0 END WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }


    public static List<Product> listSixProduct(int offset) {
        try {
            List<Product> products = JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("select * from product WHERE isSale = 1 limit 6 offset :offset")
                            .bind("offset", offset)
                            .mapToBean(Product.class)
                            .stream().toList());

            return products;
        } catch (Exception e) {
            // Xử lý exception, ví dụ: log hoặc throw lại một exception khác.
            e.printStackTrace();
            return Collections.emptyList(); // hoặc return null tùy vào trường hợp
        }
    }

    public static List<Product> findByCategory(int categoryID) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where categoryId = :id")
                        .bind("id", categoryID)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }


    //Lấy sản phẩm dựa vào id product
    public static Product getProduct(int productID) {
        Product p = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * from product where id = :productID ")
                        .bind("productID", productID)
                        .mapToBean(Product.class).findFirst().orElse(null)
        );
        return p;
    }


    //Lấy ra danh saách bình luận
    public static List<Rate> getRateForProduct(int productId) {
        List<Rate> rateList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * FROM rate  where productId =:productId ")
                        .bind("productId", productId).mapToBean(Rate.class)
                        .stream().toList());
        return rateList;
    }

    public static int getNumberRateStarsByUser(int productId, int userId) {
        try {
            return JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("select starRatings from rate where userId=? and productId=?")
                            .bind(0, userId)
                            .bind(1, productId)
                            .mapTo(Integer.class).one());
        } catch (Exception e) {
            return 0;
        }
    }


    //Lấy ra danh sách ảnh của sản phẩm.
    public static List<Image> getImagesForProduct(int productId) {
        List<Image> imageList = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * from image where productId = :productId ")
                        .bind("productId", productId)
                        .mapToBean(Image.class)
                        .stream().toList());

        return imageList;
    }

    //Lấy ra các sản phẩm liên quan đến sản phẩm (trang chi tiết sản phẩm).
    public static List<Product> getRelatedProduct(int productId, int categoryId, int limit) {
        try {
            List<Product> products = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM product WHERE categoryId = :categoryId AND id != :productId LIMIT :limit")
                            .bind("categoryId", categoryId)
                            .bind("productId", productId)
                            .bind("limit", limit)
                            .mapToBean(Product.class)
                            .stream().toList()

            );
            return products;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }


    public static List<Product> getTrueIsSaleProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where isSale = 1")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;

    }

    public static List<Product> getFalseIsSaleProduct() {
        List<Product> products;
        products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where isSale = 0")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getTrueHasDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId IS NOT NULL")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getFalseHasDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId IS NULL")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getNullQuantityProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where stock = 0")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getProductByDiscountId(int discountId) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId = :id")
                        .bind("id", discountId)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getProductBySubName(String subName) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where name like :subName")
                        .bind("subName", "%" + subName + "%")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    //    Sắp xếp theo giá tăng dần toàn bộ
    public static List<Product> sortProductAZ() {
        List<Product> productAZ = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product Where isSale = 1 ORDER BY product.sellingPrice ASC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productAZ;
    }

    //    Sắp xếp theo giá giảm dần toàn bộ
    public static List<Product> sortProductZA() {
        List<Product> productZA = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product Where isSale = 1 ORDER BY product.sellingPrice DESC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productZA;
    }

    //    Sắp xếp theo giá tăng dần theo category
    public static List<Product> sortProductByCategoryAZ(int Categoryid) {
        List<Product> productAZ = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id  AND isSale = 1 ORDER BY product.sellingPrice ASC")
                        .bind("id", Categoryid)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productAZ;
    }
    //    Sắp xếp theo giá giảm dần theo category

    public static List<Product> sortProductByCategoryZA(int Categoryid) {
        List<Product> productZA = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id  AND isSale = 1 ORDER BY product.sellingPrice DESC")
                        .bind("id", Categoryid)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productZA;
    }

    //Sản phẩm khuyến mãi
    public static List<Product> listDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE  AND isSale = 1")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> discountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT  product.* FROM product " +
                                "INNER JOIN discount ON product.discountId = discount.id " +
                                "WHERE discount.startDate < CURRENT_TIMESTAMP AND discount.endDate > CURRENT_TIMESTAMP AND  isSale = 1 " +
                                "ORDER BY discount.percentageOff DESC " +
                                "LIMIT 5 ")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> sortDiscountProductAZ() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE  AND isSale = 1  ORDER BY product.sellingPrice ASC")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> sortDiscountProductZA() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE AND isSale = 1 ORDER BY product.sellingPrice DESC")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static void removeDiscount(int product_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE product SET discountId = null WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }

    public static void setDiscountForAllProducts(String discountId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = :id"
                        )
                        .bind("id", discountId)
                        .execute()
        );
    }

    public static void unSetDiscountForAllProducts(String discountId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null WHERE discountId = :id"
                        )
                        .bind("id", discountId)
                        .execute()
        );
    }

    public static void unSetDiscountForAllProducts() {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null"
                        )
                        .execute()
        );
    }


    public static void setDiscountByCategory(String discountId, String categoryId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = :discountId WHERE categoryId = :categoryId"
                        )
                        .bind("discountId", discountId)
                        .bind("categoryId", categoryId)
                        .execute()
        );
    }


    public static void unSetDiscountByCategory(String discountId, String categoryId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null WHERE discountId = :discountId and categoryId = :categoryId"
                        )
                        .bind("discountId", discountId)
                        .bind("categoryId", categoryId)
                        .execute()
        );
    }


    public static void setDiscountByProduct(String discountId, String productId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = :discountId WHERE id = :productId"
                        )
                        .bind("discountId", discountId)
                        .bind("productId", productId)
                        .execute()
        );
    }

    public static void unSetDiscountByProduct(String discountId, String productId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null WHERE discountId = :discountId and id = :productId"
                        )
                        .bind("discountId", discountId)
                        .bind("productId", productId)
                        .execute()
        );
    }

    public static void setDiscountByQuantity(String discountId, int number, int comparison) {
        String comparisonNumber = comparison == -1 ? "<" : (comparison == 1 ? ">" : "=");
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = :discountId WHERE stock " + comparisonNumber + number
                        )
                        .bind("discountId", discountId)
                        .execute()
        );
    }

    public static void unSetDiscountByQuantity(String discountId, int number, int comparison) {
        String comparisonNumber = comparison == -1 ? "<" : (comparison == 1 ? ">" : "=");
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null WHERE discountId=:discountId and stock " + comparisonNumber + number
                        )
                        .bind("discountId", discountId)
                        .execute()
        );
    }


    //Trang chính xuất 15 sản phẩm trong từng category và phải còn hàng
    public static List<Product> list4product(int idCategory) {
        List<Product> productList = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id AND stock > 0 AND isSale = 1 LIMIT 4")
                        .bind("id", idCategory)
                        .mapToBean(Product.class)
                        .stream().toList()
        );
        return productList;
    }

    //Tìm sản phẩm
    public static List<Product> findProduct(String nameP) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE name LIKE :name AND isSale = 1")
                        .bind("name", "%" + nameP + "%")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> getProductByFilter(String categoryFilter, int sort, Double startPrice, Double endPrice, int limit, int offset) {
        String categoryQuery, rangePriceQuery;
        try {
            int cid = Integer.parseInt(categoryFilter);
            categoryQuery = "categoryId=" + cid;
        } catch (Exception e) {
            categoryQuery = "";
        }

        if (startPrice != null && endPrice == null) {
            rangePriceQuery = "p.sellingPrice >= " + startPrice;
        } else if (startPrice == null && endPrice != null) {
            rangePriceQuery = "p.sellingPrice <= " + endPrice;
        } else if (startPrice != null && endPrice != null) {
            rangePriceQuery = "p.sellingPrice BETWEEN " + startPrice + " AND " + endPrice;
        } else {
            rangePriceQuery = "";
        }
        String sql;
        switch (sort) {
            case SortOption.SORT_MOST_RATES:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN rate r ON p.id = r.productId " +
                        "WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "GROUP BY p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "ORDER BY COUNT(r.productId) DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_HIGHEST_RATING:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN rate r ON p.id = r.productId " +
                        "WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "GROUP BY p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "ORDER BY AVG(r.starRatings) DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_PRICE_ASC:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.sellingPrice ASC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_PRICE_DESC:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.sellingPrice DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_DISCOUNT:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN discount d ON p.discountId = d.id " +
                        "WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) " +
                        "  AND d.startDate <= NOW() AND d.endDate >= NOW() "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY d.percentageOff DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_STOCK:
                sql = "SELECT * FROM product p WHERE "
                        + (categoryQuery.isEmpty() ? "" : categoryQuery + " AND ") +
                        " isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.stock DESC " +
                        " LIMIT ? OFFSET ?";
                break;
            default:
                sql = "SELECT p.* FROM product p " +
                        "LEFT JOIN inventory i ON p.id = i.productId " +
                        " WHERE "
                        + (categoryQuery.isEmpty() ? "" : "p." + categoryQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        " ORDER BY i.createDate DESC " +
                        " LIMIT ? OFFSET ?";
                break;
        }
        System.out.println("hehe\n:" + sql);
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, limit)
                        .bind(1, offset)
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> getProductBySearchFilter(String keyword, int sort, Double startPrice, Double endPrice, int limit, int offset) {
        String kwQuery, rangePriceQuery;
        kwQuery = "p.name LIKE '%" + keyword + "%'";

        if (startPrice != null && endPrice == null) {
            rangePriceQuery = "p.sellingPrice >= " + startPrice;
        } else if (startPrice == null && endPrice != null) {
            rangePriceQuery = "p.sellingPrice <= " + endPrice;
        } else if (startPrice != null && endPrice != null) {
            rangePriceQuery = "p.sellingPrice BETWEEN " + startPrice + " AND " + endPrice;
        } else {
            rangePriceQuery = "";
        }
        String sql;
        switch (sort) {
            case SortOption.SORT_MOST_RATES:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN rate r ON p.id = r.productId " +
                        "WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "GROUP BY p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "ORDER BY COUNT(r.productId) DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_HIGHEST_RATING:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN rate r ON p.id = r.productId " +
                        "WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "GROUP BY p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "ORDER BY AVG(r.starRatings) DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_PRICE_ASC:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.sellingPrice ASC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_PRICE_DESC:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.sellingPrice DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_DISCOUNT:
                sql = "SELECT p.id, p.name, p.description, p.sellingPrice, p.stock, p.categoryId, p.discountId, p.isSale " +
                        "FROM product p " +
                        "LEFT JOIN discount d ON p.discountId = d.id " +
                        "WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) " +
                        "  AND d.startDate <= NOW() AND d.endDate >= NOW() "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY d.percentageOff DESC " +
                        "LIMIT ? OFFSET ?";
                break;
            case SortOption.SORT_STOCK:
                sql = "SELECT * FROM product p WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        "ORDER BY p.stock DESC " +
                        " LIMIT ? OFFSET ?";
                break;
            default:
                sql = "SELECT p.* FROM product p " +
                        "LEFT JOIN inventory i ON p.id = i.productId WHERE "
                        + (kwQuery.isEmpty() ? "" : kwQuery + " AND ") +
                        " p.isSale IN (1, 3) "
                        + (rangePriceQuery.isEmpty() ? "" : " AND " + rangePriceQuery) +
                        " ORDER BY i.createDate DESC " +
                        " LIMIT ? OFFSET ?";
                break;
        }
        System.out.println(sql);
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, limit)
                        .bind(1, offset)
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static int getFindProductNumber(String nameP) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT count(id) FROM `product` WHERE name LIKE :name AND isSale IN (1, 3)")
                        .bind("name", "%" + nameP + "%")
                        .mapTo(Integer.class).one());
    }




    public static long getNumberAvailProduct() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from product where stock>0 and isSale IN (1, 3)").mapTo(Long.class).one());
    }

    public static List<InventoryProduct> getTopSoldoutProduct(int number) {
        String sql = "SELECT p.id, p.name, i.quantity - i.soldout AS quantityRemaining, i.soldOut " +
                "FROM product p join  inventory i on p.id = i.productId  WHERE i.soldOut > 0 order BY i.soldOut desc limit ?";
        List<InventoryProduct> inventoryProducts = JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql).bind(0, number)
                        .map(new InventoryProductMappers.SoldOutMapper())
                        .stream()
                        .toList());
        return inventoryProducts;
    }


    public static List<Rate> getRatesByStarNumber(int productId, int starRatings, Integer userId) {
        Integer star = starRatings;
        if (userId == null) {
            List<Rate> rateList = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM `rate`  where productId =:productId and starRatings=:star")
                            .bind("productId", productId)
                            .bind("star", (star == 1 || star == 2 || star == 3 || star == 4 || star == 5) ? star : null)
                            .mapToBean(Rate.class)
                            .stream().toList());
            return rateList;
        } else {
            List<Rate> rateList = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId AND starRatings = :star ORDER BY CASE WHEN userId = :userId THEN 0 ELSE 1 END, createDate DESC")
                            .bind("productId", productId)
                            .bind("star", (star == 1 || star == 2 || star == 3 || star == 4 || star == 5) ? star : null)
                            .bind("userId", userId)
                            .mapToBean(Rate.class)
                            .stream().toList());
            return rateList;
        }
    }

    public static Integer getStarNumberCount(int productId, int starRatings) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(userId) from rate where productId=? and starRatings=?")
                        .bind(0, productId)
                        .bind(1, starRatings)
                        .mapTo(Integer.class).one());
    }

    public static Integer getStarNumberCount(int productId) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(userId) from rate where productId=?")
                        .bind(0, productId)
                        .mapTo(Integer.class).one());
    }

    public static Rate rateExists(int productId, int userId) {
        Optional<Rate> rate = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId AND userId = :userId")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .mapToBean(Rate.class)
                        .stream()
                        .findFirst()
        );
        return rate.isEmpty() ? null : rate.get();
    }

    public static void insertRate(int productId, int userId, int starRatings, String comment, String sentiment) {
        if (starRatings < 1 || starRatings > 5) {
            throw new IllegalArgumentException("starRatings must be between 1 and 5");
        }

        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("INSERT INTO `rate` (productId, userId, starRatings, comment, sentiment) VALUES (:productId, :userId, :starRatings, :comment, :sentiment)")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("starRatings", starRatings)
                        .bind("comment", comment)
                        .bind("sentiment", sentiment)
                        .execute()
        );
    }

    public static void updateRate(int productId, int userId, int starRatings, String comment, String sentiment) {
        Rate rate = rateExists(productId, userId);
        if (starRatings < 1 || starRatings > 5) {
            throw new IllegalArgumentException("starRatings must be between 1 and 5");
        } else if (rate != null && rate.getChangeNumber() != 0) {
            throw new IllegalArgumentException("Không thể vì đã chỉnh sửa đánh giá");
        }
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `rate` SET sentiment = :sentiment, starRatings = :starRatings, comment = :comment, createDate = CURRENT_TIMESTAMP, changeNumber =:changeNumber WHERE productId = :productId AND userId = :userId")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("starRatings", starRatings)
                        .bind("comment", comment)
                        .bind("changeNumber", 1)
                        .bind("sentiment", sentiment)
                        .execute()
        );
    }


    public static List<Rate> getRatesFirstUser(int productId, int userId) {
        List<Rate> rateList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId  ORDER BY CASE WHEN userId = :userId THEN 0 ELSE 1 END, createDate DESC")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .mapToBean(Rate.class)
                        .stream().toList());
        return rateList;
    }

    //    Lấy discount trong từng sản phẩm theo id
    public static Integer discountProduct(int idProduct) {
        double discount = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select discount.percentageOff from discount inner join product on product.discountId = discount.id Where product.id =:id")
                        .bind("id", idProduct)
                        .mapTo(Double.class).one());
        int result = (int) Math.round((discount * 100));
        return result;
    }

//Tính số sao trung bình của sản phẩm theo id

    public static double avarageStar(int idProduct) {
        List<Rate> rateList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId")
                        .bind("productId", idProduct)
                        .mapToBean(Rate.class)
                        .stream().toList());
        double result = 0;
        if (!rateList.isEmpty()) {
            int count = 0;
            double starAll = 0;
            for (Rate rate : rateList) {
                count++;
                starAll += rate.getStarRatings();
            }
            result = starAll / count;
        }
        return result;
    }

    //Sản Phẩm đã bán số lượng
    public static int sellProduct(int idProduct) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select soldOut from inventory where productId=?")
                        .bind(0, idProduct)
                        .mapTo(Integer.class).one());
    }

    public static double getAverageRateStars(int productId) {
        try {
            double averageStars = JDBIConnector.me().withHandle(handle ->
                    handle.createQuery(
                                    "SELECT AVG(starRatings) AS averageStars " +
                                            "FROM rate WHERE productId = ? " +
                                            "GROUP BY productId"
                            )
                            .bind(0, productId)
                            .mapTo(Double.class)
                            .one());
            return averageStars;
        } catch (Exception e) {
            return 0;
        }
    }

    /*

     public static List<Order> getOrderByCustomerId(String customerId, int limit, int offset, int statusNumber) {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where userId=? and status=? order by orderDate desc LIMIT ? OFFSET ?")
                        .bind(0, customerId)
                        .bind(1, statusNumber)
                        .bind(2, limit)
                        .bind(3, offset)
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }
     */
    //Lấy stock
    public static int StockProduct(int idProduct){
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT stock FROM product WHERE id= :idProduct")
                        .bind("idProduct",idProduct)
                        .mapTo(Integer.class)
                        .one());
    }
    public static List<Product> getAllProducts(int limit, int offset) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `product` where isSale IN (1, 3) LIMIT ? OFFSET ?")
                        .bind(0, limit)
                        .bind(1, offset)
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

//    chỉnh sửa thông tin sản phẩm.
    //    --------------------UPDATE SẢN PHẨM.

    public static Integer getCostPriceProduct(int id) {
        String sql = "select costPrice from inventory where productId=?";
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql).bind(0, id).mapTo(Integer.class).one());
    }

    public static Integer getStockProduct(int id) {
        String sql = "select stock from product where id=?";
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql).bind(0, id).mapTo(Integer.class).one());
    }

    public static Integer getIsSale(int id) {
        String sql = "select isSale from product where id=?";
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql).bind(0, id).mapTo(Integer.class).one());

    }

    //     GIẢM STOCK SARN PHAAM/
    public static void reduceStock(int productId, int quantity) {
        String sql = "UPDATE  product SET stock = stock - :quantity WHERE id = :id";

        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(sql).bind("quantity", quantity).bind("id", productId).execute());
    }

    public static void increamentStock  (int productId, int quantity) {
        String sql = "UPDATE  product SET stock = stock + :quantity WHERE id = :id";

        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(sql).bind("quantity", quantity).bind("id", productId).execute());
    }









    public static void updateProduct(String id, String name, String description, int sellingPrice, String categoryId, String discountId, int isSale) {

        String updateProduct = "UPDATE product SET name=:name, description=:description, sellingPrice=:sellingPrice, categoryId=:categoryId, discountId=:discountId, isSale=:isSale where id=:id";


        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                updateProduct
                        )
                        .bind("name", name)
                        .bind("description", description)
                        .bind("sellingPrice", sellingPrice)
                        .bind("categoryId", categoryId)
                        .bind("discountId", discountId)
                        .bind("isSale", isSale)
                        .bind("id", id)
                        .execute()
        );
    }

    public static void updateProduct(String id, String name, String description, int sellingPrice, String categoryId, int isSale) {

        String updateProduct = "UPDATE product SET name=:name, description=:description, sellingPrice=:sellingPrice, categoryId=:categoryId, isSale=:isSale where id=:id";
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                updateProduct
                        )
                        .bind("name", name)
                        .bind("description", description)
                        .bind("sellingPrice", sellingPrice)
                        .bind("categoryId", categoryId)
                        .bind("isSale", isSale)
                        .bind("id", id)
                        .execute()
        );
    }







    public static void main(String[] args) {
//        List<Product> products = getProductBySearchFilter("Thiệp", SortOption.SORT_PRICE_ASC, null, 1620000.0, 15, 0);
//        products.forEach((p) -> System.out.println(p.getName()));
        System.out.println(StockProduct(1));
    }
}
