package controller;

import logs.EAction;
import logs.ELevel;
import logs.LoggingService;
import model.bean.Cart;
import model.bean.User;
import model.dao.UserDAO;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/login")
public class login extends HttpServlet {
    private static final int WRONG_PASS_MAX = 5;
    private static final int LOCK_TIME = 10 * 60 * 1000; // 10 minutes in milliseconds

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        req.removeAttribute("auth");

        req.getSession().removeAttribute("isAdmin");
        String email = req.getParameter("email");
        String pw = req.getParameter("password");
        pw = HashPassword.toSHA1(pw);
        Cart cart = new Cart();
        User checkEmail = UserDAO.getUserByEmail(email);
        User user = UserService.getInstance().checkLogin(email, pw);

        if (email == null) {
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        } else if (checkEmail == null) {
            req.setAttribute("errEmail", "Email không tồn tại!");
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        } else {
            HttpSession session = req.getSession();
            Map<String, Integer> wrongPassCounterMap = (Map<String, Integer>) session.getAttribute("wrongPassCounterMap");
            Map<String, Long> firstFailedTimeMap = (Map<String, Long>) session.getAttribute("firstFailedTimeMap");

            if (wrongPassCounterMap == null) {
                wrongPassCounterMap = new HashMap<>();
                session.setAttribute("wrongPassCounterMap", wrongPassCounterMap);
            }

            if (firstFailedTimeMap == null) {
                firstFailedTimeMap = new HashMap<>();
                session.setAttribute("firstFailedTimeMap", firstFailedTimeMap);
            }

            int wrongPassCounter = wrongPassCounterMap.getOrDefault(email, 0);
            long firstFailedTime = firstFailedTimeMap.getOrDefault(email, System.currentTimeMillis());

            long currentTime = System.currentTimeMillis();

            if (currentTime - firstFailedTime > LOCK_TIME) {
                // Reset counter and time after 10 minutes
                wrongPassCounter = 0;
                firstFailedTime = currentTime;
            }

            if (wrongPassCounter >= WRONG_PASS_MAX) {
                if (currentTime - firstFailedTime <= LOCK_TIME) {
                    String clientIP = req.getRemoteAddr();
                    String[] clientLocation = LoggingService.getLocation(clientIP);
                    if (wrongPassCounter == 5)
                        LoggingService.getInstance().log(ELevel.ALERT, EAction.LOGIN, clientIP, clientLocation[0], clientLocation[1], clientLocation[2], email + ": Nhập sai mật khẩu quá 5 lần");
                    req.setAttribute("result", "Bạn đã nhập sai mật khẩu quá 5 lần. Vui lòng thử lại sau 10 phút.");
                    req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
                    return;
                } else {
                    // Reset after lock time passed
                    wrongPassCounter = 0;
                    firstFailedTime = currentTime;
                }
            }

            if (user != null) {
                if (user.isLock()) {
                    req.setAttribute("result", "Tài khoản đã bị vô hiệu hóa!");
                    req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
                } else {
                    session.setAttribute("auth", user);
                    wrongPassCounterMap.remove(email);
                    firstFailedTimeMap.remove(email);
                    session.removeAttribute("wrongPassCounterMap");
                    session.removeAttribute("firstFailedTimeMap");

                    String clientIP = req.getRemoteAddr();
                    System.out.println(req.getLocalAddr() + " - " + clientIP);
                    String[] clientLocation = LoggingService.getLocation(clientIP);

                    if (!clientLocation[2].equals("Không tìm thấy") && !clientLocation[2].equals("Vietnam"))
                        LoggingService.getInstance().log(ELevel.ALERT, EAction.LOGIN, clientIP, clientLocation[0], clientLocation[1], clientLocation[2], email + ": Đăng nhập từ nước ngoài");

                    if (user.isOwn() || user.isAdmin()) {
                        session.setAttribute("isAdmin", true);
                        resp.sendRedirect(req.getContextPath() + "/views/Admin/admin.jsp");
                    } else {
                        session.setAttribute("isAdmin", false);
                        resp.sendRedirect(req.getContextPath() + "/views/MainPage/view_mainpage/mainpage.jsp");
                    }
                }
            } else {
                wrongPassCounter++;
                wrongPassCounterMap.put(email, wrongPassCounter);
                firstFailedTimeMap.put(email, firstFailedTime);
                session.setAttribute("wrongPassCounterMap", wrongPassCounterMap);
                session.setAttribute("firstFailedTimeMap", firstFailedTimeMap);

                req.setAttribute("result", "Mật khẩu không chính xác!");
                req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
            }
        }
    }
}
