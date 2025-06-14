package controller.ajax_handle;

import java.sql.Timestamp;

public class RateResponse {
    private int productId;

    private int userId;
    private String userFullName;
    private int starRatings;
    private String comment;
    private Timestamp createDate;

    private int changeNumber;

    public RateResponse() {

    }

    public RateResponse(int productId, int userId, String userFullName, int starRatings, String comment, Timestamp createDate, int changeNumber) {
        this.productId = productId;
        this.userId = userId;
        this.userFullName = userFullName;
        this.starRatings = starRatings;
        this.comment = comment;
        this.createDate = createDate;
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

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
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

    public int getChangeNumber() {
        return changeNumber;
    }

    public void setChangeNumber(int changeNumber) {
        this.changeNumber = changeNumber;
    }
}
