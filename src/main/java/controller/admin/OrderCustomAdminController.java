package controller.admin;

import model.service.JavaMail.MailService;
import model.service.OrderService;
import model.bean.OrderImage;
import model.service.UserService;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/order-custom")
public class OrderCustomAdminController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String cancelReason = request.getParameter("cancelReason");
        String orderIdStr = request.getParameter("orderId");
        OrderImage order = OrderService.getInstance().getOrderCustomById(Integer.parseInt(orderIdStr));

        try {
            int orderId = Integer.parseInt(orderIdStr);

            if ("confirm".equals(action)) {
                OrderService.getInstance().updateOrderStatus(orderId, 1);
                MailService.sendNotifyConfirmOrder(
                        UserService.getInstance().getUserById(String.valueOf(order.getUserId())).getEmail(),
                        order
                );

                response.getWriter().write("success");
            } else if ("cancel".equals(action)) {
                if (cancelReason == null || cancelReason.trim().isEmpty()) {
                    response.getWriter().write("missing_reason");
                    return;
                }

                OrderService.getInstance().updateOrderStatus(orderId, 4);
                MailService.sendNotifyCanceledOrder(
                        UserService.getInstance().getUserById(String.valueOf(order.getUserId())).getEmail(),
                        order,
                        cancelReason
                );
                response.getWriter().write("success");
            } else {
                response.getWriter().write("invalid_action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
