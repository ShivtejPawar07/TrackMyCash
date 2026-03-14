package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AddTransactionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String cid = request.getParameter("cid");
        String amountStr = request.getParameter("amount");
        String note = request.getParameter("note");
        String type = request.getParameter("type"); // gave / got

        if (cid == null || amountStr == null || type == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        double amount;

        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=invalidAmount");
            return;
        }

        if (amount <= 0) {
            response.sendRedirect("dashboard.jsp?error=invalidAmount");
            return;
        }


        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?cid=" + cid + "&error=db_fail");
                return;
            }
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO transactions(customer_id, amount, type, note) VALUES (?,?,?,?)"
            );
            ps.setInt(1, Integer.parseInt(cid));
            ps.setDouble(2, amount);
            ps.setString(3, type);
            ps.setString(4, note);

            ps.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?cid=" + cid);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=system");
        }
    }
}
