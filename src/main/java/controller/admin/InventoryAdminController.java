package controller.admin;

import model.adapter.InventoryProduct;
import model.service.CategoryService;
import model.service.ImageService;
import model.service.InventoryService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InventoryAdminController", value = "/admin/inventory")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 100
)
public class InventoryAdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int productId = Integer.parseInt(req.getParameter("id"));
        InventoryProduct product = InventoryService.getInstance().getIdProduct(productId);

        req.setAttribute("product_detail", product);

        req.getRequestDispatcher("/views/Admin/product_detail_update.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String productId = req.getParameter("last_edit_product_id");
        String productName = req.getParameter("productName");
        String sellingPrice = req.getParameter("sellingPrice");
        int isSale = Integer.parseInt(req.getParameter("isSale"));

        String radio_choiceCategory = req.getParameter("choiceCategory");

        String discountId = req.getParameter("discount");

        String availableCategory = req.getParameter("availableCategory");//category id
        String newCategory = req.getParameter("newCategory");
        /**
         *  discount  vs non discount.
         */


        String description = req.getParameter("description");

//
        List<String> paths = ImageService.writeProductImagesFromClient(productName, req, resp, getServletContext());
        if (!paths.isEmpty()) {
            ImageService.insertImages(productId, paths);
        }

        // Kiểm tra điều kiện
        if (productName == null || productName.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                radio_choiceCategory == null || radio_choiceCategory.isEmpty()) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"status\":\"error\"}");
            return;
        }

        if(radio_choiceCategory.equals("choiceNewCategory") && newCategory.trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"status\":\"error\"}");
            return;

        }

        int costPrice = ProductService.getProductCostPrice(Integer.parseInt(productId));
        if (Integer.parseInt(sellingPrice) < costPrice) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"status\":\"error\"}");
            return;
        }

        if (!(productName.equals("") || sellingPrice.equals("") || description.equals("") || (radio_choiceCategory == null || radio_choiceCategory.equals("")))) {
//            Case 1 : Pick category avalable.
            if (radio_choiceCategory != null) {
                String categoryId = null;
                if (radio_choiceCategory.equals("choiceAvailableCategory")) {
                    //Danh mục có sẵn
                    categoryId = availableCategory;
                    try {
                        if (discountId.equals(""))
                            ProductService.getInstance().editProduct(productId, productName, description, Integer.parseInt(sellingPrice), categoryId, isSale);
                        else
                            ProductService.getInstance().editProduct(productId, productName, description, Integer.parseInt(sellingPrice), categoryId, discountId, isSale);
                        req.setAttribute("result", "Đã thành công thay đổi thông tin sản phẩm.");
                    } catch (NullPointerException e) {
                        resp.getWriter().write("{\"status\":\"error\"}");
                        return;
                    }
                } else if (radio_choiceCategory.equals("choiceNewCategory")) {
                    //create new category in table
                    categoryId = CategoryService.getInstance().createNewCategory(newCategory) + "";
                    try {
                        if (discountId.equals(""))
                            ProductService.getInstance().editProduct(productId, productName, description, Integer.parseInt(sellingPrice), categoryId, isSale);
                        else
                            ProductService.getInstance().editProduct(productId, productName, description, Integer.parseInt(sellingPrice), categoryId, discountId, isSale);
                        req.setAttribute("result", "Đã thành công thay đổi thông tin sản phẩm.");
                    } catch (NullPointerException e) {
                        CategoryService.getInstance().deleteNoUsedCategoryById(categoryId);
                        resp.getWriter().write("{\"status\":\"error\"}");
                        return;
                    }
                }
            }
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"status\":\"success\"}");
        }



    }


}
