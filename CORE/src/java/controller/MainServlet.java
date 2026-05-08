package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DB.DBConnection; 

@WebServlet("/MainServlet")
public class MainServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        Connection con = null;

        System.out.println("DEBUG: Action received -> " + action);

        try {
            con = DBConnection.getConnection(); 
            if ("register".equals(action)) {
                handleRegister(request, response, con);
            } else if ("login".equals(action)) {
                handleLogin(request, response, con);
            } else {
                System.out.println("DEBUG: No valid action found!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if(con != null) con.close(); } catch(SQLException se) { se.printStackTrace(); }
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Yahan 'name' use kiya hai kyunki aapke table mein wahi hai
        String query = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, password);
        
        int result = ps.executeUpdate();
        if(result > 0) {
            System.out.println("DEBUG: Registration Successful for " + name);
            response.sendRedirect("index.html?msg=RegisterSuccess");
        } else {
            response.sendRedirect("register.jsp?error=RegisterFailed");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String name = request.getParameter("name"); 
        String password = request.getParameter("password");

        System.out.println("DEBUG: Login Attempt -> Name: [" + name + "], Password: [" + password + "]");

        // --- FIXED HERE: Changed 'username' to 'name' to match your table ---
        String query = "SELECT * FROM users WHERE name=? AND password=?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, password);
        
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            System.out.println("DEBUG: Login Success!");
            HttpSession session = request.getSession();
            // Storing name in session to use in home.jsp
            session.setAttribute("username", rs.getString("name"));
            response.sendRedirect("home.jsp");
        } else {
            System.out.println("DEBUG: Login Failed - No match found.");
            response.sendRedirect("index.html?error=InvalidLogin");
        }
    }
}