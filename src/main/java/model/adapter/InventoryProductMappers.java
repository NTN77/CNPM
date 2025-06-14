package model.adapter;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class InventoryProductMappers {
    public static class SoldOutMapper implements RowMapper<InventoryProduct> {

        //Use to dashboard : top 5 soldout.
        @Override
        public InventoryProduct map(ResultSet rs, StatementContext ctx) throws SQLException {
            return new InventoryProduct(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("quantityRemaining"),
                    rs.getInt("soldOut")
            );
        }
    }


    // Use to inventory management. Show mapper.
    public static class ViewInventoryMapper implements RowMapper<InventoryProduct> {
        @Override
        public InventoryProduct map(ResultSet rs, StatementContext ctx) throws SQLException {
            return new InventoryProduct(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("costPrice"),
                    rs.getInt("sellingPrice"),
                    rs.getInt("quantityRemaining"),
                    rs.getInt("soldOut"),
                    rs.getInt("priceDifference"),
                    rs.getDate("lastModified"),
                    rs.getInt("isSale"),
                    rs.getInt("discountId")
            );
        }
    }


    // Use to discount management. Show mapper.
    public static class ViewDiscountMapper implements RowMapper<InventoryProduct> {
        @Override
        public InventoryProduct map(ResultSet rs, StatementContext ctx) throws SQLException {
            return new InventoryProduct(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("costPrice"),
                    rs.getInt("sellingPrice"),
                    rs.getInt("quantityRemaining"),
                    rs.getInt("soldOut"),
                    rs.getInt("discountId"),
                    rs.getInt("categoryId")
            );
        }
    }


    // use to update product.

    public static class ViewDistinctMapper implements RowMapper<InventoryProduct> {
        @Override
        public InventoryProduct map(ResultSet rs, StatementContext ctx) throws SQLException {
            return new InventoryProduct(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getInt("costPrice"),
                    rs.getInt("sellingPrice"),
                    rs.getInt("quantityRemaining"),
                    rs.getInt("soldOut"),
                    rs.getDate("lastModified"),
                    rs.getInt("discountId"),
                    rs.getInt("categoryId"),
                    rs.getInt("isSale")

            );
        }


    }



}
