package controller.ajax_handle;

import com.google.gson.Gson;
import model.bean.Discount;
import model.bean.Product;
import model.service.DiscountService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/discount-ajax-handle")
public class DiscountAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        System.out.println("action " + action);
        if (action != null) {
            String discountId = req.getParameter("discountId");
            if (action.equals("unAllDiscount")) {
                ProductService.getInstance().unSetDiscountForAllProducts();
            } else if (action.equals("discountForAll")) {
                ProductService.getInstance().setDiscountForAllProducts(discountId);
            } else if (action.equals("unDiscountForAll")) {
                ProductService.getInstance().unSetDiscountForAllProducts(discountId);
            } else if (action.equals("discountByCategory")) {
                String categoryId = req.getParameter("categoryId");
                ProductService.getInstance().setDiscountByCategory(discountId, categoryId);
            } else if (action.equals("unDiscountByCategory")) {
                String categoryId = req.getParameter("categoryId");
                ProductService.getInstance().unSetDiscountByCategory(discountId, categoryId);
            } else if (action.equals("discountForProduct")) {
                String productId = req.getParameter("productId");
                ProductService.getInstance().setDiscountByProduct(discountId, productId);
            } else if (action.equals("unDiscountForProduct")) {
                String categoryId = req.getParameter("categoryId");
                String productId = req.getParameter("productId");
                ProductService.getInstance().unSetDiscountByProduct(discountId, productId);
            } else if (action.equals("discountByQuantity")) {
                String number = req.getParameter("number");
                String comparison = req.getParameter("comparison");
                System.out.println(discountId + " - " + number + " - " + comparison);
                ProductService.getInstance().setDiscountByQuantity(discountId, Integer.parseInt(number), Integer.parseInt(comparison));
            } else if (action.equals("unDiscountByQuantity")) {
                String number = req.getParameter("number");
                String comparison = req.getParameter("comparison");
                ProductService.getInstance().unSetDiscountByQuantity(discountId, Integer.parseInt(number), Integer.parseInt(comparison));

            } else if (action.equals("reloadGUI")) {
                String productId = req.getParameter("productId");
                ProductService.getInstance().setDiscountByProduct(discountId, productId);
                Product p = ProductService.getInstance().getProductById(productId);
                Discount d = DiscountService.getInstance().getDiscountById(discountId);
                double finalPrice = ProductService.getInstance().productPriceIncludeDiscount(p);
                String asTextForShow = (d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%";
                boolean isAvailable = (finalPrice != p.getSellingPrice()) ? true : false;
                ProductDiscountInfoResponse res = new ProductDiscountInfoResponse(p.getId(), d.getId(), asTextForShow, isAvailable, finalPrice);
                Gson gson = new Gson();
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = gson.toJson(res);
                resp.getWriter().write(jsonResponse);
            }
        }
    }
}
