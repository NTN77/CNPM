package logs;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/log")
public class LogController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action != null) {
            if (action.equals("removeLog")) {
                String id = req.getParameter("id");
                LoggingService.getInstance().deleteAlertInformLogById(Integer.parseInt(id));
            } else if (action.equals("clearInformLogs")) {
                LoggingService.getInstance().deleteInformLogs();
            } else if (action.equals("clearAlertLogs")) {
                LoggingService.getInstance().deleteAlertLogs();
            } else if (action.equals("getAllLogs")) {
                List<Log> logs = LoggingService.getInstance().getThreeLogs();
                Gson gson = new Gson();
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = gson.toJson(logs);
                resp.getWriter().write(jsonResponse);
            }
        }
    }
}
