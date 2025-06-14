package controller.admin;

import model.bean.Image;
import model.service.DiscountService;
import model.service.ImageService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminConfirm", value = "/confirm")
public class ConfirmAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        String selectedCategory = req.getParameter("selectedCategory");
        String confirm_delete_product_id = req.getParameter("confirm_delete_product_id");

        //Đang xử lý xóa 1 sán phẩm
        if (confirm_delete_product_id != null) {
            System.out.println("confirm_delete_product_id: " + confirm_delete_product_id);
            String confirm = req.getParameter("confirm");
            //Nếu ok -> xóa product, isShowChildFrame = hide
            if (confirm != null && confirm.equals("ok")) {
                //xoa image src: duyet tat ca cac anh product
                List<Image> imageList = ImageService.getImagesForProduct(confirm_delete_product_id);
                for (Image i : imageList)
                    ImageService.deleteImageInServer(getServletContext(), i.getPath());
                ProductService.getInstance().deleteProduct(confirm_delete_product_id);
                req.setAttribute("isShowChildFrame", "hide");
            }
            //Nếu cancel -> isShowChildFrame = hide
            else {
                req.setAttribute("isShowChildFrame", "hide");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/product?func=product_management&category_id=" + selectedCategory);
        }
        //Đang xử lý xo 1 discount
        String deleteDiscountId = req.getParameter("deleteDiscountId");
        if (deleteDiscountId != null) {
            String confirm = req.getParameter("confirm");
            //Nếu ok -> xóa discount
            if (confirm != null && confirm.equals("ok")) {
                DiscountService.getInstance().deleteDiscountById(deleteDiscountId);
            }
            //Nếu cancel
            else {
                System.out.println("Chưa xóa " + deleteDiscountId);
            }
            req.getRequestDispatcher("/views/Admin/discount_management.jsp").forward(req, resp);
        }
    }
}
