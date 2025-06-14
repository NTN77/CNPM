package logs;

public class Log {
    private int id;
    private String formattedCreatedTime;
    private String ipAddress;
    private String city;
    private String region;
    private String countryName;
    private ELevel level;
    private EAction action;
    private String message;

    public Log(int id, String formattedCreatedTime, String ipAddress, String city, String region, String countryName, ELevel level, EAction action, String message) {
        this.id = id;
        this.formattedCreatedTime = formattedCreatedTime;
        this.ipAddress = ipAddress;
        this.city = city;
        this.region = region;
        this.countryName = countryName;
        this.level = level;
        this.action = action;
        this.message = message;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFormattedCreatedTime() {
        return formattedCreatedTime;
    }

    public void setFormattedCreatedTime(String formattedCreatedTime) {
        this.formattedCreatedTime = formattedCreatedTime;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public ELevel getLevel() {
        return level;
    }

    public void setLevel(ELevel level) {
        this.level = level;
    }

    public EAction getAction() {
        return action;
    }

    public void setAction(EAction action) {
        this.action = action;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isINFORMLevel() {
        return level == ELevel.INFORM;
    }

    public boolean isALERTLevel() {
        return level == ELevel.ALERT;
    }

    public boolean isWARNINGLevel() {
        return level == ELevel.WARNING;
    }

    public boolean isDANGERLevel() {
        return level == ELevel.DANGER;
    }

    public String asNameForAction() {
        return (action == EAction.LOGIN) ? "Vấn đề đăng nhập" : "Thay đổi hệ thống";
    }

}
