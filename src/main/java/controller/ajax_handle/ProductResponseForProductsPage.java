package controller.ajax_handle;

public class ProductResponseForProductsPage {
    private int id;
    private String name;
    private int sellingPrice;
    private int stock;
    private double finalPrice;
    private String imagePath;
    private double averageRateStars;

    private double percentageOff;

    public ProductResponseForProductsPage(int id, String name, int sellingPrice, int stock, double finalPrice, String imagePath, double averageRateStars, double percentageOff) {
        this.id = id;
        this.name = name;
        this.sellingPrice = sellingPrice;
        this.stock = stock;
        this.finalPrice = finalPrice;
        this.imagePath = imagePath;
        this.averageRateStars = averageRateStars;
        this.percentageOff = percentageOff;
    }
}
