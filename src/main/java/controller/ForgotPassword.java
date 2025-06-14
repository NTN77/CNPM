package controller;

import model.bean.User;
import model.dao.UserDAO;
import model.service.JavaMail.MailService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ForgotPassword", value = "/forgotpassword")
public class ForgotPassword extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        String page = req.getParameter("page");
        if (page == null) {
            User sessionUser = (User) req.getSession().getAttribute("auth");
            if (sessionUser != null) {
                String code = MailService.sendCode(sessionUser.getEmail());
                req.getSession().setAttribute("code", code);
                req.getSession().setAttribute("email", sessionUser.getEmail());
                //gởi email
                resp.sendRedirect(req.getContextPath() + "/forgotpassword?page=2&email=" + sessionUser.getEmail());
            } else
                req.getRequestDispatcher("views/Login/view_login/forgotpassword.jsp").forward(req, resp);
        } else {
            if (page.equals("1")) {
                String email = req.getParameter("email");
                if (email == null) {
                    req.getRequestDispatcher("views/Login/view_login/forgotpassword.jsp").forward(req, resp);
                } else {
                    User user = UserDAO.getUserByEmail(email);
                    if (user != null) {
                        String code = MailService.sendCode(email);
                        req.getSession().setAttribute("code", code);
                        req.getSession().setAttribute("email", email);
                        //gởi email
                        resp.sendRedirect(req.getContextPath() + "/forgotpassword?page=2&email=" + email);
                    } else {
                        req.setAttribute("result", "Email không tồn tại trong hệ thống");
                        req.getRequestDispatcher("views/Login/view_login/forgotpassword.jsp").forward(req, resp);
                    }
                }
            } else if (page.equals("2")) {
                String code_input = req.getParameter("code_input");
                String email = (String) req.getSession().getAttribute("email");
                String code = (String) req.getSession().getAttribute("code");
                if (code_input == null) {
                    req.getRequestDispatcher("views/Login/view_login/forgotpw_code.jsp?email=" + email).forward(req, resp);
                } else {
                    if (email != null && code.equals(code_input)) {
                        req.getSession().setAttribute("isFromPage2", "true");
                        req.getSession().removeAttribute("code");
                        resp.sendRedirect(req.getContextPath() + "/forgotpassword?page=3&email=" + email);
                    } else if ((email != null && !code.equals(code_input))) {
                        req.setAttribute("result", "Mã không chính xác");
                        req.getRequestDispatcher("views/Login/view_login/forgotpw_code.jsp?email=" + email).forward(req, resp);
                    } else
                        resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/forgotpassword.jsp");
                }
            } else if (page.equals("3")) {
                String isFromPage2 = (String) req.getSession().getAttribute("isFromPage2");
                if (isFromPage2 != null && isFromPage2.equals("true")) {
                    String email = (String) req.getSession().getAttribute("email");
                    String new_pw = req.getParameter("new_pw");
                    String confirm_new_pw = req.getParameter("confirm_new_pw");
                    if (new_pw == null && confirm_new_pw == null) {
                        req.getRequestDispatcher("views/Login/view_login/resetpw.jsp?email=" + email).forward(req, resp);
                    } else {
                        if (Validation.checkPassword(new_pw)) {
                            if (new_pw.equals(confirm_new_pw)) {
                                //update password
                                UserDAO.setPasswordByEmail(email, HashPassword.toSHA1(new_pw));
                                System.out.println("đã update " + email + " - " + new_pw);
                                req.getSession().removeAttribute("email");
                                req.getSession().removeAttribute("isFromPage2");
                                resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/login.jsp");
                            } else {
                                req.setAttribute("result", "Mật khẩu xác nhận không khớp. Vui lòng thử lại");
                                req.setAttribute("new_pw", null);
                                req.setAttribute("confirm_new_pw", null);
                                req.getRequestDispatcher("views/Login/view_login/resetpw.jsp?email=" + email).forward(req, resp);
                            }
                        } else {
                            req.setAttribute("result", "Mật khẩu phải ít nhất 8 ký tự đặc biệt, có ít nhất 1 ký tự in hoa và ký tự đặc biệt");
                            req.setAttribute("new_pw", null);
                            req.setAttribute("confirm_new_pw", null);
                            req.getRequestDispatcher("views/Login/view_login/resetpw.jsp?email=" + email).forward(req, resp);
                        }
                    }
                } else
                    resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/forgotpassword.jsp");
            }
        }
    }
}

