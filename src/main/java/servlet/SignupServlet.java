package servlet;

import db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                response.sendRedirect(request.getContextPath() + "/signup.jsp?msg=Signup Failed: Database connection unavailable. Visit <a href='test-db.jsp'>test-db.jsp</a> to check your Render environment variables.");
                return;
            }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password) VALUES(?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            ps.executeUpdate();
            response.sendRedirect("login.jsp?msg=Signup Successful! Please Login.");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?msg=Signup Failed: " + e.getMessage());
        }
    }
}
