
package com.codequest.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/codequest_db?useSSL=false&serverTimezone=UTC";

    private static final String USER = "root";
    private static final String PASSWORD =
            System.getenv("CODEQUEST_DB_PASSWORD");

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {

        if (PASSWORD == null || PASSWORD.isEmpty()) {
            throw new SQLException(
                    "Database password is not configured."
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC driver was not found. Check WEB-INF/lib.",
                    e
            );
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
