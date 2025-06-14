package controller;

import model.bean.*;
import model.dao.OrderDAO;
import model.dao.ProductDAO;
import model.service.CategoryService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

@WebServlet("/order-custom")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class OrderCustomController extends HttpServlet {
    private static final String SAVE_DIR = "images/custom";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Product product = ProductService.getInstance().getProductById(id);
        Image mainImage = ProductDAO.getImagesForProduct(id).get(0);
        Category category = CategoryService.getInstance().getCategoryById(product.getCategoryId());

        req.setAttribute("productById", product);
        req.setAttribute("mainImage",mainImage );
        req.setAttribute("categoryByProduct", category);


        req.getRequestDispatcher("views/order-custom/order-custom.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String note = req.getParameter("note");
        String tel = req.getParameter("tel");

        String recieveDate = req.getParameter("deliveryDate");

        Date deliveryDate = null;
        try {
            deliveryDate = new SimpleDateFormat("yyyy-MM-dd").parse(recieveDate);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String packaging = req.getParameter("packageType");
        String color = req.getParameter("color");

        if (packaging == null || packaging.isEmpty())
            packaging = "Đóng gói mặc định";

        if(color == null || color.isEmpty())
            color = "Shop tự chọn";

        String otherCustom = "Hình thức đóng gói: " + packaging + ", màu sắc: " + color;

        String province = req.getParameter("province");
        String district = req.getParameter("district");
        String ward = req.getParameter("ward");
        String numberAddress = req.getParameter("address");

        System.out.println(province);
        System.out.println(district);
        System.out.println(ward);
        System.out.println(numberAddress);

        System.out.println(packaging);
        System.out.println(color);



        String address = numberAddress + ", " + ward + ", " + district + ", " + province;


        int productId = Integer.parseInt(req.getParameter("productId"));

        String uploadPath = "C:\\Users\\ASUS\\Documents\\TLH\\TMDT\\handmade\\src\\main\\webapp\\images\\custom";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();


        String projectPath = System.getProperty("user.dir") + File.separator +
                "src" + File.separator +
                "main" + File.separator +
                "webapp" + File.separator +
                SAVE_DIR;
        File projectDir = new File(projectPath);
        if (!projectDir.exists()) projectDir.mkdirs();
        Collection<Part> parts = req.getParts();
        List<String> savedImagePaths = new ArrayList<>();

        int count = 1;

        for (Part part : parts) {
            if (part.getName().equals("path") && part.getSize() > 0) {
                String originalFileName = part.getSubmittedFileName();
                if (originalFileName == null) originalFileName = "image.jpg";

                String extension = originalFileName.contains(".")
                        ? originalFileName.substring(originalFileName.lastIndexOf('.'))
                        : ".jpg";

                String date = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

                String filename = user.getName() + "_" + productId + "_" + date + "_" + count + extension;

                File destFile = new File(uploadPath, filename);
                part.write(destFile.getAbsolutePath());

                // Đường dẫn lưu trong DB: tương đối để dùng cho <img src="">
                savedImagePaths.add("images/custom/" + filename);

                count++;
            }
        }

        for (String imagePath : savedImagePaths) {
            System.out.println("dang o trong vong lap ne");
            OrderImage image = new OrderImage();
            image.setUserId(user.getId());
            image.setProductId(productId);
            image.setImagePath(imagePath);
            image.setOrderDate(new Date());
            image.setTel(tel);
            image.setStatus(0);
            image.setNote(note);
            image.setAddress(address);
            image.setOtherCustom(otherCustom);
            image.setRecieveDate(deliveryDate);
            OrderDAO.addOrderImage(image);
        }

        req.setAttribute("success", true);
        req.getRequestDispatcher("/views/order-custom/custom_response.jsp").forward(req, resp);
    }
}
