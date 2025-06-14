package model.bean;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserGoogle implements Serializable {
    private String id;
    private String name;
    private String phoneNumber;
    private String email;
    private boolean verified_email;
    private String password;
    private Timestamp createDate;

    private String given_name;

    private String family_name;

    private String picture;

    private String status;
    private int roleId;

    public UserGoogle(String id, String name, String phoneNumber, String email, boolean verified_email, String password, Timestamp createDate, String given_name, String family_name, String picture, String status, int roleId) {
        this.id = id;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.verified_email = verified_email;
        this.password = password;
        this.createDate = createDate;
        this.given_name = given_name;
        this.family_name = family_name;
        this.picture = picture;
        this.status = status;
        this.roleId = roleId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public boolean isVerified_email() {
        return verified_email;
    }

    public void setVerified_email(boolean verified_email) {
        this.verified_email = verified_email;
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

    public String getGiven_name() {
        return given_name;
    }

    public void setGiven_name(String given_name) {
        this.given_name = given_name;
    }

    public String getFamily_name() {
        return family_name;
    }

    public void setFamily_name(String family_name) {
        this.family_name = family_name;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
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
        return "UserGoogle{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", verified_email=" + verified_email +
                ", password='" + password + '\'' +
                ", createDate=" + createDate +
                ", given_name='" + given_name + '\'' +
                ", family_name='" + family_name + '\'' +
                ", picture='" + picture + '\'' +
                ", status='" + status + '\'' +
                ", roleId=" + roleId +
                '}';
    }
}