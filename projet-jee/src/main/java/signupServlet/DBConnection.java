package signupServlet;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/bibliotheque?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "admin";

    public static Connection getConnection() {
        try {
            // Explicitly load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish and return the connection
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            // Log the exception and throw a runtime exception with a detailed message
            e.printStackTrace();
            throw new RuntimeException("Failed to connect to the database: " + e.getMessage(), e);
        }
    }
}
