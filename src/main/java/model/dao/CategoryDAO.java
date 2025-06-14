package model.dao;

import model.bean.Category;
import model.bean.Product;
import model.db.JDBIConnector;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class CategoryDAO {
    public static List<Category> getAll() {
        List<Category> categories = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from category")
                        .mapToBean(Category.class).stream().collect(Collectors.toList())
        );
        return categories;
    }

    public static List<Category> getAllCategoriesWithNoProductsOnSale() {
        List<Category> categories = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM category c WHERE EXISTS (SELECT 1 FROM product p WHERE p.categoryId = c.id AND p.isSale = 1)")
                        .mapToBean(Category.class)
                        .stream()
                        .collect(Collectors.toList())
        );
        return categories;
    }


    //Lấy thông tin category thông qua id.
    public static Category getCategoryById(int id) {
        Category category = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from category where id= :id")
                        .bind("id", id)
                        .mapToBean(Category.class)
                        .findFirst().orElse(null)

        );
        return category;
    }

    public static String insertCategory(String newCategoryName) {
        AtomicInteger newID = new AtomicInteger();
        JDBIConnector.me().useHandle(handle -> {
                    newID.set(handle.createUpdate("INSERT INTO category (name) VALUES (:name)")
                            .bind("name", newCategoryName)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one());
                }
        );

        return newID.get() + "";

    }

    public static void deleteNoUsedCategoryById(String id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM category WHERE id=? AND id NOT IN(" +
                                "SELECT DISTINCT categoryId FROM product)")
                        .bind(0, id)
                        .execute()
        );
    }

    public static boolean checkNoUsedCategoryById(int id) {
        List<Integer> categoryId = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT DISTINCT categoryId FROM product WHERE categoryId=?")
                        .bind(0, id)
                        .mapTo(Integer.class)
                        .stream().collect(Collectors.toList())
        );
        return categoryId.isEmpty() ? true : false;
    }

    public static void updateCategoryNameById(String id, String newName) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE category SET name=:newName WHERE id=:id")
                        .bind("newName", newName)
                        .bind("id", id)
                        .execute()
        );
    }

    //    Lấy ra 1 id sản phẩm của category
    public static int oneProductofCategory(int idCategory) {
        Optional<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product JOIN category on product.categoryId = :id LIMIT 1")
                        .bind("id", idCategory)
                        .mapToBean(Product.class)
                        .stream()
                        .findFirst()
        );
        return product.isEmpty() ? null : product.get().getId();
    }


    public static void main(String[] args) {
        updateCategoryNameById("2", "haha");
    }

}