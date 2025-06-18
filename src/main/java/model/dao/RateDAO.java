package model.dao;

import model.adapter.RateDetailRequest;
import model.adapter.RateRequest;
import model.db.JDBIConnector;

import java.util.ArrayList;
import java.util.List;

public class RateDAO {
    public static List<RateRequest> getAll() {
        try {
            return JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("SELECT p.productId , product.name ,p.createDate,p.comment, COUNT(p.productId) AS TongDanhGia,AVG(p.starRatings) AS DanhGiaTrungBinh ,p.sentiment " +
                                    "FROM rate p INNER JOIN product ON p.productId = product.id " +
                                    "GROUP BY p.productId,  product.name")
                            .mapToBean(RateRequest.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi chi tiết
            return new ArrayList<>();
        }
    }

    public static List<RateDetailRequest> getRateDetailById(int id) {
        try {
            return JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("SELECT p.productId, product.name AS productName, user.name AS userName, p.createDate, p.comment,p.sentiment " +
                                    "FROM rate p " +
                                    "INNER JOIN product ON p.productId = product.id " +
                                    "INNER JOIN user ON p.userId = user.id " +
                                    "WHERE p.productId = :id")
                            .bind("id", id)
                            .mapToBean(RateDetailRequest.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

}
