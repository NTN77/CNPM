package model.service;

import model.bean.Discount;
import model.bean.Product;
import model.bean.Rate;
import model.dao.ProductDAO;
import model.dao.UserDAO;
import model.db.JDBIConnector;

import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ProductService {
    public static ProductService instance;

    public static ProductService getInstance() {
        if (instance == null) instance = new ProductService();
        return instance;
    }

    public List<Product> getAll() {
        return ProductDAO.getAll();
    }

    public List<Product> getAllProducts(int limit, int offset) {
        return ProductDAO.getAllProducts(limit, offset);
    }

    public List<Product> getAllProducts() {
        return ProductDAO.getAllProducts();
    }

    public Product getProductById(String id) {
        return ProductDAO.getProductById(id);
    }

    public double productPriceIncludeDiscount(Product p) {
        if (p != null) {
            Discount discountApplied = DiscountService.getInstance().getDiscountById(p.getDiscountId() + "");
            if (discountApplied != null) {
                Timestamp currentTimestamp = new Timestamp(new Date().getTime());
                if ((discountApplied.getStartDate().getTime() <= (currentTimestamp.getTime()))
                        && (currentTimestamp.getTime() <= (discountApplied.getEndDate().getTime()))) {
                    return p.getSellingPrice() * (1 - discountApplied.getPercentageOff());
                } else {
                    return p.getSellingPrice();
                }
            } else return p.getSellingPrice();
        }
        return 0;
    }

    //danh sách sản phẩm đang được giảm giá
    public List<Product> productDiscountMainPage() {
        return ProductDAO.discountProduct();
    }

    public List<Product> listProductDiscount() {
        return ProductDAO.listDiscountProduct();
    }

    public List<Product> sortListProductDiscountAZ() {
        return ProductDAO.sortDiscountProductAZ();
    }

    public List<Product> sortListProductDiscountZA() {
        return ProductDAO.sortDiscountProductZA();
    }

    public List<Product> getProductsByCategoryId(int category_id) {
        return ProductDAO.findByCategory(category_id);
    }

    public void deleteProduct(String product_id) {
        ProductDAO.deleteProduct(product_id);
    }

    public void switchIsSale(String product_id) {
        ProductDAO.switchIsSale(product_id);
    }

    public List<Product> getTrueIsSaleProduct() {
        return ProductDAO.getTrueIsSaleProduct();
    }

    public List<Product> getFalseIsSaleProduct() {
        return ProductDAO.getFalseIsSaleProduct();
    }

    public List<Product> getTrueHasDiscountProduct() {
        return ProductDAO.getTrueHasDiscountProduct();
    }

    public List<Product> getFalseHasDiscountProduct() {
        return ProductDAO.getFalseHasDiscountProduct();
    }

    public List<Product> getNullQuantityProduct() {
        return ProductDAO.getNullQuantityProduct();
    }

    public List<Product> getProductByAsName(String subName) {
        return ProductDAO.getProductBySubName(subName);
    }

    public List<Product> getProductByDiscountId(int discountId) {
        return ProductDAO.getProductByDiscountId(discountId);
    }

    public void removeDiscount(int product_id) {
        ProductDAO.removeDiscount(product_id);
    }

    public void setDiscountForAllProducts(String discountId) {
        ProductDAO.setDiscountForAllProducts(discountId);
    }

    public void unSetDiscountForAllProducts(String discountId) {
        ProductDAO.unSetDiscountForAllProducts(discountId);
    }

    public void unSetDiscountForAllProducts() {
        ProductDAO.unSetDiscountForAllProducts();
    }

    public void setDiscountByCategory(String discountId, String categoryId) {
        ProductDAO.setDiscountByCategory(discountId, categoryId);
    }

    public void unSetDiscountByCategory(String discountId, String categoryId) {
        ProductDAO.unSetDiscountByCategory(discountId, categoryId);
    }

    public void setDiscountByProduct(String discountId, String productId) {
        ProductDAO.setDiscountByProduct(discountId, productId);
    }

    public void unSetDiscountByProduct(String discountId, String productId) {
        ProductDAO.unSetDiscountByProduct(discountId, productId);
    }

    /*
    comparison: -1 <; 0 =; 1 >
     */
    public void setDiscountByQuantity(String discountId, int number, int comparison) {
        ProductDAO.setDiscountByQuantity(discountId, number, comparison);
    }

    public void unSetDiscountByQuantity(String discountId, int number, int comparison) {
        ProductDAO.unSetDiscountByQuantity(discountId, number, comparison);
    }


    //Sắp xếp từ thấp đến cao
    public List<Product> sortProductsAZ() {
        return ProductDAO.sortProductAZ();
    }

    //sắp xếp từ cao đến thấp
    public List<Product> sortProductsZA() {
        return ProductDAO.sortProductZA();
    }

    public List<Product> getAllProduct() {
        return ProductDAO.getAll();
    }


    public Product getProductById(int productID) {
        return ProductDAO.getProduct(productID);
    }

    public List<Product> getRelatedProduct(int productId, int categoryId, int limit) {
        return ProductDAO.getRelatedProduct(productId, categoryId, limit);
    }

    public List<Rate> getRateForProduct(int productId) {
        return ProductDAO.getRateForProduct(productId);
    }

    public int getNumberRateStarsByUser(int productId, int userId) {
        return ProductDAO.getNumberRateStarsByUser(productId, userId);
    }

    public double getAverageRateStars(int productId) {
        return ProductDAO.getAverageRateStars(productId);
    }

    public double roundNumber(double averageRateStars) {
        // Làm tròn kết quả về 1 chữ số thập phân
        DecimalFormat df = new DecimalFormat("#.#");
        return Double.parseDouble(df.format(averageRateStars));
    }

    public List<Rate> getRatesByStarNumber(int productId, int starRatings, Integer userId) {
        return ProductDAO.getRatesByStarNumber(productId, starRatings, userId);
    }

    public List<Rate> getRatesFirstUser(int productId, int userId) {
        return ProductDAO.getRatesFirstUser(productId, userId);
    }

    public Integer getStarNumberCount(int productId, int starRatings) {
        return ProductDAO.getStarNumberCount(productId, starRatings);
    }


    public Integer getStarNumberCount(int productId) {
        return ProductDAO.getStarNumberCount(productId);
    }


    public int getChangeNumber(int productId, int userId) {
        boolean check = UserService.getInstance().checkUserAllowedToRate(productId, userId);
        // nếu mua r => get Rate -> xem changeNumber
        if (check) {
            Rate rate = ProductService.getInstance().rateExists(productId, userId);
            return (rate != null) ? rate.getChangeNumber() : -1;
        }
        return -1;
    }

    public void changeRate(int productId, int userId, int starRatings, String comment) {
        if (ProductDAO.rateExists(productId, userId) != null) {
            ProductDAO.updateRate(productId, userId, starRatings, comment);
        } else {
            ProductDAO.insertRate(productId, userId, starRatings, comment);
        }
    }

    public Rate rateExists(int productId, int userId) {
        return ProductDAO.rateExists(productId, userId);
    }


    public long getNumberAvailProduct() {
        return ProductDAO.getNumberAvailProduct();
    }

    public static Integer discountProduct(int idProduct) {
        return ProductDAO.discountProduct(idProduct);
    }
    public static Integer getProductCostPrice(int productId) {
        return ProductDAO.getCostPriceProduct(productId);

    }

    public static Integer getStockProduct(int productId){

        return ProductDAO.getStockProduct(productId);

    }

    public static Integer getIsSale(int productId){

        return ProductDAO.getIsSale(productId);

    }

    public void reduceStock(int productId, int quantity) {
        ProductDAO.reduceStock(productId, quantity);
    }
    public void increaseStock(int productId, int quantity) {
        ProductDAO.increamentStock(productId, quantity);
    }


    //update cho sản phẩm.
    /// EDIT PRODUCT.
    public void editProduct(String id, String name, String description, int sellingPrice, String categoryId, String discountId, int isSale) {
        ProductDAO.updateProduct(id, name, description ,sellingPrice, categoryId, discountId, isSale);
    }

    public void editProduct(String id, String name, String description, int costPrice, String categoryId, int isSale) {
        ProductDAO.updateProduct(id, name, description, costPrice, categoryId, isSale);
    }

    public List<Product> getProductByFilter(String categoryFilter, int sort, Double startPrice, Double endPrice, int limit, int offset) {
        return ProductDAO.getProductByFilter(categoryFilter, sort, startPrice, endPrice, limit, offset);
    }

    public List<Product> getProductBySearchFilter(String keyword, int sort, Double startPrice, Double endPrice, int limit, int offset) {
        return ProductDAO.getProductBySearchFilter(keyword, sort, startPrice, endPrice, limit, offset);
    }
}