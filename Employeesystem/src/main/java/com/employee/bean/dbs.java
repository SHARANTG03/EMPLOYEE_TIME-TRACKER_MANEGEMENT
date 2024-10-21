package com.employee.bean;

import java.sql.Connection;
import java.sql.SQLException;

import com.employee.util.DbUtil;

public class dbs {

	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		Connection n = DbUtil.getConnection();

	}

}
