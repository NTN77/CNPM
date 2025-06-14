package controller;

import com.google.gson.Gson;
import logs.EAction;
import logs.ELevel;
import logs.LoggingService;
import model.bean.*;
import model.dao.OrderDAO;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.NumberFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;


@WebServlet(name = "PaymentController", value = "/payment")
public class PayMentController extends HttpServlet {

    private static final int TIMEOUT_MINUTES = 1;
    private static final int TIMEOUT_SECONDS = TIMEOUT_MINUTES * 60;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        User user = (User) sessions.getAttribute("auth");
        Cart cart = (Cart) sessions.getAttribute("cart");
        Integer accessCount = (Integer) sessions.getAttribute("accessCount");
        if (accessCount == null) {
            accessCount = 1;
            System.out.println("accessCount " + accessCount);
            sessions.setAttribute("accessCount", accessCount);
        } else {
            accessCount += 1;
            System.out.println("accessCount " + accessCount);
            if (accessCount >= 5 && user != null) {
                LoggingService.getInstance().log(ELevel.DANGER, EAction.CREATE, req.getRemoteAddr(), user.getEmail() + " đã truy cập thanh toán nhiều lần (" + accessCount + ")");
            }
        }
        //Format gia tien
        Locale locale = new Locale("vi", "VN");
        Currency currency = Currency.getInstance(locale);
        NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
        numberFormat.setCurrency(currency);


        String backToCart = req.getParameter("backToCart");
        if (backToCart != null && backToCart.equals("true")) {
            increaseStockCheckout(cart);
            resp.sendRedirect(req.getContextPath() + "/views/CartPage/view/cart.jsp");
            return;
        }
//        Validation (isSale, discount & stock.
        boolean isValidCart = true;
        List<String> errorMessage = new ArrayList<>();


        for (Map.Entry<Integer, Item> entry : cart.getItems().entrySet()) {
            int productId = entry.getKey();
            Item item = entry.getValue();
            Product p = ProductService.getInstance().getProductById(productId);

            double price = ProductService.getInstance().productPriceIncludeDiscount(p);
            System.out.println("Item: " + item.toString());
            System.out.println("Product " + p.getName() + " isSale" + p.getIsSale() + "price : " + price);

            if (p.getIsSale() != 1 && p.getIsSale() != 3) {
                isValidCart = false;
                errorMessage.add("Sản phẩm \"" + p.getName() + "\" hiện đã ngừng kinh doanh.");
            }

            // Check quantity for normal and pre-order products
            if (p.getIsSale() == 1) {
                if (item.getQuantity() > p.getStock()) {
                    isValidCart = false;
                    errorMessage.add("Sản phẩm \"" + p.getName() + "\" hiện nay chỉ còn " + p.getStock() + " sản phẩm.");
                }
            } else if (p.getIsSale() == 3) {
                if (p.getStock() > 0) {
                    if (item.getQuantity() > p.getStock()) {
                        isValidCart = false;
                        errorMessage.add("Sản phẩm \"" + p.getName() + "\" hiện nay chỉ còn " + p.getStock() + " sản phẩm.");
                    }
                } else {
                    model.bean.PreOrder preOrder = model.service.PreOrderService.getInstance().getPreOrderById(productId);
                    int preOrderAmount = preOrder != null ? preOrder.getAmount() : 0;
                    if (item.getQuantity() > preOrderAmount) {
                        isValidCart = false;
                        errorMessage.add("Sản phẩm \"" + p.getName() + "\" chỉ còn " + preOrderAmount + " sản phẩm có thể đặt trước.");
                    }
                }
            }

            if (item.getPrice() != price) {
                isValidCart = false;
                errorMessage.add("Giá của sản phẩm \"" + p.getName() + "\" đã được cập nhật thành " + numberFormat.format(price));
            }
        }

        if (user == null) {
            resp.sendRedirect("views/Login/view_login/login.jsp");
        } else {
            if (isValidCart) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{ \"isValid\": true }"); // gui fan hoi json voi isValid = true
                //                doPost(req, resp);
                /// Khởi tạo thời gian cho việc get payment.
                long paymentStartTime = System.currentTimeMillis();
                Instant instant = Instant.ofEpochMilli(paymentStartTime);

                // Chuyển đổi từ Instant sang LocalDateTime
                LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
                System.out.println("Thời gian bắt đầu : " + LocalDateTime.ofInstant(instant, ZoneId.systemDefault()));

                //         giảm so luong stock + 5 phut bat dau
                sessions.setAttribute("paymentStartTime", paymentStartTime);
                sessions.setAttribute("timeCounter", TIMEOUT_MINUTES);
                reduceStockCheckout(cart);

            } else {
                sendErrorResponse(resp, errorMessage);
            }

        }
    }

    //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        User user = (User) sessions.getAttribute("auth");
        Cart cart = (Cart) sessions.getAttribute("cart");
        OrderDAO orderZ = new OrderDAO();

        req.setCharacterEncoding("UTF-8");
        String namePay = req.getParameter("namePay");
        String phonePay = req.getParameter("phonePay");
        String address = req.getParameter("formattedAddress");
        String shippingFee = req.getParameter("shippingFee");
        String totalAmount = req.getParameter("totalAmount");


