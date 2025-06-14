package controller;

import com.google.gson.Gson;
import controller.ajax_handle.ProductResponseForProductsPage;
import model.bean.Product;
import model.dao.SortOption;
import model.service.DiscountService;
import model.service.ImageService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/productsPage")
public class ProductPageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryFilter = req.getParameter("categoryFilter");
        String isDiscount = req.getParameter("isDiscount");
        List<Product> products = (isDiscount == null || isDiscount.equals("false")) ?
                ProductService.getInstance()
                        .getProductByFilter(categoryFilter, SortOption.SORT_DEFAULT, null, null, 15, 0)
                : ProductService.getInstance()
                .getProductByFilter(categoryFilter, SortOption.SORT_DISCOUNT, null, null, 15, 0);
        
        // Filter to only show products with isSale = 1 or isSale = 3
        products = products.stream()
                .filter(p -> p.getIsSale() == 1 || p.getIsSale() == 3)
                .toList();
                
        req.setAttribute("products", products);
        req.setAttribute("filterFromHome", categoryFilter);
        req.setAttribute("isDiscount", isDiscount);
        req.getRequestDispatcher("views/products/productsPage.jsp?").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action != null) {
            System.out.println("action " + action);
            if (action.equals("filter") || action.equals("more")) {
                String searchFilter = req.getParameter("searchFilter");
                String categoryFilter = req.getParameter("categoryFilter");

                String sort = req.getParameter("sort");
                String startPrice = req.getParameter("startPrice");
                String endPrice = req.getParameter("endPrice");
                String limit = req.getParameter("limit");
                String offset = req.getParameter("offset");
                System.out.println(searchFilter);
                System.out.println(categoryFilter);
                System.out.println(sort);
                System.out.println(startPrice);
                System.out.println(endPrice);
                System.out.println(limit);
                System.out.println(offset);
                try {
                    Double startPriceValue = null, endPriceValue = null;
                    try {
                        if (startPrice != null && !startPrice.isEmpty() && (endPrice == null || endPrice.isEmpty())) {
                            startPriceValue = Double.parseDouble(startPrice);
                        } else if (endPrice != null && !endPrice.isEmpty() && (startPrice == null || startPrice.isEmpty())) {
                            endPriceValue = Double.parseDouble(endPrice);
                        } else if (startPrice != null && !startPrice.isEmpty() && endPrice != null && !endPrice.isEmpty()) {
                            startPriceValue = Double.parseDouble(startPrice);
                            endPriceValue = Double.parseDouble(endPrice);
                        }
                    } catch (NumberFormatException ex) {
                        ex.printStackTrace();
                    }
                    Integer sortValue = Integer.parseInt(sort);
                    Integer limitValue = Integer.parseInt(limit);
                    Integer offsetValue = Integer.parseInt(offset);
                    if (searchFilter != null && !searchFilter.isEmpty()) {
                        List<ProductResponseForProductsPage> res = new ArrayList<>();
                        List<Product> products =
                                ProductService.getInstance()
                                        .getProductBySearchFilter(searchFilter, sortValue, startPriceValue, endPriceValue, limitValue, offsetValue);
                        // Filter to only show products with isSale = 1 or isSale = 3
                        products = products.stream()
                                .filter(p -> p.getIsSale() == 1 || p.getIsSale() == 3)
                                .toList();
                        for (Product p : products) {
                            res.add(new ProductResponseForProductsPage(p.getId(), p.getName(), p.getSellingPrice(),
                                    p.getStock(), ProductService.getInstance().productPriceIncludeDiscount(p),
                                    ImageService.pathImageOnly(p.getId()), ProductService.getInstance().roundNumber(ProductService.getInstance().getAverageRateStars(p.getId())),
                                    DiscountService.getInstance().getPercentageOff(p.getDiscountId())));
                        }
                        Gson gson = new Gson();
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        String jsonResponse = gson.toJson(res);
                        resp.getWriter().write(jsonResponse);
                    } else if (categoryFilter != null) {
                        List<ProductResponseForProductsPage> res = new ArrayList<>();
                        List<Product> products =
                                ProductService.getInstance()
                                        .getProductByFilter(categoryFilter, sortValue, startPriceValue, endPriceValue, limitValue, offsetValue);
                        // Filter to only show products with isSale = 1 or isSale = 3
                        products = products.stream()
                                .filter(p -> p.getIsSale() == 1 || p.getIsSale() == 3)
                                .toList();
                        for (Product p : products) {
                            res.add(new ProductResponseForProductsPage(p.getId(), p.getName(), p.getSellingPrice(), p.getStock(),
                                    ProductService.getInstance().productPriceIncludeDiscount(p), ImageService.pathImageOnly(p.getId()),
                                    ProductService.getInstance().roundNumber(ProductService.getInstance().getAverageRateStars(p.getId())),
                                    DiscountService.getInstance().getPercentageOff(p.getDiscountId())));
                        }
                        Gson gson = new Gson();
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        String jsonResponse = gson.toJson(res);
                        resp.getWriter().write(jsonResponse);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
