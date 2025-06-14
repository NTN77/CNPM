package controller.ajax_handle;

import model.service.ImageService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/image-ajax-handle")
public class ImageAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String imageId = req.getParameter("imageId");
        if (action != null && imageId != null) {
            if (action.equals("deleteImage")) {
                String imagePath = ImageService.pathImageOnly(Integer.parseInt(imageId));
                ImageService.deleteImageInServer(getServletContext(), imagePath);
                ImageService.deleteImageById(imageId);
                resp.getWriter().write(imageId);
            }
        }
    }
}
