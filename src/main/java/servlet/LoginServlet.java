package servlet;

import db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                // Using context path for more reliable redirection
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Invalid Credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Important: Redirect to login with error message if an exception occurs (e.g., DB connection failure)
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=System Error: " + e.getMessage());
        }
    }
}
