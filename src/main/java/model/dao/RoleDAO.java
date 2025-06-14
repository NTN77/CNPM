package model.dao;

import model.bean.Role;
import model.bean.User;
import model.db.JDBIConnector;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class RoleDAO {
    public static Role getRole(User user) {
        Optional<Role> roles = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from role where id= :role_id")
                        .bind("role_id", user.getRoleId())
                        .mapToBean(Role.class)
                        .stream()
                        .findFirst()
        );
        return roles.isEmpty()?null: roles.get();
    }

    public static void main(String[] args) {
        List<Role> roles = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from role").mapToBean(Role.class).collect(Collectors.toList())
        );
        System.out.println(roles.toString());
    }
}