package model.adapter;

import lombok.*;

import java.io.Serializable;
import java.util.Date;



@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class InventoryProduct implements Serializable {
        private int id;
        private String name;
        private String description;
        private int costPrice;
        private int sellingPrice;
        private int quantityRemaining; // Số lượng hàng tồn kho
        private int soldOut;
        private int priceDifference; // Số tiền chênh lêch giữa 2 lần nhập gần nhất = costPriceUpdate - costPrice.
        private Date lastModified; //ngày nhập hàng gần nhất.
        private int categoryId;
        private int discountId;
        private int isSale;


//        use to Dashboard.
        public InventoryProduct(int id, String name,int quantityRemaining , int soldOut) {
                this.id = id;
                this.name = name;
                this.quantityRemaining = quantityRemaining;
                this.soldOut = soldOut;
        }


        // use to inventory management.

        public InventoryProduct(int id, String name, int costPrice, int sellingPrice, int quantityRemaining, int soldOut,int priceDifference, Date lastModified, int isSale, int discountId) {
                this.id = id;
                this.name = name;
                this.costPrice = costPrice;
                this.sellingPrice = sellingPrice;
                this.quantityRemaining = quantityRemaining;
                this.soldOut = soldOut;
                this.priceDifference = priceDifference;
                this.lastModified = lastModified;
                this.isSale = isSale;
                this.discountId = discountId;
        }

        // use to discount management.
        public InventoryProduct(int id, String name, int costPrice, int sellingPrice, int quantityRemaining, int soldOut, int discountId, int categoryId) {
                this.id = id;
                this.name = name;
                this.costPrice = costPrice;
                this.sellingPrice = sellingPrice;
                this.quantityRemaining = quantityRemaining;
                this.soldOut = soldOut;
                this.discountId = discountId;
                this.categoryId = categoryId;
        }

        //use to update product.
        public InventoryProduct(int id, String name,String description, int costPrice, int sellingPrice, int quantityRemaining, int soldOut,Date lastModified, int discountId, int categoryId,  int isSale) {
                this.id = id;
                this.name = name;
                this.description = description;
                this.costPrice = costPrice;
                this.sellingPrice = sellingPrice;
                this.quantityRemaining = quantityRemaining;
                this.soldOut = soldOut;
                this.lastModified = lastModified;
                this.discountId = discountId;
                this.categoryId = categoryId;
                this.isSale = isSale;
        }

}

