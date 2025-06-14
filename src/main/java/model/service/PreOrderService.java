package model.service;

import model.bean.PreOrder;
import model.dao.PreOrderDAO;

import java.util.Date;
import java.util.List;

public class PreOrderService {
    public static PreOrderService instance;
    public static PreOrderService getInstance(){
        if(instance==null) instance = new PreOrderService();
        return instance;
    }
    public static PreOrder getPreOrderById(int id){return PreOrderDAO.getPreOrderById(id);}
    public static void addPreOrder(int id, int amount, Date dateEnd){PreOrderDAO.addPreOrder(id, amount, dateEnd);}
    public static void removePreOrderById(int id){PreOrderDAO.removePreOrderById(id);}
    public static List<PreOrder> getAllPreOrder(){return PreOrderDAO.getAllPreOrder();}
    public void reducePreOrderAmount(int productId, int quantity) {
        PreOrderDAO.reducePreOrderAmount(productId, quantity);
    }
    public void increasePreOrderAmount(int productId, int quantity) {
        PreOrderDAO.increasePreOrderAmount(productId, quantity);
    }
    public void processExpiredPreOrderIfNeeded(int productId) {
        model.bean.PreOrder preOrder = getPreOrderById(productId);
        if (preOrder != null && preOrder.getAmount() <= 0) {
            // Set product isSale to 2 (out of stock)
            model.bean.Product p = model.service.ProductService.getInstance().getProductById(productId);
            if (p != null) {
                p.setIsSale(2);
                model.service.ProductService.getInstance().editProduct(
                    String.valueOf(productId),
                    p.getName(),
                    p.getDescription(),
                    p.getSellingPrice(),
                    String.valueOf(p.getCategoryId()),
                    String.valueOf(p.getDiscountId()),
                    2
                );
            }
            // Remove pre-order entry
            removePreOrderById(productId);
        }
    }
}
