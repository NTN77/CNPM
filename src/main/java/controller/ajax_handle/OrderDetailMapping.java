package controller.ajax_handle;

import model.bean.OrderDetail;

public class OrderDetailMapping {
    OrderDetail orderDetail;
    private String productName;
    private String imagePath;

    public OrderDetailMapping(OrderDetail orderDetail, String productName, String imagePath) {
        this.orderDetail = orderDetail;
        this.productName = productName;
        this.imagePath = imagePath;
    }

    public OrderDetail getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(OrderDetail orderDetail) {
        this.orderDetail = orderDetail;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
