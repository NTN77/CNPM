package logs;

public class LogUnitTest {
    public static void main(String[] args) {
        LoggingService loggingService = LoggingService.getInstance();
        loggingService.log(ELevel.INFORM, EAction.LOGIN, "192.168.1.1", "TH HCM", "TPHCM", "VN", "Nhập mật khẩu quá 5 lần");
//        loggingService.log(ELevel.WARNING, EAction.UPDATE, "192.168.1.2", "TH HCM", "TPHCM", "VN", "User updated profile with invalid data");
//        loggingService.log(ELevel.ALERT, EAction.DELETE, "192.168.1.99", "TH HCM", "TPHCM", "VN", "User attempted to delete admin account");
    }
}
