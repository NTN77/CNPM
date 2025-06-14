package controller;

import model.bean.User;
import model.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/changeUserInfo")
public class changeUserInfo extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        User user = (User) (req.getSession().getAttribute("auth"));
        if (user != null) {
            String action = req.getParameter("action");
            if (action != null) {
                if (action.equals("changeName")) {
                    String newName = req.getParameter("newName");
                    if (newName == null || newName.trim().equals(""))
                        resp.getWriter().write("Tên mới không khả dụng");
                    else {
                        UserService.getInstance().updateName(user.getId() + "", newName);
                        resp.getWriter().write("Tên gọi mới - " + newName + " đã cập nhật");
                        user = (User) UserService.getInstance().getUserById(user.getId() + "");
                        req.getSession().setAttribute("auth", user);
                    }
                } else if (action.equals("changePhone")) {
                    String newPhone = req.getParameter("newPhone");
                    if (newPhone != null) newPhone = newPhone.trim();
                    if (newPhone == null || newPhone.isEmpty() || newPhone.equals(user.getPhoneNumber()))
                        resp.getWriter().write("Số điện thoại không khả dụng");
                    else if (!Validation.checkPhoneNumber(newPhone)) {
                        System.out.println("validate phone" + newPhone + "- " + Validation.checkPhoneNumber(newPhone));
                        resp.getWriter().write("Số điện thoại không hợp lệ");
                    } else {
                        UserService.getInstance().updatePhoneNumber(user.getId() + "", newPhone);
                        resp.getWriter().write("Số điện thoại mới - " + newPhone + " đã cập nhật");

                        user = (User) UserService.getInstance().getUserById(user.getId() + "");
                        req.getSession().setAttribute("auth", user);
                    }
                }
            } else
                req.getRequestDispatcher("./views/Admin/changeUserInfo.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
