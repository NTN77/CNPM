package controller;

import model.bean.Cart;
import model.bean.Order;
import model.bean.User;
import model.dao.OrderDAO;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet(value = "/return")
public class ReturnMomoController extends HttpServlet {
     private static final String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";

    OrderDAO orderDAO = new OrderDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy tất cả parameters từ MoMo
            String partnerCode = request.getParameter("partnerCode");
            String orderId = request.getParameter("orderId");
            String requestId = request.getParameter("requestId");
            String amount = request.getParameter("amount");
            String orderInfo = request.getParameter("orderInfo");
            String orderType = request.getParameter("orderType");
            String transId = request.getParameter("transId");
            String resultCode = request.getParameter("resultCode");
            String message = request.getParameter("message");
            String payType = request.getParameter("payType");
            String responseTime = request.getParameter("responseTime");
            String extraData = request.getParameter("extraData");
            String signature = request.getParameter("signature");

            // Debug log
            System.out.println("=== MOMO RETURN ===");
            System.out.println("resultCode: " + resultCode);
            System.out.println("message: " + message);
            System.out.println("orderId: " + orderId);
            System.out.println("amount: " + amount);
            System.out.println("transId: " + transId);

            // Verify signature để đảm bảo request từ MoMo
            if (signature != null && !signature.isEmpty()) {
                String rawHash = "accessKey=F8BBA842ECF85" +
                        "&amount=" + (amount != null ? amount : "") +
                        "&extraData=" + (extraData != null ? extraData : "") +
                        "&message=" + (message != null ? message : "") +
                        "&orderId=" + (orderId != null ? orderId : "") +
                        "&orderInfo=" + (orderInfo != null ? orderInfo : "") +
                        "&orderType=" + (orderType != null ? orderType : "") +
                        "&partnerCode=" + (partnerCode != null ? partnerCode : "") +
                        "&payType=" + (payType != null ? payType : "") +
                        "&requestId=" + (requestId != null ? requestId : "") +
                        "&responseTime=" + (responseTime != null ? responseTime : "") +
                        "&resultCode=" + (resultCode != null ? resultCode : "") +
                        "&transId=" + (transId != null ? transId : "");

                String computedSignature = hmacSHA256(rawHash, secretKey);
                boolean isValidSignature = signature.equals(computedSignature);
                System.out.println("Signature valid: " + isValidSignature);

                if (!isValidSignature) {
                    System.out.println("Invalid signature from MoMo callback");
                }
            }

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("auth");
            Cart cart = (Cart) session.getAttribute("cart");
            if ("0".equals(resultCode)) {
                // Thanh toán thành công
                System.out.println("Payment SUCCESS");
                String address = (String) session.getAttribute("address");
                String phone = (String) session.getAttribute("phone");
                String  receiver= (String) session.getAttribute("receiver");
//                Integer totalPay = (Integer) session.getAttribute("totalPay");
                Integer ship = null;
                Object shipObj = session.getAttribute("ship");
                if (shipObj instanceof Integer) {
                    ship = (Integer) shipObj;
                } else if (shipObj instanceof String) {
                    try {
                        ship = Integer.parseInt((String) shipObj);
                    } catch (NumberFormatException e) {
                        System.out.println("Error parsing ship from session: " + shipObj);
                        ship = 0; // Default shipping fee
                    }
                } else {
                    ship = 0; // Default shipping fee
                }

                OrderDAO orderZ = new OrderDAO();

                Order order = new Order();
                order.setConsigneeName(receiver);
                order.setConsigneePhoneNumber(phone);
                order.setAddress(address);
                order.setShippingFee(ship);
                order.setTotalPrice(Double.parseDouble(amount));
                Integer accessCount = (Integer) session.getAttribute("accessCount");
                if (accessCount != null) {
                    accessCount = 0;
                    session.setAttribute("accessCount", accessCount);
                }
//           Xoasa sesion gio hàng
                orderZ.addOrder(order, cart, user);
                cart.clear();
                request.getSession().setAttribute("cart", cart);
                // Set attributes cho JSP
                request.setAttribute("status", "success");
                request.setAttribute("message", "Thanh toán thành công!");
                request.setAttribute("orderId", orderId);
                request.setAttribute("amount", amount);
                request.setAttribute("transId", transId);
//                OrderDAO.addOrder()

                // Redirect đến trang success
                response.sendRedirect(request.getContextPath() + "/views/ReturnMomo/order_success.jsp");
                return;

            } else {
                // Thanh toán thất bại
                System.out.println("Payment FAILED: " + message);
                // Set attributes cho JSP
                request.setAttribute("status", "failed");
                request.setAttribute("message", "Thanh toán thất bại: " + (message != null ? message : "Lỗi không xác định"));
                request.setAttribute("resultCode", resultCode);
                request.setAttribute("orderId", orderId);
            }

            // Forward đến trang hiển thị kết quả thất bại
            request.getRequestDispatcher("/views/ReturnMomo/paymentResult.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error processing MoMo return: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.setAttribute("message", "Có lỗi xảy ra trong quá trình xử lý thanh toán");
            request.getRequestDispatcher("/user/paymentResult.jsp").forward(request, response);
        }
    }

    private String hmacSHA256(String data, String key) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(), "HmacSHA256");
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(secretKey);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo chữ ký", e);
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}