package controller.ajax_handle;

import model.bean.Order;
import model.bean.User;

import java.io.Serializable;
import java.util.List;

public class OrderDetailsResponse implements Serializable {
    private Order order;
    private User user;
    private List<OrderDetailMapping> orderDetailMappings;

    public OrderDetailsResponse(Order order, User user, List<OrderDetailMapping> orderDetailMappings) {
        this.order = order;
        this.user = user;
        this.orderDetailMappings = orderDetailMappings;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderDetailMapping> getOrderDetails() {
        return orderDetailMappings;
    }
    public void setOrderDetails(List<OrderDetailMapping> orderDetailMappings) {
        this.orderDetailMappings = orderDetailMappings;
    }
}