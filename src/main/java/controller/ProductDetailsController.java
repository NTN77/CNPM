package controller;

import model.bean.Category;
import model.bean.Image;
import model.bean.Product;
import model.bean.Rate;
import model.dao.ProductDAO;
import model.service.CategoryService;
import model.service.ProductService;
import model.service.PreOrderService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "Product-Detail", value = "/product-detail")
public class ProductDetailsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//Kiểm tra khi tăng số lượng mua > số lượng hàng có sẵn nè
        boolean alert =req.getParameter("invalid-quantity") != null;


        //Lấy id từ sản phẩm được chọn !!
        int id = Integer.parseInt(req.getParameter("id"));

//Lấy sản phẩm từ database với id đã được chọn
        Product product = ProductDAO.getProduct(id);
        Category category = CategoryService.getInstance().getCategoryById(product.getCategoryId());
        List<Image> imageList = ProductDAO.getImagesForProduct(id);
        //Lâấy ra 5 sản phẩm liên quan!!
        List<Product> relatedList = ProductService.getInstance().getRelatedProduct(product.getId(), product.getCategoryId(), 5);

//Bình luận
        List<Rate> rateList = ProductService.getInstance().getRateForProduct(product.getId());



        //Kiểm tra số lượng có sẵn , nếu quantity = soldout => disable lẹ ko cho thêm vào giỏ hàng
        String disable = "";

        if(product.getStock() <= 0) {
        disable = "disable";

        }
//Thiết lập chế đô active từ menu bar (trang chủ)
    String active = "active";

        req.setAttribute("alert", alert);
        req.setAttribute("disable", disable);
        req.setAttribute("shop_active", active);

//Các thông tin chi tiết của sản phẩm.
        req.setAttribute("productById", product);
        req.setAttribute("listImage",imageList );
        req.setAttribute("categoryByProduct", category);
        req.setAttribute("productRelated", relatedList);

        //Caác thông tin dành cho mục bình luận
        req.setAttribute("listRate",rateList );

        // Get pre-order amount if product is a pre-order product
        if (product.getIsSale() == 3) {
            model.bean.PreOrder preOrder = PreOrderService.getInstance().getPreOrderById(product.getId());
            if (preOrder != null) {
                req.setAttribute("preOrderAmount", preOrder.getAmount());
            } else {
                req.setAttribute("preOrderAmount", null);
            }
        }

         ServletContext context = req.getServletContext();
        String absolutePath = context.getRealPath("/");
        String jspPath = "/views/product-details/view/productdt.jsp";

        String fullPath = absolutePath + jspPath;

        System.out.println("Full path to JSP file: " + fullPath);

        RequestDispatcher rq = req.getRequestDispatcher(jspPath);
        rq.forward(req, resp);
    }
}
