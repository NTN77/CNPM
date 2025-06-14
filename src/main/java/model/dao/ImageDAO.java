package model.dao;

import model.bean.Image;
import model.db.JDBIConnector;

import java.util.Optional;

public class ImageDAO {
    public static String pathImage(int productId){
        Optional<Image> result = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT image.path FROM image join product ON image.productId = product.id WHERE product.id = :productId")
                        .bind("productId",productId)
                        .mapToBean(Image.class)
                        .stream().findFirst());
        return result.isEmpty() ? null : result.get().getPath();
    }

    public static void main(String[] args) {
        System.out.println(pathImage(1));
    }
}