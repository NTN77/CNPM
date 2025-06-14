package model.dao;

import model.bean.RateNew;
import model.db.JDBIConnector;

public class RateNewDAO {

    public static int insertRate(RateNew rateNew) {
        String sql = "INSERT INTO rate(productId, userId, starRatings, " +
                "comment, changeNumber, sentiment) " +
                "values(?, ?, ?, ?, ?, ?)";
        return JDBIConnector.me().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, rateNew.getProductId())
                        .bind(1, rateNew.getUserId())
                        .bind(2, rateNew.getStarRatings())
                        .bind(3, rateNew.getComment())
                        .bind(4, rateNew.getChangeNumber())
                        .bind(5, rateNew.getSentiment())
                        .execute()
        );
    }
}
