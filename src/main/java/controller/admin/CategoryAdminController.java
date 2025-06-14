package controller.admin;

import model.service.CategoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CategoryAdminController", value = "/admin/category")
public class CategoryAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        String currentEditCategoryId = req.getParameter("currentEditCategoryId");
        String deleteCategoryId = req.getParameter("deleteCategoryId");

        if (currentEditCategoryId != null) {
            String categoryName = req.getParameter(currentEditCategoryId);
            //update
            CategoryService.getInstance().editCategoryNameById(currentEditCategoryId, categoryName);
        } else if (deleteCategoryId != null) {
            //delete
            CategoryService.getInstance().deleteNoUsedCategoryById(deleteCategoryId);
        }

        req.getRequestDispatcher("/views/Admin/category_management.jsp").forward(req, resp);
    }
}
