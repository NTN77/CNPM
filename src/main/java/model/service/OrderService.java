package model.service;

import model.bean.Discount;
import model.bean.Order;
import model.bean.OrderDetail;
import model.bean.OrderImage;
import model.dao.DiscountDAO;
import model.dao.OrderDAO;

import java.util.ArrayList;
import java.util.List;

public class OrderService {
    private static OrderService instance;

    public static OrderService getInstance() {
        if (instance == null) instance = new OrderService();
        return instance;
    }


    public List<Order> getAllOrder() {
        return OrderDAO.getAllOrder();
    }

    public Order getOrderById(String orderId) {
        return OrderDAO.getOrderById(orderId);
    }

    public List<Order> getOrderByCustomerId(String customerId) {
        return OrderDAO.getOrderByCustomerId(customerId);
    }

    public List<Order> getOrderByCustomerId(String customerId, int limit, int offset) {
        return OrderDAO.getOrderByCustomerId(customerId, limit, offset);
    }
    public List<Order> getOrderByCustomerId(String customerId, int limit, int offset, int statusNumber) {
        return OrderDAO.getOrderByCustomerId(customerId, limit, offset, statusNumber);
    }

    public int ordersNumber(String customerId) {
        return OrderDAO.ordersNumber(customerId);
    }

    public int ordersNumber(String customerId, int status) {
        return OrderDAO.ordersNumber(customerId, status);
    }

    public List<Order> getOrderByCustomerNamePart(String customerNamePart) {
        return OrderDAO.getOrderByCustomerNamePart(customerNamePart);
    }

    public List<OrderDetail> getOrderDetailsByOrderId(String orderId) {
        return OrderDAO.getOrderDetailsByOrderId(orderId);
    }

    public long waitConfirmOrdersNumber() {
        return OrderDAO.waitConfirmOrdersNumber();
    }

    public long deliveringOrdersNumber() {
        return OrderDAO.deliveringOrdersNumber();
    }

    public void cancelOrder(String orderId) {
        OrderDAO.cancelOrder(orderId);
    }

    public void confirmOrder(String orderId) {
        OrderDAO.confirmOrder(orderId);
    }
    public void preparingOder(String orderId) {
        OrderDAO.preparingOder(orderId);
    }

    public void deliveredOrder(String orderId) {
        OrderDAO.deliveredOrder(orderId);
    }

    public List<Order> getWaitConfirmOrders() {
        return OrderDAO.getWaitConfirmOrders();
    }

    public List<Order> getPreparingOrders() {
        return OrderDAO.getPreparingOrders();
    }

    public List<Order> getDeliveringOrders() {
        return OrderDAO.getDeliveringOrders();
    }

    public List<Order> getCanceledOrders() {
        return OrderDAO.getCanceledOrders();
    }

    public List<Order> getSucccessfulOrders() {
        return OrderDAO.getSucccessfulOrders();
    }

    public double getRevenueForMonth(int month, int year) {
        return OrderDAO.getRevenueForMonth(month, year);
    }

    public double getMonthRevenueMax(int year) {
        return OrderDAO.getMonthRevenueMax(year);
    }

    public double getExactlyTotalPriceNoShippingFee(String orderId) {
        return OrderDAO.getExactlyTotalPriceNoShippingFee(orderId);
    }
    public int getCancelOrderNumber(int userId) {
        return OrderDAO.getCancelOrderNumber(userId);
    }

    public List<OrderImage> getAllOrderCustom(){
        return OrderDAO.getAllOrderCustom();
    }

    public static void main(String[] args) {
        System.out.println(getInstance().getOrderById("4444"));
    }

    public boolean updateOrderStatus(int orderId, int i) {
        return OrderDAO.updateOrderStatus(orderId, i);
    }

    public List<OrderImage> getOrderCustomByCustomerId(int userId) {
        return OrderDAO.getOrderCustomByCustomerId(userId);
    }

    public OrderImage getOrderCustomById(int orderId){
        return OrderDAO.getOrderCustomById(orderId);
    }
}