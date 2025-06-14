package controller;

import model.bean.User;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


@WebServlet(name = "Register" , value = "/login.jsp")
public class SignUp extends HttpServlet {


    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uname = req.getParameter("name");
        String utel = req.getParameter("tel");
        String upass = req.getParameter("pass");
        String uverify = req.getParameter("verify");
        String uemail = req.getParameter("email");



        Map<String, String> errors = new HashMap<>();

        validateRequireField("name", uname,"Tên hiển thị", errors);
        validateRequireField("tel", utel,"Số điện thoại", errors);
        validateRequireField("pass", upass, "Mật khẩu", errors);
        validateRequireField("verify", uverify, "Xác thực", errors);
        validateRequireField("email", uemail, "Email", errors);

        User usByEmail = UserService.getInstance().checkEmail(uemail);


        if(!errors.isEmpty() ) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("views/Login/view_login/signup.jsp").forward(req, resp);
        }

        else    if(usByEmail != null ) {
            req.setAttribute("erDuplicateEmail", "Email đã được sử dụng!");
            req.getRequestDispatcher("views/Login/view_login/signup.jsp").forward(req,  resp);
        }
        else if( utel.length() != 10 || Integer.parseInt(utel) < 200000000 || Integer.parseInt(utel) > 999000000) {
            req.setAttribute("erPhoneExist", "Số điện thoại không hợp lệ!");
            req.getRequestDispatcher("views/Login/view_login/signup.jsp").forward(req,  resp);
        }
        else   if(UserService.getInstance().isPhoneNumberExist(utel) == true) {
            req.setAttribute("erPhoneExist", "Số điện thoại đã được sử dụng!");
            req.getRequestDispatcher("views/Login/view_login/signup.jsp").forward(req,  resp);
        }
        else if (!upass.equals(uverify)) {
            req.setAttribute("errorVerify", "Lỗi xác thực mật khẩu không đúng!");
            req.getRequestDispatcher("views/Login/view_login/signup.jsp").forward(req, resp);

        }

        else {
            User user = new User();
            user.setName(uname);
            user.setEmail(uemail);
            upass = HashPassword.toSHA1(upass);
            user.setPassword(upass);
            user.setPhoneNumber(utel);
            UserService.getInstance().insertUser(user);
            resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/login.jsp");
        }
    }

    public static void validateRequireField(String fieldName, String value, String viewName, Map<String, String> errors) {
        if (value == null || value.trim().isEmpty()) {
            errors.put(fieldName, viewName + " không được bỏ trống");
        }
    }


}