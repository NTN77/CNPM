package model.bean;

import com.google.protobuf.MapEntry;
import model.service.ProductService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Cart {
    //Giỏ hàng chứa danh sách các item
//    private List<Item> items;

    Map<Integer, Item> items = new HashMap<>();

    @Override
    public String toString() {
        return "Cart{" +
                "items=" + items +
                '}';
    }

    public Map<Integer, Item> getItems() {
        return items;
    }

    public void setItems(Map<Integer, Item> items) {
        this.items = items;
    }

    //thêm 1 sản phầm
    public boolean add(int id) {
        return add(id, 1);
    }

    public boolean add(int id, int quantity) {
        Product p = ProductService.getInstance().getProductById(id);
        if (p == null) return false;
        Item item = null;
        if (items.containsKey(id)) {
            item = items.get(id);
            item.incQuantity(quantity);

        } else {
            item = new Item(p, quantity,
                    ProductService.getInstance().productPriceIncludeDiscount(p));
        }
        items.put(id, item);
        return true;
    }


    public int getQuantityById(int id) {
        int i = 0;
        if (!items.containsKey(id)) return i;

        Item item = items.get(id);
        i = item.getQuantity();
        return i;
    }

    public boolean remove(int id) {
        if (!items.containsKey(id)) return false;
        items.remove(id);
        return true;
    }

    public void updateValue(int id) {
        if (!items.containsKey(id)) return;

    }

    public double getTotalMoney() {
        double totalMoney = 0;
        for (Item item : items.values()) {
            totalMoney += (item.getQuantity() * item.getProduct().getSellingPrice());
        }
        return totalMoney;
    }

    public int getTotal() {
        return items.size();
    }


    public void clear() {
        items.clear();
    }



}