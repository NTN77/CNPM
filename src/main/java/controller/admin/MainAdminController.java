package controller.admin;

import model.bean.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminController", value = "/admin")
public class MainAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        User admin = (User) req.getSession().getAttribute("auth");
        boolean isAdmin = ((req.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) req.getSession().getAttribute("isAdmin")));
        if (admin != null && isAdmin) {
            String func = req.getParameter("func");
            String framePath = "views/Admin/admin.jsp";
            if (func != null) {
                switch (func) {
                    case "dashboard":
//                        framePath = "/views/Admin/reference_statistics.jsp";
                        framePath = "/views/Admin/dashboard.jsp";
                        break;
                    case "inventory_management":
                        framePath = "/views/Admin/inventory_management.jsp";
                        break;
                    case "add_product":
                        framePath = "/views/Admin/add_product.jsp";
                        break;
                    case "discount_management":
                        framePath = "/views/Admin/discount_management.jsp";
                        break;
                    case "category_management":
                        framePath = "/views/Admin/category_management.jsp";
                        break;
                    case "order_management":
                        framePath = "/views/Admin/order_management.jsp";
                        break;
                    case "customer_management":
                        framePath = "/views/Admin/customer_management.jsp";
                        break;
                    case "banners_tips":
                        framePath = "/views/Admin/banners_tips.jsp";
                        break;
                    case "logs":
                        framePath = "/views/Admin/logging_management.jsp";
                        break;

                    case "support":
                        framePath = "/views/Admin/support.jsp";
                        break;
                    case "order_custom_management":
                        framePath = "/views/Admin/order_custom_management.jsp";
                        break;
                    case "preorder_management":
                        framePath = "/views/Admin/preorder-management.jsp";
                        break;
                    default:
                        framePath = "/views/Admin/reference_statistics.jsp";
                        break;
                }
                req.setAttribute("framePath", framePath);
                req.setAttribute("func", func);
            }
            req.getRequestDispatcher("views/Admin/admin.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("login");
        }
    }
}
