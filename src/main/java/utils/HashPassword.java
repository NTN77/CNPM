package utils;

import com.mysql.cj.util.Base64Decoder;
import model.dao.UserDAO;

import java.security.MessageDigest;
import java.sql.SQLOutput;
import java.util.Base64;

public class HashPassword {
    //sha-1
    public static String toSHA1(String str) {



        // để làm cho mật khẩu trở nên phức tạp hơn nhiều lần
        /*
        Người ta có thể xây dựng 1 DB để lưu những ký tự - mã hóa ký tự để check ngươợc lại (so khớp)
         */

        String salt = "kaJsfIew3232@!ana;oxdkaife01928211";
        String result = null;

        str = str + salt;
        try {
            byte[] dataBytes = str.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            result = Base64.getEncoder().encodeToString(md.digest(dataBytes));
        } catch (Exception E) {
            E.printStackTrace();
        }
        return result;
    }
}