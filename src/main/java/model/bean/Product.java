package model.bean;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Product {
    private int id;
    private String name;
    private String description;
    private int sellingPrice;
    private int stock;
    private int categoryId;
    private int discountId;
    private int isSale;


}
