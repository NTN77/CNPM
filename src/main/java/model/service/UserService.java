
package model.service;

import model.bean.User;
import model.dao.UserDAO;

import java.util.List;

public class UserService {
    private static UserService instance;

    public static UserService getInstance() {
        if (instance == null) instance = new UserService();
        return instance;
    }


    public static void insertUser(User user) {
        UserDAO.insertUser(user);
    }

    public User addUser(String name, String phoneNumber, String email, String password, int roleId) {
        return UserDAO.addUser(name, phoneNumber, email, password, roleId);
    }

    public User checkLogin(String email, String password) {
        User userByEmail = UserDAO.getUserByEmail(email);
        if (userByEmail != null && !userByEmail.isLock() && userByEmail.getEmail().equals(email)
                && userByEmail.getPassword().equals(password))
            return userByEmail;
        else return null;
    }

    public User checkEmail(String email) {
        User userByEmail = UserDAO.getUserByEmail(email);

        if (userByEmail != null && userByEmail.getEmail().equals(email))
            return userByEmail;
        else return null;
    }

    public boolean isPhoneNumberExist(String phoneNumber) {
        return UserDAO.isPhoneExist(phoneNumber);
    }

    public List<User> getAllUsers() {
        List<User> users = UserDAO.getAllUsers();
        return users;
    }

    public List<User> getAllUsers(String userId) {
        List<User> users = UserDAO.getAllUsers(userId);
        return users;
    }

    public List<User> getOwnerList() {
        List<User> users = UserDAO.getOwnerList();
        return users;
    }

    public List<User> getAdminList() {
        List<User> users = UserDAO.getAdminList();
        return users;
    }

    public List<User> getUserList() {
        List<User> users = UserDAO.getUserList();
        return users;
    }


    public List<User> getNewUsersTop(int number) {
        List<User> users = UserDAO.getNewUsersTop(number);
        return users;
    }

    public long usersNumber() {
        return UserDAO.usersNumber();
    }

    public List<User> getLockUsers() {
        return UserDAO.getLockUsers();
    }

    public List<User> findUsersByName(String name) {
        name.trim();
        return UserDAO.findUsersByName(name);
    }

    public List<User> findUserByPhone(String phoneNumber) {
        phoneNumber.trim();
        return UserDAO.findUserByPhone(phoneNumber);
    }

    public List<User> findUserByEmail(String email) {
        email.trim();
        return UserDAO.findUserByEmail(email);
    }

    public User getUserById(String id) {
        return UserDAO.getUserById(id);
    }

    public String getNameById(int id) {
        return UserDAO.getNameById(id);
    }

    public void lockUser(String id) {
        UserDAO.lockUser(id);
    }

    public void unlockUser(String id) {
        UserDAO.unlockUser(id);
    }

    public void updateName(String userId, String newName) {
        UserDAO.updateName(userId, newName);
    }

    public void updatePhoneNumber(String userId, String phoneNumber) {
        UserDAO.updatePhoneNumber(userId, phoneNumber);
    }

    public boolean checkUserAllowedToRate(int productId, int userId) {
        return UserDAO.checkUserAllowedToRate(productId, userId);
    }
}
