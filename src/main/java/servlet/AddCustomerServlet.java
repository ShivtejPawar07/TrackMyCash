package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AddCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?popup=addCustomer&error=db_fail");
                return;
            }

            /* CASE-INSENSITIVE CHECK */
            PreparedStatement check = con.prepareStatement(
                "SELECT id FROM customers WHERE user_id=? AND LOWER(name)=LOWER(?) AND phone=?"
            );
            check.setInt(1, userId);
            check.setString(2, name);
            check.setString(3, phone);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // customer already exists
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?popup=addCustomer&error=exists");
                return;
            }

            /* NOT EXISTS → INSERT */
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO customers(user_id, name, phone) VALUES (?,?,?)"
            );
            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.setString(3, phone);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?popup=addCustomer&success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=system");
        }
    }
}
