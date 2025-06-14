package model.service;

import model.bean.Role;
import model.bean.User;
import model.dao.RoleDAO;

public class RoleService {
    private static RoleService instance;

    public static RoleService getInstance(){
        if(instance==null) instance = new RoleService();
        return instance;
    }

    public String checkRole(User user){
        Role role = RoleDAO.getRole(user);
        if(role.getName().equals("admin")){
            return "admin";
        }else{
            return "user";
        }
    }

}