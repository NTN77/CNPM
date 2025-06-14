package controller.ajax_handle;

public class ProductDiscountInfoResponse {
    private int productId;
    private int discountId;
    private String asTextForShow;
    private boolean isAvailable;

    private double finalPrice;

    public ProductDiscountInfoResponse(int productId, int discountId, String asTextForShow, boolean isAvailable, double finalPrice) {
        this.productId = productId;
        this.discountId = discountId;
        this.asTextForShow = asTextForShow;
        this.isAvailable = isAvailable;
        this.finalPrice = finalPrice;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public String getAsTextForShow() {
        return asTextForShow;
    }

    public void setAsTextForShow(String asTextForShow) {
        this.asTextForShow = asTextForShow;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }
}
