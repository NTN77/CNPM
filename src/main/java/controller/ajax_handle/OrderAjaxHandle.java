package controller.ajax_handle;

import com.google.gson.Gson;
import logs.EAction;
import logs.ELevel;
import logs.LoggingService;
import model.bean.Order;
import model.bean.OrderDetail;
import model.bean.Product;
import model.bean.User;
import model.service.ImageService;
import model.service.JavaMail.MailService;
import model.service.OrderService;
import model.service.ProductService;
import model.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@WebServlet("/order-ajax-handle")
public class OrderAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String orderId = req.getParameter("orderId");
        System.out.println("init: " + action);
        User sessionUser = (User) req.getSession().getAttribute("auth");

        if (action != null && orderId != null) {
            Order order = OrderService.getInstance().getOrderById(orderId);
//            admin handle
            if (sessionUser != null && (sessionUser.isOwn() || sessionUser.isAdmin())) {
                if (action.equals("deliveredOrder")) {
                    OrderService.getInstance().deliveredOrder(orderId);

                    String message = sessionUser.nameAsRole() + " " + sessionUser.getName() + " đã xác nhận đã giao đơn hàng có mã " + orderId;
                    LoggingService.getInstance().log(ELevel.INFORM, EAction.UPDATE, req.getRemoteAddr(), message);

                    resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
                } else if (action.equals("confirmOrder")) {
                    MailService.sendNotifyConfirmOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order);
                    OrderService.getInstance().confirmOrder(orderId);

                    String message = sessionUser.nameAsRole() + " " + sessionUser.getName() + " đã xác nhận đơn hàng có mã " + orderId;
                    LoggingService.getInstance().log(ELevel.INFORM, EAction.UPDATE, req.getRemoteAddr(), message);

                    resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
                } else if (action.equals("preparingOder")) {
                    OrderService.getInstance().preparingOder(orderId);
                    String message = sessionUser.nameAsRole() + " " + sessionUser.getName() + " đã xác nhận đang giao đơn hàng có mã " + orderId;
                    LoggingService.getInstance().log(ELevel.INFORM, EAction.UPDATE, req.getRemoteAddr(), message);
                } else if (action.equals("cancelOrder")) {
                    String cancelReason = req.getParameter("cancelReason");
                    MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order, cancelReason == null ? "" : cancelReason);
                    OrderService.getInstance().cancelOrder(orderId);
                    String message = sessionUser.nameAsRole() + " " + sessionUser.getName() + " đã hủy bỏ đơn hàng có mã " + orderId;
                    LoggingService.getInstance().log(ELevel.INFORM, EAction.UPDATE, req.getRemoteAddr(), message);
                    resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
                }
            }
//            showOrder, cancel Order from customer,
            if (action.equals("showOrder")) {
                Order o = OrderService.getInstance().getOrderById(orderId);
                User u = UserService.getInstance().getUserById(o.getUserId() + "");
                List<OrderDetailMapping> orderDetailMappings = new ArrayList<>();
                Product product;
                String image;
                for (OrderDetail od : OrderService.getInstance().getOrderDetailsByOrderId(orderId)) {
                    product = ProductService.getInstance().getProductById(od.getProductId());
                    image = ImageService.pathImageOnly(product.getId());
                    orderDetailMappings.add(new OrderDetailMapping(od, product.getName(), image));
                }
                OrderDetailsResponse orderDetailsResponse = new OrderDetailsResponse(o, u, orderDetailMappings);
                Gson gson = new Gson();
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = gson.toJson(orderDetailsResponse);
                resp.getWriter().write(jsonResponse);
            } else if (action.equals("customerCancelOrder")) {
                if (OrderService.getInstance().getOrderById(orderId).getUserId() == sessionUser.getId()) {
                    String cancelReason = req.getParameter("cancelReason");
                    OrderService.getInstance().cancelOrder(orderId);


                    String message = sessionUser.isUser() ? "Khách hàng " + sessionUser.getEmail() + " đã hủy bỏ đơn hàng có mã " + orderId : sessionUser.getName() + " đã hủy bỏ đơn hàng có mã " + orderId;
                    LoggingService.getInstance().log(ELevel.ALERT, EAction.UPDATE, req.getRemoteAddr(), message);

                    int cancelOrderNumber = OrderService.getInstance().getCancelOrderNumber(sessionUser.getId());
                    if (cancelOrderNumber >= 3) {
                        LoggingService.getInstance().log(ELevel.WARNING, EAction.UPDATE, req.getRemoteAddr(), "Tài khoản " + sessionUser.getEmail() + " có dấu hiệu hủy bỏ quá nhiều đơn hàng: Tổng số đơn đã hủy là " + cancelOrderNumber);
                    }

                    MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order, cancelReason == null ? "" : cancelReason);
                    resp.getWriter().write(String.valueOf(OrderService.getInstance().getOrderById(orderId).getStatus()));
                }
            }
        } else {
            if (action.equals("moreOrder")) {
                String userId = req.getParameter("userId");
                String limit = req.getParameter("limit");
                String offset = req.getParameter("offset");
                String statusNumber = req.getParameter("statusNumber");
                try {
                    List<Order> moreOrders = (statusNumber != null && (
                            statusNumber.equals("0")
                                    || statusNumber.equals("1")
                                    || statusNumber.equals("2")
                                    || statusNumber.equals("3")
                                    || statusNumber.equals("4"))) ?
                            OrderService.getInstance().getOrderByCustomerId(userId, Integer.parseInt(limit), Integer.parseInt(offset), Integer.parseInt(statusNumber)) :
                            OrderService.getInstance().getOrderByCustomerId(userId, Integer.parseInt(limit), Integer.parseInt(offset));
                    List<OrderResponse> orderResponses = new ArrayList<>();
                    HashMap map;
                    Product p;
                    String imagePath;
                    OrderResponse orderResponse;
                    for (Order o : moreOrders) {
                        map = new HashMap();
                        for (OrderDetail orderDetail : OrderService.getInstance().getOrderDetailsByOrderId(o.getId()
                                + "")) {
                            p = ProductService.getInstance().getProductById(orderDetail.getProductId() + "");
                            imagePath = ImageService.pathImageOnly(p.getId());
                            map.put(p.getName(), imagePath);
                        }
                        orderResponse = new OrderResponse(o, map);
                        orderResponses.add(orderResponse);
                    }

                    Gson gson = new Gson();
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    String jsonResponse = gson.toJson(orderResponses);
                    resp.getWriter().write(jsonResponse);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (action.equals("getNumberFilter")) {
                String userId = req.getParameter("userId");
                String statusNumber = req.getParameter("statusNumber");
                if (userId != null) {
                    try {
                        int number = (statusNumber != null) ? OrderService.getInstance().ordersNumber(userId, Integer.parseInt(statusNumber)) : OrderService.getInstance().ordersNumber(userId);
                        resp.getWriter().write(String.valueOf(number));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
