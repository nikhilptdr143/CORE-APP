package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;
        try {
            // 1. Driver Load karna
            Class.forName("com.mysql.cj.jdbc.Driver");

            // --- LOCALHOST CONFIGURATION ---
            String host = "localhost";      
            String port = "3306";      
            String dbName = "coredb"; // <--- Naam ekdum sahi kar diya hai
            String user = "root";      
            String pass = "root";     // <--- Agar error aaye toh password "" (khali) bhi try karna

            // URL format
            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;

            // 2. Connection Establish
            con = DriverManager.getConnection(url, user, pass);
            
            if (con != null) {
                System.out.println("✅ Connection Successful with coredb!");
            }

        } catch (ClassNotFoundException e) {
            System.out.println("❌ Driver Error: Jar file check karo!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Database Error: Password ya DB name check karo!");
            e.printStackTrace();
        }
        return con;  
    } 
}