package controller.ajax_handle;

import com.google.gson.Gson;
import io.leangen.geantyref.TypeToken;
import model.bean.Rate;
import model.bean.RateNew;
import model.bean.User;
import model.service.ProductService;
import model.service.RateNewService;
import model.service.UserService;
import okhttp3.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/rate-ajax-handle")
public class RateAjaxHandle extends HttpServlet {

    private static final String URL_SETIMENT = "https://dc8b-34-169-242-27.ngrok-free.app/analyze";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productId = req.getParameter("productId");
        User sessionUser = (User) req.getSession().getAttribute("auth");
        if (action != null && productId != null) {
            if (action.equals("filterStar")) {
                String starNumber = req.getParameter("starNumber");
                try {
                    int p = Integer.parseInt(productId);
                    int s = Integer.parseInt(starNumber);
                    Integer u = sessionUser != null ? sessionUser.getId() : null;
                    List<Rate> rates = (s != 0) ? ProductService.getInstance().getRatesByStarNumber(p, s, u) : ProductService.getInstance().getRateForProduct(p);
                    List<RateResponse> rateResponses = new ArrayList<>();
                    String name = "";
                    for (Rate rate : rates) {
                        name = UserService.getInstance().getNameById(rate.getUserId());
                        rateResponses.add(new RateResponse(rate.getProductId(),rate.getUserId(), name, rate.getStarRatings(), rate.getComment(), rate.getCreateDate(), rate.getChangeNumber()));
                    }
                    Gson gson = new Gson();
                    String jsonRatesResponse = gson.toJson(rateResponses);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(jsonRatesResponse);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (action.equals("addRating")) {
                String ratingValue = req.getParameter("ratingValue");
                String comment = req.getParameter("comment");
                //insert
                int p = Integer.parseInt(productId);
                int s = Integer.parseInt(ratingValue);
                int u = sessionUser != null ? sessionUser.getId() : null;
                OkHttpClient client = new OkHttpClient();
                Map<String, String> data = new HashMap<>();
                data.put("text", comment);
                Gson gson = new Gson();
                String json = gson.toJson(data);

                RequestBody body = RequestBody.create(
                        json, MediaType.parse("application/json"));
                Request request = new Request.Builder().url(URL_SETIMENT).post(body).build();

                try (Response response = client.newCall(request).execute()) {
                    if (response.isSuccessful() && response.body() != null) {
                        String responseBody = response.body().string();
                        Type type = new TypeToken<Map<String, Object>>(){}.getType();
                        Map<String, Object> result = gson.fromJson(responseBody, type);
                        String sentiment = (String) result.get("sentiment");
                        ProductService.getInstance().changeRate(p, u, s, comment, sentiment);
                        List<Rate> rates = ProductService.getInstance().getRatesFirstUser(p, u);
                        List<RateResponse> rateResponses = new ArrayList<>();
                        String name = "";
                        for (Rate rate : rates) {
                            name = UserService.getInstance().getNameById(rate.getUserId());
                            rateResponses.add(new RateResponse(rate.getProductId(), rate.getUserId(),name, rate.getStarRatings(), rate.getComment(), rate.getCreateDate(), rate.getChangeNumber()));
                        }
                        String jsonRatesResponse = gson.toJson(rateResponses);
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        System.out.println(jsonRatesResponse);
                        resp.getWriter().write(jsonRatesResponse);
                    } else {
                        System.err.println("Lỗi khi gọi API: " + response.code());
                        resp.getWriter().write("error server");
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    resp.getWriter().write("error server");
                }

            }
        }
    }
}
