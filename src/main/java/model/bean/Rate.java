package model.bean;

import java.io.Serializable;
import java.sql.Timestamp;

public class Rate implements Serializable {
    private int productId;
    private int userId;
    private int starRatings;
    private String comment;
    private Timestamp createDate;

    private int changeNumber;
    public Rate() {

    }

    public Rate(int productId, int userId, int starRatings, String comment, Timestamp createDate) {
        this.productId = productId;
        this.userId = userId;
        this.starRatings = starRatings;
        this.comment = comment;
        this.createDate = createDate;
    }

    public int getChangeNumber() {
        return changeNumber;
    }

    public void setChangeNumber(int changeNumber) {
        this.changeNumber = changeNumber;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getStarRatings() {
        return starRatings;
    }

    public void setStarRatings(int starRatings) {
        this.starRatings = starRatings;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    @Override
    public String toString() {
        return "Rate{" +
                "productId=" + productId +
                ", userId=" + userId +
                ", starsRating=" + starRatings +
                ", comment='" + comment + '\'' +
                ", createDate=" + createDate +
                '}';
    }

}