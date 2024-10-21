package com.employee.services;

import com.employee.dao.UserDao;
import com.employee.bean.User;

public class UserService {
    private UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    public User authenticateUser(int userId, String password) {
        return userDao.getUserByIdAndPassword(userId, password);
    }

    public boolean updatePassword(int userId, String oldPassword, String newPassword) {
        return userDao.updatePassword(userId, oldPassword, newPassword);
    }

    public boolean verifyOldPassword(int userId, String oldPassword) {
        User user = userDao.getUserByIdAndPassword(userId, oldPassword);
        return user != null;
    }
}