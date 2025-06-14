package model.dao;

import model.bean.BannerItem;
import model.bean.Tip;
import model.bean.User;
import model.db.JDBIConnector;
import model.service.TipService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class TipDAO {
    public static List<Tip> getAllTips() {
        List<Tip> tips = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from tips").mapToBean(Tip.class).stream().collect(Collectors.toList()));
        return tips;
    }

    public static Tip getTipByTitle(String title) {
        Optional<Tip> tip = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from tips where title= :title")
                        .bind("title", title)
                        .mapToBean(Tip.class)
                        .stream()
                        .findFirst()
        );
        return tip.isEmpty() ? null : tip.get();
    }

    public static void deleteTipByTitle(String title) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM tips WHERE title=?")
                        .bind(0, title)
                        .execute()
        );
    }

    public static void updateByTitle(String oldTitle, String newTitle, String description, String videoLink) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE tips SET title=:newTitle, description=:description,video_link=:videoLink   WHERE title=:title")
                        .bind("title", oldTitle)
                        .bind("newTitle", newTitle)
                        .bind("description", description)
                        .bind("videoLink", videoLink)
                        .execute()
        );
    }

    public static void insertTip(String title, String description, String img_path, String video_link) {
        JDBIConnector.me().useHandle(handle -> {
                    handle.createUpdate("INSERT INTO tips (title, description, img_path, video_link) VALUES (:title,:description,:img_path,:video_link)")
                            .bind("title", title)
                            .bind("description", description)
                            .bind("img_path", img_path)
                            .bind("video_link", video_link)
                            .execute();
                }
        );
    }

    public static boolean isExist(String title) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select COUNT(title) FROM tips where title=:title")
                        .bind("title", title)
                        .mapTo(Integer.class)
                        .one() > 0);
    }

    public static void main(String[] args) {
        System.out.println("Noooo");
        List<Tip> tips = getAllTips();
        if (tips == null) System.out.println("no data");
        for (Tip c : tips) {
            System.out.println(c.toString());
        }
    }
}