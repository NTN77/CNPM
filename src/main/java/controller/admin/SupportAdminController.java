package controller.admin;

import model.service.JavaMail.MailService;
import model.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SupportAdminController", value = "/admin/support")
public class SupportAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        String adminEmail = "handmadestore@gmail.com";

        String userId = req.getParameter("userId");
        String problemTitle = req.getParameter("problemTitle");
        String desc = req.getParameter("desc");

        if (!(userId == null || problemTitle.equals("") || desc.equals(""))) {
            MailService.sendAdminProblem(adminEmail, UserService.getInstance().getUserById(userId), problemTitle, desc);
            req.setAttribute("result", "Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi, chúng tôi sẽ sớm liên lạc lại với bạn!");
        } else {
            req.setAttribute("result", "Vui lòng cung cấp đúng dữ liệu và thử lại");
        }

        req.getRequestDispatcher("/views/Admin/support.jsp").forward(req, resp);
    }
}
