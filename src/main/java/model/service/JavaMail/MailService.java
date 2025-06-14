package model.service.JavaMail;

import logs.Log;
import model.bean.Order;
import model.bean.OrderImage;
import model.bean.User;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.Random;

public class MailService {
    public boolean send(String to, String subject, String messageContent) {
        try {
            // Get properties object
            Properties props = new Properties();
            props.put("mail.smtp.auth", MailProperties.auth);
            props.put("mail.smtp.starttls.enable", MailProperties.ssl);
            props.put("mail.smtp.host", MailProperties.host);
            props.put("mail.smtp.port", MailProperties.port);

            // get Session
            Session session = Session.getInstance(props,
                    new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(MailProperties.username, MailProperties.password);
                        }
                    });

            // compose message
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(MailProperties.username, "Hand Made Store"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
//            Vì bold bằng html nên thay vì setText thì setsetContent bên dưới
//            message.setText(messageContent);
            // Thiết lập nội dung là HTML
            message.setContent(messageContent, "text/html; charset=utf-8");
            // send message
            Transport.send(message);
            return true;
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    public static String getRandomCode(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            sb.append(characters.charAt(index));
        }
        return sb.toString();
    }

    public static String sendCode(String to) {
        String code = getRandomCode(5);
        MailService emailService = new MailService();
        emailService.send(to, "Xác thực email", "Chào bạn,<br> Đây là mã xác thực từ Handmadestore, vui lòng không cung cấp mã xác thực cho người khác và chỉ có giá trị sử dụng cho 1 lần: " +
                "<br> <strong>" + code + "</strong>");

        return code;
    }

    public static void sendNotifyCanceledOrder(String to, Order order, String canceledReason) {
        System.out.println("final check: " + canceledReason);
        MailService emailService = new MailService();
        emailService.send(to,
                "Thông báo hủy đơn hàng của bạn",
                "Chào bạn, chúng tôi hy vọng email này sẽ đến được với bạn." +
                        "<br> Chúng tôi rất tiếc phải thông báo với bạn rằng đơn hàng có mã <strong>" + " #" + order.getId() + " </strong>" + "đã bị hủy." +
                        ((canceledReason != null && !canceledReason.equals("")) ? "<br> Lý do hủy: <strong>" + canceledReason + " </strong>" : "") +
                        "<br> Vui lòng liên hệ với chúng tôi nếu bạn có thêm bất kỳ câu hỏi nào hoặc " +
                        "cần hỗ trợ tìm kiếm sản phẩm thay thế. " +
                        "Chúng tôi đánh giá cao sự hỗ trợ của bạn và mong được phục vụ bạn trong tương lai." +
                        "<br><strong>Handmadestore</strong>");
    }

    public static void sendNotifyCanceledOrder(String to, OrderImage order, String canceledReason) {
        System.out.println("final check: " + canceledReason);
        MailService emailService = new MailService();
        emailService.send(to,
                "Thông báo hủy đơn hàng của bạn",
                "Chào bạn, chúng tôi hy vọng email này sẽ đến được với bạn." +
                        "<br> Chúng tôi rất tiếc phải thông báo với bạn rằng đơn hàng có mã <strong>" + " #" + order.getId() + " </strong>" + "đã bị hủy." +
                        ((canceledReason != null && !canceledReason.equals("")) ? "<br> Lý do hủy: <strong>" + canceledReason + " </strong>" : "") +
                        "<br> Vui lòng liên hệ với chúng tôi nếu bạn có thêm bất kỳ câu hỏi nào hoặc " +
                        "cần hỗ trợ tìm kiếm sản phẩm thay thế. " +
                        "Chúng tôi đánh giá cao sự hỗ trợ của bạn và mong được phục vụ bạn trong tương lai." +
                        "<br><strong>Handmadestore</strong>");
    }

    public static void sendNotifyConfirmOrder(String to, Order order) {
        MailService emailService = new MailService();
        emailService.send(to,
                "Đơn hàng của bạn đã xác nhận",
                "Chào bạn, chúng tôi hy vọng email này sẽ đến được với bạn." +
                        "<br> Đơn hàng của bạn có mã <strong>" + " #" + order.getId() + " </strong>" + " đã xác nhận và sẽ được giao đến bạn sớm nhất." +
                        "<br> Cảm ơn bạn đã tin tưởng mua hàng tại Handmadestore. Nếu bạn có vấn đề hay thắc mắc nào liên quan, hãy liên hệ với chúng tôi qua email này." +
                        "<br><strong>Thân ái! Handmadestore</strong>");
    }

    public static void sendNotifyConfirmOrder(String to, OrderImage order) {
        MailService emailService = new MailService();
        emailService.send(to,
                "Đơn hàng của bạn đã xác nhận",
                "Chào bạn, chúng tôi hy vọng email này sẽ đến được với bạn." +
                        "<br> Đơn hàng của bạn có mã <strong>" + " #" + order.getId() + " </strong>" + " đã xác nhận và sẽ được hoàn thành và giao đến bạn sớm nhất." +
                        "<br> Cảm ơn bạn đã tin tưởng mua hàng tại Handmadestore. Nếu bạn có vấn đề hay thắc mắc nào liên quan, hãy liên hệ với chúng tôi qua email này." +
                        "<br><strong>Thân ái! Handmadestore</strong>");
    }

    public static void sendAdminProblem(String adminEmail, User user, String problemTitle, String desc) {
        MailService emailService = new MailService();
        emailService.send(adminEmail,
                "Khách hàng đang gặp vấn đề với website! ",
                "<br>Mã khách hàng: <strong>" + user.getId() + "</strong>" +
                        "<br> Email: <strong>" + user.getEmail() + "</strong>" +
                        "<br> Sđt: <strong>" + user.getPhoneNumber() + "</strong>" +
                        "<hr>" +
                        "Vấn đề: <strong>" + problemTitle + "</strong>" +
                        "Mô tả của khách hàng: " + desc);
    }

    public static void sendAdminDANGERLog(String adminEmail, Log log) {
        MailService emailService = new MailService();
//        String formattedCreatedTime, String ipAddress, String location, ELevel level, EAction action, String message
        emailService.send(adminEmail,
                "CẢNH BÁO Từ HỆ THỐNG website HandMadeStore! ",
                "<br>Hoạt động: <strong>" + log.asNameForAction() + "</strong>" +
                        "<br> Từ địa chỉ IP: <strong>" + log.getIpAddress() + "</strong>" +
                        "<br> Vị trí tương ứng: <strong>" + log.getCity() + ", " + log.getRegion() + ", " + log.getCountryName() + "</strong>" +
                        "<hr>" +
                        "Chi tiết: <p>" + log.getMessage() + "</p>");
    }

    public static void main(String[] args) {
        System.out.println(sendCode("lebatrong2003@gmail.com"));
    }
}