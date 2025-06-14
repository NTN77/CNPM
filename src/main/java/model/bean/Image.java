package model.bean;

public class Image {

    private int id;
    private String name;
    private String path;
    private int productId;

    public Image() {

    }

    public Image(int id, String name, String path, int productId) {
        this.id = id;
        this.name = name;
        this.path = path;
        this.productId = productId;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {

        this.productId = productId;
    }

    @Override
    public String toString() {
        return "Image{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", path='" + path + '\'' +
                ", productId='" + productId + '\'' +

                '}';
    }
}