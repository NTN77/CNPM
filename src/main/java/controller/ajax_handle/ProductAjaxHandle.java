package controller.ajax_handle;

import com.google.gson.Gson;
import model.bean.Image;
import model.bean.Product;
import model.service.ImageService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/product-ajax-handle")
public class ProductAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productId = req.getParameter("productId");
        if (action != null && productId != null) {
            if (action.equals("deleteById")) {
                //xoa image src: duyet tat ca cac anh product
                List<Image> imageList = ImageService.getImagesForProduct(productId);
                System.out.println("check :" + imageList.size());
                for (Image i : imageList)
                    ImageService.deleteImageInServer(getServletContext(), i.getPath());
                ProductService.getInstance().deleteProduct(productId);
            } else if (action.equals("switchProductIsSale")) {
                ProductService.getInstance().switchIsSale(productId);
                Product p = ProductService.getInstance().getProductById(productId);
                Gson gson = new Gson();
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = gson.toJson(p);
                resp.getWriter().write(jsonResponse);
            }
        }
    }
}
