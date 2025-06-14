package model.dao;

import model.bean.User;
import model.db.JDBIConnector;

import java.sql.ResultSet;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

public class UserDAO {
    public static User getUserByEmail(final String email) {
        Optional<User> user = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where email= :e")
                        .bind("e", email)
                        .mapToBean(User.class)
                        .stream()
                        .findFirst()
        );
        return user.isEmpty() ? null : user.get();
    }

    public static boolean isPhoneExist(String phoneNumber) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select COUNT(*) FROM user where phoneNumber = :phoneNumber")
                        .bind("phoneNumber", phoneNumber)
                        .mapTo(Integer.class)
                        .one() > 0);
    }

    public static User getUserById(final String id) {
        Optional<User> user = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where id= :id")
                        .bind("id", id)
                        .mapToBean(User.class)
                        .stream()
                        .findFirst()
        );
        return user.isEmpty() ? null : user.get();
    }

    public static String getUserNameById(int userId) {
        try {
            String sql = "Select name from user where id= :userId";
            String userName = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery(sql).bind("userId", userId).mapTo(String.class).findOne().orElse(null)
            );
            return userName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    public static void setPasswordByEmail(final String email, String newPassword) {
        JDBIConnector.me().useHandle(handle -> {
            handle.createUpdate("update user set password = ? where email = ?")
                    .bind(0, newPassword).bind(1, email).execute();
        });
    }


    public static void insertUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User object is null");
        }

        String userPass = user.getPassword();
        String userName = user.getName();
        String userEmail = user.getEmail();
        String userTelephone = user.getPhoneNumber();

        if (userPass == null || userName == null || userEmail == null || userTelephone == null) {
            throw new IllegalArgumentException("User data is incomplete");
        }

        try {
            JDBIConnector.me().useHandle(handle ->
                    handle.createUpdate("INSERT INTO user ( password, name, email, phoneNumber)" +
                                    " VALUES(:password, :name, :email, :telephone)")

                            .bind("password", userPass)

                            .bind("name", userName)
                            .bind("email", userEmail)
                            .bind("telephone", userTelephone)
                            .execute()


            );

        } catch (Exception e) {
            // Xử lý exception tại đây, có thể log hoặc throw lại exception tùy vào yêu cầu của ứng dụng
            e.printStackTrace();
            throw new RuntimeException("Failed to insert user into the database", e);
        }
    }
    public static User addUser(String name, String phoneNumber, String email, String password, int roleId) {
        return JDBIConnector.me().withHandle(handle -> {
            // Thêm người dùng mới và lấy lại ID
            int id = handle.createUpdate("INSERT INTO `user` (`name`, `phoneNumber`, `email`, `password`, `roleId`) VALUES (:name, :phoneNumber, :email, :password, :roleId)")
                    .bind("name", name)
                    .bind("phoneNumber", phoneNumber)
                    .bind("email", email)
                    .bind("password", password)
                    .bind("roleId", roleId)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            // Truy vấn để lấy lại đối tượng User
            return handle.createQuery("SELECT * FROM `user` WHERE `id` = :id")
                    .bind("id", id)
                    .mapToBean(User.class)
                    .one();
        });
    }


    public static List<User> getAllUsers() {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user order by roleId asc").mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getAllUsers(String userId) {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user ORDER BY CASE WHEN id = :userId THEN 0 ELSE 1 END, roleId asc")
                        .bind("userId", userId).mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getOwnerList() {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where roleId=-1 order by roleId asc").mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getAdminList() {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where roleId=0 order by roleId asc").mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getUserList() {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where roleId=1 order by roleId asc").mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getNewUsersTop(int number) {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select  * from user where roleId = 1 order by createDate desc limit " + number).mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static void lockUser(String user_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE user SET status = 'Bị Khóa' WHERE id=?")
                        .bind(0, user_id)
                        .execute()
        );
    }

    public static void unlockUser(String user_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE user SET status = 'Bình Thường' WHERE id=?")
                        .bind(0, user_id)
                        .execute()
        );
    }

    public static long usersNumber() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from user")
                        .mapTo(Long.class).one());
    }

    public static List<User> findUsersByName(String name) {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where name LIKE ? order by name asc").
                        bind(0, "%" + name).
                        mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> findUserByPhone(String phoneNumber) {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where phoneNumber=? order by name asc").
                        bind(0, phoneNumber).
                        mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> findUserByEmail(String email) {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where email=? order by name asc").
                        bind(0, email).
                        mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static List<User> getLockUsers() {
        List<User> users = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from user where status='Bị Khóa' order by name asc").
                        mapToBean(User.class).stream().collect(Collectors.toList()));
        return users;
    }

    public static void updateName(String userId, String newName) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE user SET name=:newName  WHERE id=:userId")
                        .bind("userId", userId)
                        .bind("newName", newName)
                        .execute()
        );
    }

    public static void updatePhoneNumber(String userId, String phoneNumber) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE user SET phoneNumber=:phoneNumber  WHERE id=:userId")
                        .bind("userId", userId)
                        .bind("phoneNumber", phoneNumber)
                        .execute()
        );
    }

    public static boolean checkUserAllowedToRate(int productId, int userId) {
        String sql = "select 1 from `order` o" +
                " join `order_details` d on o.id = d.orderId" +
                " where d.productId=:productId and o.status=3 and o.userId=:userId" +
                " and exists (select count(userId) from `rate`" +
                " where productId=:productId and userId=:userId)";
        try {
            return JDBIConnector.me().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .mapTo(Integer.class)
                            .one() > 0);
        } catch (Exception e) {
            return false;
        }
    }

    public static String getNameById(int id) {
        try {
            String sql = "Select name from user where id= :userId";
            String userName = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery(sql).bind("userId", id).mapTo(String.class).findOne().orElse(null)
            );
            return userName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    //    Thêm user đăng nhập bằng GG
    public static void inserUserGG(String userName,String userTelephone,String userEmail,String password,String status,int roleId){
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("INSERT INTO user (name,phoneNumber,email,password,status,roleId)" +
                                " VALUES( :name,:telephone,:email, :password,:status, :roleId)")
                        .bind("name", userName)
                        .bind("telephone", userTelephone)
                        .bind("email", userEmail)
                        .bind("password",password)
                        .bind("status",status)
                        .bind("roleId",roleId)
                        .execute());
    }

    public static void main(String[] args) {
        inserUserGG("NTN","null","NTNNghia@gmail.com","null","Bình Thường",1);
    }
}