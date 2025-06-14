package model.service;

import model.bean.Category;
import model.dao.CategoryDAO;
import org.checkerframework.checker.units.qual.C;

import java.util.List;

public class CategoryService {
    private static CategoryService instance;

    public static CategoryService getInstance() {
        if (instance == null) instance = new CategoryService();
        return instance;
    }

    public List<Category> getALl() {


        return CategoryDAO.getAll();
    }

    public List<Category> getAllCategoriesWithNoProductsOnSale() {
        return CategoryDAO.getAllCategoriesWithNoProductsOnSale();
    }

    public Category getCategoryById(int id) {
        return CategoryDAO.getCategoryById(id);
    }


    public String createNewCategory(String newCategoryName) {
        return CategoryDAO.insertCategory(newCategoryName);
    }

    public void editCategoryNameById(String id, String newName) {
        CategoryDAO.updateCategoryNameById(id, newName);
    }

    public void deleteNoUsedCategoryById(String id) {
        CategoryDAO.deleteNoUsedCategoryById(id);
    }

    public boolean checkNoUsedCategoryById(int id) {
        return CategoryDAO.checkNoUsedCategoryById(id);
    }
}