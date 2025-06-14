package controller.admin;

import model.bean.PreOrder;
import model.bean.Product;
import model.service.PreOrderService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

@WebServlet(name = "PreOrderAdminController", urlPatterns = {"/admin/preorder/*"})
public class PreOrderAdminController extends HttpServlet {
    private Timer timer;
    private static final long CHECK_INTERVAL = 60 * 1000; // Check every 1 mins

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize timer for checking expired pre-orders
        timer = new Timer(true);
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                checkAndProcessExpiredPreOrders();
            }
        }, 0, CHECK_INTERVAL);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if ("/create".equals(action)) {
            createPreOrder(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if ("/details".equals(action)) {
            getPreOrderDetails(request, response);
        }
    }

    private void createPreOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int amount = Integer.parseInt(request.getParameter("amount"));
            String dateEndStr = request.getParameter("dateEnd");
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dateEnd = dateFormat.parse(dateEndStr);
            
            // Add date validation check
            if (dateEnd.before(new Date())) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Ngày kết thúc phải sau ngày hiện tại\"}");
                return;
            }
            
            // Create pre-order using service
            PreOrderService.getInstance().addPreOrder(productId, amount, dateEnd);
            
            // Update product status to pre-order (isSale = 3)
            Product product = ProductService.getInstance().getProductById(productId);
            if (product != null) {
                product.setIsSale(3);
                ProductService.getInstance().editProduct(
                    String.valueOf(productId),
                    product.getName(),
                    product.getDescription(),
                    product.getSellingPrice(),
                    String.valueOf(product.getCategoryId()),
                    String.valueOf(product.getDiscountId()),
                    3
                );
            }
            
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"status\":\"success\"}");
            
        } catch (ParseException e) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Định dạng ngày không hợp lệ\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Định dạng số không hợp lệ\"}");
        }
    }

    private void getPreOrderDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        PreOrder preOrder = PreOrderService.getInstance().getPreOrderById(productId);
        
        response.setContentType("text/html;charset=UTF-8");
        
        if (preOrder == null) {
            // Return empty string to indicate no pre-order exists
            response.getWriter().write("");
            return;
        }
        
        StringBuilder html = new StringBuilder();
        html.append("<div class='pre-order-details'>");
        html.append("<h4>Chi tiết đặt hàng trước</h4>");
        html.append("<table class='table'>");
        html.append("<thead><tr><th>Tên sản phẩm</th><th>Số lượng</th><th>Ngày kết thúc</th></tr></thead>");
        html.append("<tbody>");
        
        html.append("<tr>");
        html.append("<td>").append(preOrder.getProductName()).append("</td>");
        html.append("<td>").append(preOrder.getAmount()).append("</td>");
        html.append("<td>").append(new SimpleDateFormat("dd/MM/yyyy").format(preOrder.getDateEnd())).append("</td>");
        html.append("</tr>");
        
        html.append("</tbody></table>");
        html.append("</div>");
        
        response.getWriter().write(html.toString());
    }

    private void checkAndProcessExpiredPreOrders() {
        try {
            List<PreOrder> allPreOrders = PreOrderService.getInstance().getAllPreOrder();
            Date currentDate = new Date();
            
            if (allPreOrders != null) {
                for (PreOrder preOrder : allPreOrders) {
                    if (preOrder.getDateEnd().before(currentDate)) {
                        // Update product quantity
                        Product product = ProductService.getInstance().getProductById(preOrder.getProductId());
                        if (product != null) {
                            // Update product status to available (isSale = 1)
                            ProductService.getInstance().editProduct(
                                String.valueOf(product.getId()),
                                product.getName(),
                                product.getDescription(),
                                product.getSellingPrice(),
                                String.valueOf(product.getCategoryId()),
                                String.valueOf(product.getDiscountId()),
                                1
                            );
                            
                            // Increase stock
                            ProductService.getInstance().increaseStock(product.getId(), preOrder.getAmount());
                        }
                        
                        // Remove the expired pre-order
                        PreOrderService.getInstance().removePreOrderById(preOrder.getId());
                    }
                }
            }
        } catch (Exception e) {
            // Log the error but don't throw it since this runs in a background thread
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
        if (timer != null) {
            timer.cancel();
        }
        super.destroy();
    }
}
