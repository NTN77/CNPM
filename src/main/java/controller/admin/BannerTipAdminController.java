package controller.admin;

import model.bean.BannerItem;
import model.bean.Tip;
import model.service.BannerService;
import model.service.ImageService;
import model.service.TipService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "BannerTipAdminController", value = "/admin/bannertip")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 100
)
public class BannerTipAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        //submit
        String submit_type = req.getParameter("submit_type");
        System.out.println("submit_type:" + submit_type);
        if (submit_type != null) {
            String oldTitle = null;
            String title = null;
            String description = null;
            String video_link = null;
            switch ((submit_type)) {
                case "show_banner":
                    String edit_banner_title = req.getParameter("edit_banner_title");
                    BannerItem currentBannerItem = BannerService.getInstance().getBannerItemByTitle(edit_banner_title);
                    req.setAttribute("currentBannerItem", currentBannerItem);
                    break;
                case "show_tip":
                    String edit_tip_title = req.getParameter("edit_tip_title");
                    Tip currentTip = TipService.getInstance().getTipByTitle(edit_tip_title);
                    req.setAttribute("currentTip", currentTip);
                    break;
                case "edit_tip":
                    oldTitle = req.getParameter("oldTitle");
                    title = req.getParameter("title");
                    description = req.getParameter("description");
                    video_link = req.getParameter("video_link");
                    System.out.println(oldTitle);
                    System.out.println(title);
                    System.out.println(description);
                    System.out.println(video_link);
                    if (!(oldTitle == null || title == null || description == null || video_link == null)) {
                        TipService.updateByTitle(oldTitle, title, description, video_link);
                    }
//                    save
                    break;
                case "edit_banner":
                    oldTitle = req.getParameter("oldTitle");
                    title = req.getParameter("title");
                    description = req.getParameter("description");
                    System.out.println(oldTitle);
                    System.out.println(title);
                    System.out.println(description);
                    if (!(oldTitle == null || title == null || description == null)) {
                        BannerService.getInstance().updateByTitle(oldTitle, title, description);
                    }
//                    save
                    break;
                case "add_banner":
                    title = req.getParameter("title");
                    description = req.getParameter("description");
                    Part part = req.getPart("image");
                    //check ton tai chua
                    if (BannerService.getInstance().isExist(title)) {

                    } else {//neu chua
                        //write in server
                        String imagePath = ImageService.writeBannerTipImagesFromClient(part, req, resp, getServletContext());
                        //insert database
                        title = (title != null) ? title : "";
                        description = (description != null) ? description : "";

                        BannerService.getInstance().insertBannerItem(title, description, imagePath);
                    }
                    break;
                case "add_tip":
                    title = req.getParameter("title");
                    description = req.getParameter("description");
                    video_link = req.getParameter("video_link");

                    //check ton tai chua
                    if (TipService.getInstance().isExist(title)) {

                    } else {//neu chua
                        title = (title != null) ? title : "";
                        description = (description != null) ? description : "";
                        video_link = (video_link != null) ? video_link : "";
                        part = req.getPart("image");
                        //write in server
                        String imagePath = ImageService.writeBannerTipImagesFromClient(part, req, resp, getServletContext());
                        //insert database
                        TipService.getInstance().insertTip(title, description, imagePath, video_link);
                    }
                    break;
                case "delete_banner":
                    String delete_banner_title = req.getParameter("delete_banner_title");
                    //deleteImageInServer
                    BannerItem bannerItem = BannerService.getInstance().getBannerItemByTitle(delete_banner_title);
                    ImageService.deleteImageInServer(getServletContext(), bannerItem.getImg_path());
                    //deleteImagePathInDB
                    BannerService.getInstance().deleteBannerByTitle(delete_banner_title);
                    break;
                case "delete_tip":
                    String delete_tip_title = req.getParameter("delete_tip_title");
                    //deleteImageInServer
                    Tip tip = TipService.getInstance().getTipByTitle(delete_tip_title);
                    ImageService.deleteImageInServer(getServletContext(), tip.getImgPath());
                    //deleteImagePathInDB
                    TipService.getInstance().deleteTipByTitle(delete_tip_title);
                    break;
            }
        }
        req.getRequestDispatcher("/views/Admin/banners_tips.jsp").forward(req, resp);
    }
}
