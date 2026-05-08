package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Current session ko pakdo
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Session ko khatam (destroy) kar do
            session.invalidate();
            System.out.println("DEBUG: User logged out successfully.");
        }

        // 3. Wapas login page par bhej do
        response.sendRedirect("index.html?msg=logged_out");
    }
}