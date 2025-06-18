package model.adapter;

import java.io.Serializable;
import java.sql.Timestamp;

public class RateDetailRequest implements Serializable {
    private int productId;
    private String productName;
    private String userName;
    private Timestamp createDate;
    private String comment;
    private String sentiment;

    public RateDetailRequest() {
    }

    public RateDetailRequest(int productId, String productName, String userName, Timestamp createDate, String comment, String sentiment) {
        this.productId = productId;
        this.productName = productName;
        this.userName = userName;
        this.createDate = createDate;
        this.comment = comment;
        this.sentiment = sentiment;
    }

    public String getSentiment() {
        return sentiment;
    }

    public void setSentiment(String sentiment) {
        this.sentiment = sentiment;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
