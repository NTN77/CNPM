package model.bean;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Order implements Serializable {
    private int id;
    private double totalPrice;
    private Timestamp orderDate;
    private int status;
    private String consigneeName;
    private String consigneePhoneNumber;
    private String address;

    private double shippingFee;
    private int userId;
    private String note;


    public Order() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getConsigneeName() {
        return consigneeName;
    }

    public void setConsigneeName(String consigneeName) {
        this.consigneeName = consigneeName;
    }

    public String getConsigneePhoneNumber() {
        return consigneePhoneNumber;
    }

    public void setConsigneePhoneNumber(String consigneePhoneNumber) {
        this.consigneePhoneNumber = consigneePhoneNumber;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public boolean isWaitConfirmOrder() {
        return this.getStatus() == 0;
    }

    public boolean isPreparing() {
        return this.getStatus() == 1;
    }

    public boolean isDeliveringOrder() {
        return this.getStatus() == 2;
    }

    public boolean isSucccessfulOrder() {
        return this.getStatus() == 3;
    }

    public boolean isCanceledOrder() {
        return this.getStatus() == 4;
    }

    public String getStatusAsName() {
        String re = null;
        if (this.isWaitConfirmOrder()) {
            re = "Cần xác nhận";
        } else if (this.isPreparing()) {
            re = "Đang đóng gói";
        } else if (this.isDeliveringOrder()) {
            re = "Đang giao";
        } else if (this.isCanceledOrder()) {
            re = "Đã hủy";
        } else if (this.isSucccessfulOrder()) {
            re = "Thành công";
        }
        return re;
    }
    public String getStatusAsColor(){
        String backgroundColor = null;
        if (this.isWaitConfirmOrder()) {
            backgroundColor = "#ffcc00";
        } else if (this.isPreparing()) {
            backgroundColor = "cadetblue";
        } else if (this.isDeliveringOrder()) {
            backgroundColor = "#0171d3";
        } else if (this.isCanceledOrder()) {
            backgroundColor = "#ff0000";
        } else if (this.isSucccessfulOrder()) {
            backgroundColor = "#4d8a54";
        }
        return backgroundColor;
    }
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", totalPrice=" + totalPrice +
                ", orderDate=" + orderDate +
                ", status='" + status + '\'' +
                ", consigneeName='" + consigneeName + '\'' +
                ", consigneePhoneNumber='" + consigneePhoneNumber + '\'' +
                ", address='" + address + '\'' +
                ", note='" + note + '\'' +
                ", shippingFee=" + shippingFee +
                ", userId=" + userId +
                '}';
    }
}