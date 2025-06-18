package model.adapter;

import java.io.Serializable;
import java.sql.Timestamp;

public class RateRequest implements Serializable {
    private int productId;
    private String name;

    private Timestamp createDate;
    private String comment;
    private int TongDanhGia;
    private double DanhGiaTrungBinh;
    private String sentiment;
    public RateRequest() {

    }

    public RateRequest(int productId, String name, Timestamp createDate, String comment, int tongDanhGia, double danhGiaTrungBinh, String sentiment) {
        this.productId = productId;
        this.name = name;
        this.createDate = createDate;
        this.comment = comment;
        TongDanhGia = tongDanhGia;
        DanhGiaTrungBinh = danhGiaTrungBinh;
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

    public String getName() {
        return name;
    }

    public void setNameProduct(String nameProduct) {
        this.name = nameProduct;
    }

    public int getTongDanhGia() {
        return TongDanhGia;
    }

    public void setTongDanhGia(int tongDanhGia) {
        TongDanhGia = tongDanhGia;
    }

    public double getDanhGiaTrungBinh() {
        return DanhGiaTrungBinh;
    }

    public void setDanhGiaTrungBinh(double danhGiaTrungBinh) {
        DanhGiaTrungBinh = danhGiaTrungBinh;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Rate{" +
                "productId=" + productId +
                ", comment='" + comment + '\'' +
                ", createDate=" + createDate +
                '}';
    }

}