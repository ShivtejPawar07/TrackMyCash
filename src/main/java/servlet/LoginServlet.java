package servlet;

import db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Logging for Render debug
        System.out.println("[LoginServlet] Attempting login for: " + email);

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("[LoginServlet] ERROR: Database connection is NULL");
                response.sendRedirect("login.jsp?msg=Database connection error. Check Render log.");
                return;
            }

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", rs.getInt("id"));
                
                String name = rs.getString("name");
                if (name == null || name.trim().isEmpty()) name = "User";
                session.setAttribute("userName", name);
                
                System.out.println("[LoginServlet] Login SUCCESS for: " + email + ". Redirecting to dashboard...");
                
                // Using a relative redirect is often safer through proxies
                response.sendRedirect("dashboard.jsp");
            } else {
                System.out.println("[LoginServlet] Login FAILED for: " + email);
                response.sendRedirect("login.jsp?msg=Invalid Credentials");
            }
        } catch (Exception e) {
            System.err.println("[LoginServlet] EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=System Error: " + e.getMessage());
        }
    }
}
