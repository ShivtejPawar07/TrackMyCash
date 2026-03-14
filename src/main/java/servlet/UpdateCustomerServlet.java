package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class UpdateCustomerServlet extends HttpServlet {

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    Integer userId = (Integer) request.getSession().getAttribute("userId");
    if (userId == null) {
      response.sendRedirect("login.jsp");
      return;
    }

    String cid = request.getParameter("cid");
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");

    try (Connection con = DBConnection.getConnection()) {
      if (con == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=db_fail");
        return;
      }

      // CASE-INSENSITIVE DUPLICATE CHECK
      PreparedStatement check = con.prepareStatement(
        "SELECT id FROM customers WHERE user_id=? AND LOWER(name)=LOWER(?) AND phone=? AND id<>?"
      );
      check.setInt(1, userId);
      check.setString(2, name);
      check.setString(3, phone);
      check.setInt(4, Integer.parseInt(cid));

      ResultSet rs = check.executeQuery();
      if (rs.next()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?popup=editCustomer&error=updateExists");
        return;
      }

      PreparedStatement ps = con.prepareStatement(
        "UPDATE customers SET name=?, phone=? WHERE id=? AND user_id=?"
      );
      ps.setString(1, name);
      ps.setString(2, phone);
      ps.setInt(3, Integer.parseInt(cid));
      ps.setInt(4, userId);

      ps.executeUpdate();
      response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=system");
    }
  }
}