//check validation
        Map<String, String> errors = new HashMap<>();

        validateRequireField("namePay", namePay, "Tên hiển thị", errors);
        validateRequireField("phonePay", phonePay, "Số điện thoại", errors);
        validateRequireField("formattedAddress", address, "Địa chỉ", errors);


        if (!errors.isEmpty() || shippingFee == null || totalAmount == null) {
//            req.setAttribute("errors", errors);
//            req.getRequestDispatcher("views/PaymentPage/payment.jsp").forward(req, resp);
//            return;
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Trả về lỗi 400 nếu dữ liệu không hợp lệ
            resp.getWriter().print("{\"success\": false, \"message\": \"Validation errors occurred.\"}");
            return;
        }
//             KIEM TRA THOI GIAN GIAO DỊCH

        Long paymentStartTime = (Long) sessions.getAttribute("paymentStartTime");
        Instant instant = Instant.ofEpochMilli(paymentStartTime);

        // Chuyển đổi từ Instant sang LocalDateTime
        LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
        System.out.println("Thời gian kết thúc: " + LocalDateTime.ofInstant(instant, ZoneId.systemDefault()));

        if (paymentStartTime == null || System.currentTimeMillis() - paymentStartTime > TIMEOUT_SECONDS * 1000) {
            increaseStockCheckout(cart);
//                resp.sendRedirect(req.getContextPath() + "/views/CartPage/view/cart.jsp");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);// Trả về lỗi 400 nếu hết thời gian thanh toán
            resp.getWriter().print("{\"success\": false, \"message\": \"Thời gian đặt hàng đã hết.\"}");
            return;
        }
        Order order = new Order();
        order.setConsigneeName(namePay);
        order.setConsigneePhoneNumber(phonePay);
        order.setAddress(address);
        order.setShippingFee(Integer.parseInt(shippingFee));
        order.setTotalPrice(Integer.parseInt(totalAmount));
        Integer accessCount = (Integer) sessions.getAttribute("accessCount");
        if (accessCount != null) {
            accessCount = 0;
            sessions.setAttribute("accessCount", accessCount);
        }
//           Xoasa sesion gio hàng
        orderZ.addOrder(order, cart, user);
        cart.clear();
        req.getSession().setAttribute("cart", cart);
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().print("{\"success\": true, \"message\": \"Đơn hàng đã được tạo.\"}");
//        resp.sendRedirect(req.getContextPath() + "/views/MainPage/view_mainpage/mainpage.jsp");
    }

    public static void validateRequireField(String fieldName, String value, String viewName, Map<String, String> errors) {
        if (value == null || value.trim().isEmpty()) {
            errors.put(fieldName, viewName + " không được bỏ trống");
        }
    }

    // Xử lý tăng - giảm lại giỏ hàng.
    private void reduceStockCheckout(Cart cart) {
        for (Map.Entry<Integer, Item> entry : cart.getItems().entrySet()) {
            int productId = entry.getKey();
            Item item = entry.getValue();
            int quantity = item.getQuantity();
            Product p = ProductService.getInstance().getProductById(productId);
            if (p.getIsSale() == 1) {
                ProductService.getInstance().reduceStock(productId, quantity);
            } else if (p.getIsSale() == 3) {
                if (p.getStock() > 0) {
                    ProductService.getInstance().reduceStock(productId, quantity);
                } else {
                    model.service.PreOrderService.getInstance().reducePreOrderAmount(productId, quantity);
                    // After reducing, check if pre-order amount is now zero and process accordingly
                    model.service.PreOrderService.getInstance().processExpiredPreOrderIfNeeded(productId);
                }
            }
        }
    }

    private void increaseStockCheckout(Cart cart) {
        for (Map.Entry<Integer, Item> entry : cart.getItems().entrySet()) {
            int productId = entry.getKey();
            Item item = entry.getValue();
            int quantity = item.getQuantity();
            Product p = ProductService.getInstance().getProductById(productId);
            
            if (p.getIsSale() == 3 && p.getStock() == 0) {
                // For pre-order products with no stock, increase pre-order amount
                model.service.PreOrderService.getInstance().increasePreOrderAmount(productId, quantity);
            } else {
                // For normal products or pre-order products with stock, increase stock
                ProductService.getInstance().increaseStock(productId, quantity);
            }
        }
    }

    // Phương thức để gửi phản hồi lỗi về cho client
    private void sendErrorResponse(HttpServletResponse response, List<String> errorMessage) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(errorMessage));
//        response.getWriter().write("{ \"isValid\": false, \"errorMessage\": \"" + errorMessage + "\" }");
    }
}