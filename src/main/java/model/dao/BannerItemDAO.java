package model.dao;

import model.bean.BannerItem;
import model.bean.Tip;
import model.bean.User;
import model.db.JDBIConnector;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class BannerItemDAO {
    public static List<BannerItem> getAll() {
        List<BannerItem> bannerItems = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from banner_items").mapToBean(BannerItem.class).stream().collect(Collectors.toList()));
        return bannerItems;
    }



    public static BannerItem getBannerItemByTitle(String title) {
        Optional<BannerItem> bannerItem = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from banner_items where title= :title")
                        .bind("title", title)
                        .mapToBean(BannerItem.class)
                        .stream()
                        .findFirst()
        );
        return bannerItem.isEmpty() ? null : bannerItem.get();
    }

    public static void updateByTitle(String oldTitle, String newTitle, String description) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE banner_items SET title=:newTitle, description=:description  WHERE title=:title")
                        .bind("title", oldTitle)
                        .bind("newTitle", newTitle)
                        .bind("description", description)
                        .execute()
        );
    }

    public static void deleteBannerByTitle(String title) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM banner_items WHERE title=?")
                        .bind(0, title)
                        .execute()
        );
    }

    public static void insertBannerItem(String title, String description, String img_path) {
        JDBIConnector.me().useHandle(handle -> {
                    handle.createUpdate("INSERT INTO banner_items (title, description, img_path) VALUES (:title,:description,:img_path)")
                            .bind("title", title)
                            .bind("description", description)
                            .bind("img_path", img_path)
                            .execute();
                }
        );
    }

    public static boolean isExist(String title) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select COUNT(title) FROM banner_items where title=:title")
                        .bind("title", title)
                        .mapTo(Integer.class)
                        .one() > 0);
    }


}