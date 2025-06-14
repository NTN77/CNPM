package model.dao;

import model.bean.*;
import model.db.JDBIConnector;
import model.service.DiscountService;
import model.service.OrderService;
import model.service.UserService;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

public class OrderDAO {
    public static List<Order> getAllOrder() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static Order getOrderById(String orderId) {
        Optional<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where id=:orderId")
                        .bind("orderId", orderId)
                        .mapToBean(Order.class)
                        .stream().findFirst()
        );
        return orders.isEmpty() ? null : orders.get();
    }

    public static List<OrderDetail> getOrderDetailsByOrderId(String orderId) {
        List<OrderDetail> orderDetails = JDBIConnector.me().withHandle(detail_handle ->
                detail_handle.createQuery("select * from order_details where orderId=:orderId")
                        .bind("orderId", orderId)
                        .mapToBean(OrderDetail.class).stream().collect(Collectors.toList())
        );
        return orderDetails;
    }

    public static int ordersNumber(String customerId, int status) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where userId=? and status=?")
                        .bind(0, customerId)
                        .bind(1, status)
                        .mapTo(Integer.class).one());
    }

    public static int ordersNumber(String userId) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where userId=?")
                        .bind(0, userId)
                        .mapTo(Integer.class).one());
    }

    public static long waitConfirmOrdersNumber() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where status=0")
                        .mapTo(Long.class).one());
    }

    public static long isPreparingOrdersNumber() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where status=1")
                        .mapTo(Long.class).one());
    }


    public static long deliveringOrdersNumber() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where status=2")
                        .mapTo(Long.class).one());
    }

    public static List<Order> getWaitConfirmOrders() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where status=0 order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getPreparingOrders() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where status=1 order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getDeliveringOrders() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where status=2 order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getCanceledOrders() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where status=4 order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getSucccessfulOrders() {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where status=3 order by orderDate desc")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getOrderByCustomerId(String customerId) {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where userId=? order by orderDate desc")
                        .bind(0, customerId)
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getOrderByCustomerId(String customerId, int limit, int offset) {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where userId=? order by orderDate desc LIMIT ? OFFSET ?")
                        .bind(0, customerId)
                        .bind(1, limit)
                        .bind(2, offset)
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getOrderByCustomerId(String customerId, int limit, int offset, int statusNumber) {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where userId=? and status=? order by orderDate desc LIMIT ? OFFSET ?")
                        .bind(0, customerId)
                        .bind(1, statusNumber)
                        .bind(2, limit)
                        .bind(3, offset)
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static List<Order> getOrderByCustomerNamePart(String customerNamePart) {
        List<Order> orders = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order` where userId IN(" +
                                "select id from user where name like ?) order by orderDate desc")
                        .bind(0, "%" + customerNamePart + "%")
                        .mapToBean(Order.class)
                        .stream().collect(Collectors.toList())
        );
        return orders;
    }

    public static void cancelOrder(String orderId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `order` SET status = 4 WHERE id=?")
                        .bind(0, orderId)
                        .execute()
        );
    }

    public static void confirmOrder(String orderId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `order` SET status = 1 WHERE id=?")
                        .bind(0, orderId)
                        .execute()
        );
    }

    public static void preparingOder(String orderId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `order` SET status = 2 WHERE id=?")
                        .bind(0, orderId)
                        .execute()
        );
    }

    public static void deliveredOrder(String orderId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `order` SET status = 3 WHERE id=?")
                        .bind(0, orderId)
                        .execute()
        );
    }

    public static double getRevenueForMonth(int month, int year) {
        String sql = "SELECT SUM(totalPrice) FROM `order` WHERE MONTH(orderDate) = ? AND YEAR(orderDate) = ? AND status=3";
        Double re = JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, month)
                        .bind(1, year)
                        .mapTo(Double.class).one());
        return re != null ? re : 0;
    }

    public static double getMonthRevenueMax(int year) {
        String sql = "SELECT MAX(totalPrice) FROM (SELECT SUM(totalPrice) AS totalPrice FROM `order` WHERE YEAR(orderDate) = ? AND status=3 GROUP BY MONTH(orderDate)) AS monthlyRevenue";
        Double re = JDBIConnector.me().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, year)
                        .mapTo(Double.class).one());
        return re != null ? re : 0;
    }

    public static int getCancelOrderNumber(int userId) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from `order` where userId=? and status=4")
                        .bind(0, userId)
                        .mapTo(Integer.class).one());
    }

    public static List<OrderImage> getOrderCustomByCustomerId(int userId) {
        List<OrderImage> orderImages = JDBIConnector.me().withHandle(detail_handle ->
                detail_handle.createQuery("select * from order_images where userId=:userId")
                        .bind("userId", userId)
                        .mapToBean(OrderImage.class).stream().collect(Collectors.toList())
        );
        return orderImages;
    }

    public static OrderImage getOrderCustomById(int orderId) {
        Optional<OrderImage> orderImage = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order_images` where id=:orderId")
                        .bind("orderId", orderId)
                        .mapToBean(OrderImage.class)
                        .stream().findFirst()
        );
        return orderImage.isEmpty() ? null : orderImage.get();
    }

    /**
     * Thêm giỏ hàng - đặt hàng vào dâtabase !
     *
     * @param order
     * @param cart
     * @param u
     */
    public void addOrder(Order order, Cart cart, User u) {
//        Kiểm tra order có null không?
        if (order == null) {
            throw new IllegalArgumentException("Order object is null");
        }

        LocalDate curDate = LocalDate.now();
        String date = curDate.toString();
        /*        Add vào bảng order trước -> Tạo orderId.


         */
        String sql = "INSERT INTO `order` ( totalPrice, orderDate, status, consigneeName, consigneePhoneNumber, address ,shippingFee,  userId, note)"
                +
                " VALUES(:totalPrice, :orderDate, :status, :consigneeName, :consigneePhoneNumber , :address,:shippingFee, :userId, :note)";

        try {
            JDBIConnector.me().useHandle(handle -> {

                //Lấy id của order
                int orderId = handle.createUpdate(sql)
                        .bind("totalPrice", order.getTotalPrice())
                        .bind("orderDate", date)
                        .bind("status", 0)
                        .bind("consigneeName", order.getConsigneeName())
                        .bind("consigneePhoneNumber", order.getConsigneePhoneNumber())
                        .bind("address", order.getAddress())
                        .bind("shippingFee", order.getShippingFee())
                        .bind("userId", u.getId())
                        .bind("note", order.getNote())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();
                System.out.println("check 0: " + orderId);
                for (Item i : cart.getItems().values()) {
                    System.out.println("check 1: " + i.getProduct().getId());
                    //add vào bảng order-details !
                    String sql1 = "INSERT INTO `order_details` (orderId, productId, quantity, sellingPrice, finalSellingPrice)"
                            + "VALUES(:orderId, :productId, :quantity, :sellingPrice, :finalSellingPrice)";
                    JDBIConnector.me().useHandle(handle1 -> {
                        handle1.createUpdate(sql1)
                                .bind("orderId", orderId)
                                .bind("productId", i.getProduct().getId())
                                .bind("quantity", i.getQuantity())
                                .bind("sellingPrice", i.getProduct().getSellingPrice())
                                .bind("finalSellingPrice", i.getPrice())
                                .execute();
                    });

                    System.out.println("check final: ");
                }

            });

//            cập nhật lại số lượng sản phẩm
            String sql3 = "UPDATE `inventory` SET soldOut= soldOut + :quantityOrder where productId= :id";
            for (Item item : cart.getItems().values()) {
                JDBIConnector.me().useHandle(handle3 ->
                        handle3.createUpdate(sql3)
                                .bind("quantityOrder", item.getQuantity())
                                .bind("id", item.getProduct().getId())
                                .execute());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to insert order into the database", e);
        }
    }


    public static void main(String[] args) {
//
        for (Order order : getAllOrder()) {
            System.out.println(order.getId() + " - " + getExactlyTotalPriceNoShippingFee(order.getId() + ""));
        }

    }

    public static double getExactlyTotalPriceNoShippingFee(String orderId) {
        double re = 0;
        for (OrderDetail orderDetail : OrderService.getInstance().getOrderDetailsByOrderId(orderId))
            re += orderDetail.getQuantity() * orderDetail.getFinalSellingPrice();

        return re;
    }

    public static void addOrderImage(OrderImage orderImage) {
        if (orderImage == null) {
            throw new IllegalArgumentException("Đơn hàng custom không có");
        }

        String sql = "INSERT INTO order_images (imagePath, productId, orderDate, tel, note, userId, status, address, recieveDate, otherCustom) VALUES (:imagePath, :productId, :orderDate, :tel, :note, :userId, :status, :address, :recieveDate, :otherCustom)";

        try {
            JDBIConnector.me().useHandle(handle -> {
                handle.createUpdate(sql)
                        .bind("productId", orderImage.getProductId())
                        .bind("imagePath", orderImage.getImagePath())
                        .bind("orderDate", orderImage.getOrderDate())
                        .bind("tel", orderImage.getTel())
                        .bind("note", orderImage.getNote())
                        .bind("userId", orderImage.getUserId())
                        .bind("status", orderImage.getStatus())
                        .bind("address", orderImage.getAddress())
                        .bind("recieveDate", orderImage.getRecieveDate())
                        .bind("otherCustom", orderImage.getOtherCustom())
                        .execute();
            });
            System.out.println("Add order custom");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Thêm đơn hàng custom thất bại", e);
        }
    }

    public static List<OrderImage> getAllOrderCustom(){
        List<OrderImage> orders_custom = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from `order_images` ")
                        .mapToBean(OrderImage.class)
                        .stream().collect(Collectors.toList())
        );
        return orders_custom;
    }

    public static boolean updateOrderStatus(int orderId, int status) {
        int result = JDBIConnector.me().withHandle(handle ->
                handle.createUpdate("UPDATE `order_images` SET status = :status WHERE id = :id")
                        .bind("status", status)
                        .bind("id", orderId)
                        .execute()
        );
        return result > 0;
    }


}