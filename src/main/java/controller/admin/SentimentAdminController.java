package controller.admin;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import model.adapter.RateDetailRequest;
import model.bean.OrderImage;
import model.service.OrderService;
import model.service.RateService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(value = "/admin/sentimentDetail")
public class SentimentAdminController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        List<RateDetailRequest> rqList = RateService.getInstance().getById(id);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonArray jsonArray = new JsonArray();

        for (RateDetailRequest rq : rqList) {
            JsonObject json = new JsonObject();
            json.addProperty("idProduct", rq.getProductId());
            json.addProperty("productName", rq.getProductName());
            json.addProperty("userName", rq.getUserName());
            json.addProperty("createDate", rq.getCreateDate().toString());
            json.addProperty("comment", rq.getComment());
            jsonArray.add(json);
        }

        resp.getWriter().write(jsonArray.toString());

    }
}