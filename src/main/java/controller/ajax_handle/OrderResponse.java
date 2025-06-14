package controller.ajax_handle;

import model.bean.Order;

import java.util.HashMap;

public class OrderResponse {
    private Order order;
    private HashMap<String, String> image_name;

    public OrderResponse(Order order, HashMap<String, String> image_name) {
        this.order = order;
        this.image_name = image_name;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public HashMap<String, String> getImage_name() {
        return image_name;
    }

    public void setImage_name(HashMap<String, String> image_name) {
        this.image_name = image_name;
    }
}