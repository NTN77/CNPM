package model.service.JavaMail;

import java.io.IOException;
import java.util.Properties;

public class MailProperties {
    private static Properties prop = new Properties();

    static {
        try {
            prop.load(MailProperties.class.getClassLoader().getResourceAsStream("mail.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static final String host = prop.getProperty("mail.smtp.host");
    public static final String port = prop.getProperty("mail.smtp.port");
    public static final String auth = prop.getProperty("mail.smtp.auth");
    public static final String ssl = prop.getProperty("mail.smtp.starttls.enable");
    public static final String username = prop.getProperty("mail.user");
    public static final String password = prop.getProperty("mail.pass");

}