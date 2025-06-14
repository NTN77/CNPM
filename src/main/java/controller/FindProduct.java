package controller;

import model.bean.Product;
import model.dao.ProductDAO;
import model.dao.SortOption;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/findProduct")
public class FindProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("html/text; charset= UTF-8");
        String query = req.getParameter("findProducts");
        if (query != null) {
            List<Product> productList1 = ProductService.getInstance().getProductBySearchFilter(query, SortOption.SORT_DEFAULT, null, null, 15, 0);
            int numberProduct = ProductDAO.getFindProductNumber(query);

            req.setAttribute("searchResultNumber", numberProduct);
            req.setAttribute("textSearch", query);
            req.setAttribute("products", productList1);

            String path = "./views/products/productsPage.jsp";
            req.getRequestDispatcher(path).forward(req, resp);
        }else{
            List<Product> productList1 = ProductService.getInstance().getAllProducts(15, 0);
            req.setAttribute("products", productList1);
            req.getRequestDispatcher("./views/products/productsPage.jsp").forward(req, resp);
        }
    }
}
