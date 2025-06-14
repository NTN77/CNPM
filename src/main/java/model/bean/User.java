package model.bean;

import java.io.Serializable;
import java.sql.Timestamp;
import java.lang.annotation.Target;

public class User implements Serializable {
    private int id;
    private String name;
    private String phoneNumber;
    private String email;
    private boolean verified_email;
    private String password;
    private Timestamp createDate;
    private String status;
    private int roleId;

    public User() {
    }

    public User(String name, String phoneNumber, String email, String password) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.password = password;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }


    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", password='" + password + '\'' +
                ", createDate=" + createDate +
                ", status='" + status + '\'' +
                '}';
    }

    public boolean isOwn() {
        return this.roleId == -1;
    }

    public boolean isAdmin() {
        return this.roleId == 0;
    }

    public boolean isUser() {
        return this.roleId == 1;
    }

    public boolean isLock() {
        return (this.getStatus().equals("Bình Thường")) ? false : true;
    }

    public String nameAsRole() {
        if (isOwn()) {
            return "Chủ hệ thống";
        } else if (isAdmin()) {
            return "Quản trị viên";
        } else {
            return "Người dùng";
        }
    }
}