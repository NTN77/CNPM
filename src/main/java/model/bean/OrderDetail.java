package model.bean;

public class OrderDetail {
    private int orderId;
    private int productId;
    private int quantity;

    private double sellingPrice;
    private double finalSellingPrice;
    private String explainPriceDifference;

    public OrderDetail() {
    }


    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public double getFinalSellingPrice() {
        return finalSellingPrice;
    }

    public void setFinalSellingPrice(double finalSellingPrice) {
        this.finalSellingPrice = finalSellingPrice;
    }

    public String getExplainPriceDifference() {
        return explainPriceDifference;
    }

    public void setExplainPriceDifference(String explainPriceDifference) {
        this.explainPriceDifference = explainPriceDifference;
    }

    @Override
    public String toString() {
        return
                "orderId=" + orderId +
                        "{" + productId + " - " + quantity +
                        '}';
    }
}