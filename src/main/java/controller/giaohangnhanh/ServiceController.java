package controller.giaohangnhanh;

import com.google.gson.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@WebServlet(value = "/service-api")
public class ServiceController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int districtCustomer = Integer.parseInt(req.getParameter("districtId"));
        String apiUrl = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/available-services";
        String token = "764f6d03-4121-11ef-8e53-0a00184fe694";

        try {
            URL url = new URL(apiUrl + "?from_district=1540&to_district=" + districtCustomer + "&shop_id=192867");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("token",token);
            conn.setRequestProperty("Content-Type", "application/json");


            // Get the response code
            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read the response body
                InputStream inputStream = conn.getInputStream();
                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                StringBuilder responseBuilder = new StringBuilder();
                String line;

                while ((line = reader.readLine()) != null) {
                    responseBuilder.append(line);
                }

                reader.close();

//                Parse Json từ response
                String jsonResponse = responseBuilder.toString();
                JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();

                // lấy dữ liệu tại field data.
                JsonArray dataArray = jsonObject.getAsJsonArray("data");

                List<ServiceShip> serviceShips = new ArrayList<>();

                for(JsonElement element : dataArray) {
                    JsonObject provinceJson = element.getAsJsonObject();

                    int serviceId = provinceJson.get("service_id").getAsInt();
                    int serviceType = provinceJson.get("service_type_id").getAsInt();
                    String serviceName = provinceJson.get("short_name").getAsString();

                    ServiceShip serviceShip = new ServiceShip(serviceId, serviceType,serviceName);

                    serviceShips.add(serviceShip);
                }

//
                req.setAttribute("service", serviceShips);
                req.getRequestDispatcher("/views/PaymentPage/payment.jsp");






                // Set content type and write JSON response to Servlet response
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                Gson gson = new Gson();
                String jsonResp = gson.toJson(serviceShips);
                resp.getWriter().write(jsonResp);
            } else {
                // Handle non-OK response
                resp.setStatus(responseCode);
                resp.getWriter().write("Failed to fetch data from API. Status code: " + responseCode);
            }

            conn.disconnect();

        } catch (Exception e) {
            // Handle exception
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Internal Server Error Occurred");
        }
    }
}
