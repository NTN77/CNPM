package controller.admin;

import model.adapter.RateRequest;
import model.service.RateService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/exportRateCSV")
public class ExportRateCSV extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<RateRequest> rates = RateService.getInstance().getAll();

        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"QuanLyDanhGia.csv\"");
        resp.setCharacterEncoding("UTF-8");

        OutputStream out = resp.getOutputStream();
        out.write(0xEF);
        out.write(0xBB);
        out.write(0xBF);

        PrintWriter writer = new PrintWriter(new OutputStreamWriter(out, "UTF-8"));
        writer.println("Tên sản phẩm,Bình luận,Thái độ");

        for (RateRequest r : rates) {
            if (r != null) {
                writer.printf("\"%s\",\"%s\",\"%s\"\n",
                        r.getName(),
                        r.getComment(),
                        r.getSentiment());
            }
        }
        writer.flush();
        writer.close();
    }
}
