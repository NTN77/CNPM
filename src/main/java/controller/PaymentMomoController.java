package controller;

import model.bean.User;
import org.json.JSONObject;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet(name = "Payment Controller" , value =  "/payment-momo")
public class PaymentMomoController extends HttpServlet {
    private static final String endpoint = "https://test-payment.momo.vn/v2/gateway/api/create";
    private static final String partnerCode = "MOMO";
    private static final String accessKey = "F8BBA842ECF85";
    private static final String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private static final String redirectUrl = "http://localhost:8080/HandMadeStore/return";
    private static final String ipnUrl = "http://localhost:8080/HandMadeStore/momo-ipn";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("auth");
        String orderId = UUID.randomUUID().toString();
        String requestId = UUID.randomUUID().toString();


        String amount = req.getParameter("totalAmount");
        String address = req.getParameter("address");
        String phoneNumber = req.getParameter("phoneNumber");
        String receiver = req.getParameter("username");
        String ship = req.getParameter("ship");

        System.out.println("amoumt: " + amount);
        String orderInfo = "Thanh toán đơn hàng " + orderId;
        String requestType = "captureWallet";

//        Save other infor
        HttpSession sessionForPayment = req.getSession();
        sessionForPayment.setAttribute("address", address);
        sessionForPayment.setAttribute("phone", phoneNumber);
        sessionForPayment.setAttribute("receiver", receiver);
        sessionForPayment.setAttribute("totalPay", amount);
        sessionForPayment.setAttribute("ship", ship);

        // Tạo raw signature
        String rawHash = "accessKey=" + accessKey +
                "&amount=" + amount +
                "&extraData=" +
                "&ipnUrl=" + ipnUrl +
                "&orderId=" + orderId +
                "&orderInfo=" + orderInfo +
                "&partnerCode=" + partnerCode +
                "&redirectUrl=" + redirectUrl +
                "&requestId=" + requestId +
                "&requestType=" + requestType;

        String signature = hmacSHA256(rawHash, secretKey);

        // Tạo JSON request
        String jsonRequest = "{"
                + "\"partnerCode\":\"" + partnerCode + "\","
                + "\"accessKey\":\"" + accessKey + "\","
                + "\"requestId\":\"" + requestId + "\","
                + "\"amount\":\"" + amount + "\","
                + "\"orderId\":\"" + orderId + "\","
                + "\"orderInfo\":\"" + orderInfo + "\","
                + "\"redirectUrl\":\"" + redirectUrl + "\","
                + "\"ipnUrl\":\"" + ipnUrl + "\","
                + "\"extraData\":\"\","
                + "\"requestType\":\"" + requestType + "\","
                + "\"signature\":\"" + signature + "\"}";

        // Gửi request tới MoMo
        String momoResponse = sendHttpRequest(endpoint, jsonRequest);
        System.out.println("momoResponse :"+ momoResponse);

        // Lấy payUrl
        String payUrl = new JSONObject(momoResponse).getString("payUrl");
        System.out.println("payUrl: " +payUrl);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"payUrl\":\"" + payUrl + "\"}");


    }
    public String hmacSHA256(String data, String key) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(), "HmacSHA256");
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(secretKey);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo chữ ký", e);
        }
    }

    public String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    private String sendHttpRequest(String url, String json) throws IOException {
        try {
            System.out.println("Connecting to: " + url);
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            // Ghi dữ liệu
            OutputStream os = con.getOutputStream();
            os.write(json.getBytes(StandardCharsets.UTF_8));
            os.flush();
            os.close();

            // Kiểm tra response code
            int responseCode = con.getResponseCode();
            System.out.println("Response Code: " + responseCode);

            BufferedReader in;
            if (responseCode >= 200 && responseCode < 300) {
                in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {
                in = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }

            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            return response.toString();
        } catch (Exception e) {
            System.out.println("Error in sendHttpRequest: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}
