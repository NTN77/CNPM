package controller.admin;

import com.google.gson.JsonObject;
import model.bean.OrderImage;
import model.service.OrderService;
import org.h2.util.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/getOrderDetail")
public class OrderCustomDetailController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        OrderImage order = OrderService.getInstance().getOrderCustomById(id);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject json = new JsonObject();
        json.addProperty("imagePath", req.getContextPath() + "/" + order.getImagePath());
        json.addProperty("recieveDate", order.getRecieveDate().toString());
        json.addProperty("address", order.getAddress());
        json.addProperty("otherCustom", order.getOtherCustom());
        json.addProperty("tel", order.getTel());
        json.addProperty("note", order.getNote());

        resp.getWriter().write(json.toString());

//        System.out.println("Lấy chi tiết đơn hàng ID = " + id);
//        System.out.println("Path ảnh = " + order.getImagePath());
    }
}
