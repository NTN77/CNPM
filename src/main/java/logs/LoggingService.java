package logs;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import io.ipinfo.api.IPinfo;
import io.ipinfo.api.model.IPResponse;
import model.service.JavaMail.MailService;

import java.io.*;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class LoggingService {
    private List<Log> logs;
    private int logIdCounter;
    private static final String LOG_FILE_PATH = "logs.json";
    private final Gson gson;
    private static LoggingService instance;

    public static synchronized LoggingService getInstance() {
        if (instance == null) instance = new LoggingService();
        return instance;
    }

    private LoggingService() {
        this.gson = new GsonBuilder().setPrettyPrinting().create();
        this.logs = readLogsFromFile() == null ? new ArrayList<>() : readLogsFromFile();
        this.logIdCounter = calculateNextLogId();
    }

    public synchronized void log(ELevel level, EAction action, String ipAddress, String city, String region, String countryName, String message) {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
        String currentTime = sdf.format(timestamp);
        Log newLog = new Log(logIdCounter++, currentTime, ipAddress, city, region, countryName, level, action, message);
        if (appendLogToFile(newLog)) {
            logs.add(newLog);
            // Gửi mail
            if (newLog.isDANGERLevel())
                MailService.sendAdminDANGERLog("lungbaphe772003@gmail.com", newLog);
        }
    }

    public synchronized void log(ELevel level, EAction action, String ipAddress, String message) {
        String[] location = LoggingService.getLocation(ipAddress);
        log(level, action, ipAddress, location[0], location[1], location[2], message);
    }

    private boolean writeLogsToFile() {
        try (Writer writer = new OutputStreamWriter(new FileOutputStream(LOG_FILE_PATH), StandardCharsets.UTF_8)) {
            gson.toJson(logs, writer);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean appendLogToFile(Log log) {
        try (RandomAccessFile file = new RandomAccessFile(LOG_FILE_PATH, "rw")) {
            long fileLength = file.length();
            if (fileLength == 0) {
                file.write("[\n".getBytes(StandardCharsets.UTF_8));
            } else {
                file.seek(fileLength - 2); // Move to the position before the last closing bracket
                file.write(",\n".getBytes(StandardCharsets.UTF_8));
            }
            String jsonLog = gson.toJson(log);
            file.write((jsonLog + "\n]").getBytes(StandardCharsets.UTF_8));
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<Log> readLogsFromFile() {
        try (Reader reader = new InputStreamReader(new FileInputStream(LOG_FILE_PATH), StandardCharsets.UTF_8);
             BufferedReader bufferedReader = new BufferedReader(reader)) {
            Type logListType = new TypeToken<ArrayList<Log>>() {
            }.getType();
            return gson.fromJson(bufferedReader, logListType);
        } catch (IOException e) {
            return new ArrayList<>();
        }
    }

    private int calculateNextLogId() {
        int maxId = 0;
        for (Log log : logs) {
            if (log.getId() > maxId) {
                maxId = log.getId();
            }
        }
        return maxId + 1;
    }

    public synchronized List<Log> getLogs() {
        return new ArrayList<>(logs);
    }

    public synchronized List<Log> getThreeLogs() {
        int size = logs.size();
        return size > 0 ? logs.subList(Math.max(size - 3, 0), size) : new ArrayList<>();
    }

    public synchronized String getAbsolutePath() {
        return new File(LOG_FILE_PATH).getAbsolutePath();
    }

    public synchronized Log getLogById(int id) {
        for (Log log : logs) {
            if (log.getId() == id) {
                return log;
            }
        }
        return null;
    }

    public synchronized void deleteAlertInformLogById(int logId) {
        if (logs.removeIf(log -> log.getId() == logId && (log.getLevel() == ELevel.ALERT || log.getLevel() == ELevel.INFORM))) {
            writeLogsToFile();
        }
    }

    public synchronized void deleteAlertLogs() {
        logs.removeIf(log -> log.getLevel() == ELevel.ALERT);
        writeLogsToFile();
    }

    public synchronized void deleteInformLogs() {
        logs.removeIf(log -> log.getLevel() == ELevel.INFORM);
        writeLogsToFile();
    }

    public static String[] getLocation(String ipAddress) {
        IPinfo ipInfo = new IPinfo.Builder().setToken("c354a4c7f892c2").build();
        try {
            IPResponse response = ipInfo.lookupIP(ipAddress);
            return new String[]{response.getCity() == null ? "Không tìm thấy" : response.getCity(),
                    response.getRegion() == null ? "Không tìm thấy" : response.getRegion(),
                    response.getCountryName() == null ? "Không tìm thấy" : response.getCountryName()};
        } catch (Exception ex) {
            ex.printStackTrace();
            return new String[]{"Không tìm thấy", "Không tìm thấy", "Không tìm thấy"};
        }
    }
}
