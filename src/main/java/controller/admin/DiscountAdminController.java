package controller.admin;

import model.service.DiscountService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DiscountController", value = "/admin/discount")
public class DiscountAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        // Thêm KM
        String adddiscount = req.getParameter("submit_2_adddiscount");
        if (adddiscount != null) {
            String discountName = req.getParameter("discount_name");
            String percentageOff = req.getParameter("percentageOff");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");
            if (!(discountName.equals("") || percentageOff.equals("") || startDate.equals("") || endDate.equals(""))) {
                //insert discount
                DiscountService.getInstance().addDiscount(discountName, startDate, endDate, Double.parseDouble(percentageOff) / 100);
            } else {
                //Thông báo thiếu thông tin
                req.setAttribute("result", "Hãy điền đầy đủ thông tin để tạo khuyến mãi! Vui lòng thử lại");
            }
        }
        //Xóa discount bằng Id
        String deleteDiscountId = req.getParameter("deleteDiscountId");
        if (deleteDiscountId != null) {
            //Chuyển sang confirm
            req.setAttribute("title", "Xác nhận xóa khuyến mãi giảm giá");
            req.setAttribute("message", "Sau khi xóa khuyến mãi giảm giá này, các sản phẩm được áp dụng trước đó không còn giảm giá theo nữa");
            req.setAttribute("ok_link", "confirm?deleteDiscountId=" + deleteDiscountId + "&confirm=ok");
            req.setAttribute("cancel_link", "confirm?deleteDiscountId=" + deleteDiscountId + "&confirm=cancel");
            req.getRequestDispatcher("/views/Admin/confirm_box.jsp").forward(req, resp);
        }
        // Edit discount bằng Id
        req.removeAttribute("discountAction");
        req.removeAttribute("editDiscountId");
        req.removeAttribute("editStt");

        String discountAction = req.getParameter("discountAction");//edit
        if (discountAction != null) {
            String editDiscountId = req.getParameter("editDiscountId");//discountId
            String editStt = req.getParameter("editStt");
            //forward lại để hiện thị edit box
            req.setAttribute("discountAction", discountAction);
            req.setAttribute("editDiscountId", editDiscountId);
            req.setAttribute("editStt", editStt);
        }
        // Thêm KM
        String editdiscount = req.getParameter("submit_3_editdiscount");
        if (editdiscount != null) {
            String editDiscountId = req.getParameter("editDiscountId");
            String edit_discount_name = req.getParameter("edit_discount_name");
            String edit_percentageOff = req.getParameter("edit_percentageOff");
            String edit_startDate = req.getParameter("edit_startDate");
            String edit_endDate = req.getParameter("edit_endDate");
            if (!(edit_discount_name.equals("") || edit_percentageOff.equals("") || edit_startDate.equals("") || edit_endDate.equals(""))) {
                //edit discount
                DiscountService.getInstance().updateDiscount(editDiscountId, edit_discount_name, edit_startDate, edit_endDate, Double.parseDouble(edit_percentageOff) / 100);
                System.out.println("completed update");
            } else {
                //Thông báo thiếu thông tin
                req.setAttribute("result", "Hãy điền đầy đủ thông tin để thay đồi thông tin khuyến mãi! Vui lòng thử lại");
                System.out.println("fall update");
            }
        }


        req.getRequestDispatcher("/views/Admin/discount_management.jsp").forward(req, resp);
    }
}
