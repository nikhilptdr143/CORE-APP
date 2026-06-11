/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class CreateTablesOnline {
    public static void main(String[] args) {
        // आपके ऑनलाइन Aiven डेटाबेस की डिटेल्स
        String host = "mysql-5cca669-nikhilpatidar581-44e1.c.aivencloud.com";
        String port = "27825";
        String db_name = "defaultdb";
        String user = "avnadmin";
        String pass = "AVNS_glFI065gB08lILU9U4v";

        String url = "jdbc:mysql://" + host + ":" + port + "/" + db_name + "?sslMode=REQUIRED";

        // SQL Queries जो आपकी टेबल्स बनाएंगी
        String createUsersTable = "CREATE TABLE IF NOT EXISTS users ("
                + "  id int NOT NULL AUTO_INCREMENT,"
                + "  name varchar(100) NOT NULL,"
                + "  email varchar(100) NOT NULL,"
                + "  password varchar(100) NOT NULL,"
                + "  created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,"
                + "  PRIMARY KEY (id),"
                + "  UNIQUE KEY email (email)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

        String createConnectionsTable = "CREATE TABLE IF NOT EXISTS connections ("
                + "  id int NOT NULL AUTO_INCREMENT,"
                + "  user_1 int DEFAULT NULL,"
                + "  user_2 int DEFAULT NULL,"
                + "  status varchar(20) DEFAULT 'connected',"
                + "  created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,"
                + "  PRIMARY KEY (id),"
                + "  KEY user_1 (user_1),"
                + "  KEY user_2 (user_2),"
                + "  CONSTRAINT connections_ibfk_1 FOREIGN KEY (user_1) REFERENCES users (id),"
                + "  CONSTRAINT connections_ibfk_2 FOREIGN KEY (user_2) REFERENCES users (id)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

        try {
            // डेटाबेस से कनेक्ट करना
            System.out.println("Connecting to Aiven Database...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, pass);
            Statement stmt = con.createStatement();

            // 1. पहले Users टेबल बनाएंगे (क्योंकि Connections टेबल इसपर निर्भर है)
            System.out.println("Creating 'users' table...");
            stmt.executeUpdate(createUsersTable);
            System.out.println("'users' table created successfully!");

            // 2. फिर Connections टेबल बनाएंगे
            System.out.println("Creating 'connections' table...");
            stmt.executeUpdate(createConnectionsTable);
            System.out.println("'connections' table created successfully!");

            // कनेक्शन बंद करना
            stmt.close();
            con.close();
            System.out.println("All tables created successfully! Database is ready.");

        } catch (Exception e) {
            System.out.println("Error occurred while creating tables:");
            e.printStackTrace();
        }
    }
}