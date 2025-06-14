package model.dao;

import model.adapter.InventoryProduct;
import model.adapter.InventoryProductMappers;
import model.bean.Inventory;
import model.bean.Product;
import model.db.JDBIConnector;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryDAO {

    /**
     * Hiển thị trên bảng tồn kho.
     * + Hàng tồn kho = Tổng số lượng - số lươợng đã bán. (Hàng tồn kho # stock trong product)
     * + Lần nhập gần nhất (cập nhật khi phiếu nhập import có product đó) - xử lý sau, hiện tại để mặc định ngày tạo.
     */
    public static List<InventoryProduct> showInventoryView() {
        String sql = "SELECT p.id, p.name, i.costPrice, p.sellingPrice, i.quantity - i.soldOut AS quantityRemaining , i.soldOut, i.costPriceUpdate - i.costPrice AS priceDifference, i.createDate AS lastModified, p.isSale, p.discountId" +
                "                  FROM product p JOIN inventory i on p.id = i.productId " ;
        List<InventoryProduct> inventoryProductList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery(sql).map(new InventoryProductMappers.ViewInventoryMapper()).stream().toList()
        );
        return inventoryProductList;
    }
    public static List<InventoryProduct> inventorySoldoutTop() {
        String sql = "SELECT p.id, p.name, i.costPrice, p.sellingPrice, i.quantity - i.soldOut AS quantityRemaining , i.soldOut, i.costPriceUpdate - i.costPrice AS priceDifference, i.createDate AS lastModified, p.isSale, p.discountId" +
                "                  FROM product p JOIN inventory i on p.id = i.productId WHERE i.soldOut > 0 order by i.soldOut desc limit 10" ;
        List<InventoryProduct> inventoryProductList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery(sql).map(new InventoryProductMappers.ViewInventoryMapper()).stream().toList()
        );
        return inventoryProductList;
    }
    /**
     * Hiển thị trên bảng discount..
     */

    public static List<InventoryProduct> showDiscountView() {
        String sql = "SELECT p.id, p.name, i.costPrice, p.sellingPrice, i.quantity-i.soldOut AS quantityRemaining, i.soldOut, p.discountId, p.categoryId from product p JOIN inventory i ON p.id = i.productId";
        List<InventoryProduct> inventoryProductList = JDBIConnector.me().withHandle(

                handle -> handle.createQuery(sql).map(new InventoryProductMappers.ViewDiscountMapper()).stream().toList()

        );
        return inventoryProductList;
    }


    public static void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, List<String> imagesPath) {
        String insertProduct = "INSERT INTO product(name, description, sellingPrice, stock, categoryId) VALUES(:name, :description, :sellingPrice, :stock, :categoryId)";
        String insertInventory = "INSERT INTO inventory(productId, quantity, costPrice) VALUES(:productId, :quantity, :costPrice)";
        String insertImage = "INSERT INTO image(name, path, productId) VALUES (:name, :path, :productId)";

        JDBIConnector.me().useHandle(handle -> {
            handle.begin();
            try {
                // Insert into product table with auto-increment ID
                int productId = handle.createUpdate(insertProduct)
                        .bind("name", name)
                        .bind("description", description)
                        .bind("sellingPrice", sellingPrice)
                        .bind("stock", quantity)
                        .bind("categoryId", categoryId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();

                // insert to inventory table.
                handle.createUpdate(insertInventory)
                        .bind("productId", productId)
                        .bind("quantity", quantity)
                        .bind("costPrice", costPrice)
                        .execute();


                for (String imagePath : imagesPath) {
                    // Insert into image table with auto-increment ID
                    int imageId = handle.createUpdate(insertImage)
                            .bind("name", name + " " + imagePath)
                            .bind("path", imagePath)
                            .bind("productId", productId)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one();
                }
                handle.commit();
            }catch (Exception e) {
                handle.rollback();
                throw e;
            }
        });

    }
    /*-----------------------------------------THEM SAN PHAM MOI ------------------------------------*/
    public static void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, int discountId, List<String> imagesPath) {
        String insertProduct = "INSERT INTO product(name, description, sellingPrice, stock, categoryId, discountId) VALUES(:name, :description, :sellingPrice, :stock, :categoryId, :discountId)";
        String insertInventory = "INSERT INTO inventory(productId, quantity, costPrice) VALUES(:productId, :quantity, :costPrice)";
        String insertImage = "INSERT INTO image(name, path, productId) VALUES (:name, :path, :productId)";

        JDBIConnector.me().useHandle(handle -> {
            handle.begin();
            try {
                // Insert into product table with auto-increment ID
                int productId = handle.createUpdate(insertProduct)
                        .bind("name", name)
                        .bind("description", description)
                        .bind("sellingPrice", sellingPrice)
                        .bind("stock", quantity)
                        .bind("categoryId", categoryId)
                        .bind("discountId", discountId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class).one();

                // insert to inventory table.
                handle.createUpdate(insertInventory)
                        .bind("productId", productId)
                        .bind("quantity", quantity)
                        .bind("costPrice", costPrice)
                        .execute();


                for (String imagePath : imagesPath) {
                    // Insert into image table with auto-increment ID
                    int imageId = handle.createUpdate(insertImage)
                            .bind("name", name + " " + imagePath)
                            .bind("path", imagePath)
                            .bind("productId", productId)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one();
                }
                handle.commit();
            }catch (Exception e) {
                handle.rollback();
                throw e;
            }
        });

    }
    //    Lấy mọi thông tin product + inventory .
    public static InventoryProduct getIdProduct(int id) {
        String sql = "SELECT p.id, p.name,p.description, i.costPrice, p.sellingPrice, i.quantity - i.soldOut AS quantityRemaining, i.soldOut, i.createDate AS lastModified , p.discountId,p.categoryId,  p.isSale " +
                "from product p JOIN inventory i ON p.id = i.productId WHERE p.id =:id";

        InventoryProduct p = JDBIConnector.me().withHandle(
                handle -> handle.createQuery(sql)
                        .bind("id", id)
                        .map(new InventoryProductMappers.ViewDistinctMapper()).findFirst().orElse(null)
        );
        return p;
    }




    public static void main(String[] args) {
        InventoryProduct id = getIdProduct(1);
        System.out.println(id);
    }
}

