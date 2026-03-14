<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%
    // Session Security Check
    if(session.getAttribute("userId") == null){
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int uid = (int)session.getAttribute("userId");
    String userName = (String)session.getAttribute("userName");
    if (userName == null) userName = "User";

    Connection con = null;
    String dbError = null;
    double overallBalance = 0;
    
    try {
        con = DBConnection.getConnection();
        if (con == null) {
            dbError = "Database connection returned null. Check your Environment Variables.";
        }
    } catch (Exception e) {
        dbError = e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track My Cash - Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --bg-dark: #0f172a;
            --bg-card: #1e293b;
            --bg-sidebar: #0f172a;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --accent-primary: #3b82f6;
            --accent-glow: rgba(59, 130, 246, 0.5);
            --income-color: #10b981;
            --expense-color: #ef4444;
            --sidebar-width: 280px;
        }

        body.light-mode {
            --bg-dark: #f8fafc;
            --bg-card: #ffffff;
            --bg-sidebar: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --accent-primary: #2563eb;
            --accent-glow: rgba(37, 99, 235, 0.3);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-main);
            margin: 0; padding: 0;
            overflow-x: hidden;
            transition: background-color 0.3s, color 0.3s;
        }

        #app-wrapper { display: flex; height: 100vh; overflow: hidden; }

        #sidebar {
            width: var(--sidebar-width);
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .brand-box {
            height: 70px; display: flex; align-items: center; padding: 0 1.5rem;
            border-bottom: 1px solid var(--border-color);
            font-size: 1.25rem; font-weight: 700; color: var(--accent-primary);
            text-decoration: none;
        }
        .brand-box i { margin-right: 10px; font-size: 1.5rem; }

        .search-box { padding: 1rem; border-bottom: 1px solid var(--border-color); }
        .search-box input {
            background-color: var(--bg-card); border: 1px solid var(--border-color);
            color: var(--text-main); border-radius: 8px; padding: 0.6rem 1rem; width: 100%;
        }

        .customer-list-container { flex: 1; overflow-y: auto; padding: 0.5rem 1rem; }
        .customer-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.75rem 1rem; margin-bottom: 0.25rem; border-radius: 8px;
            color: var(--text-main); text-decoration: none; transition: all 0.2s;
        }
        .customer-item:hover, .customer-item.active { background-color: rgba(59, 130, 246, 0.1); color: var(--accent-primary); }
        .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 600; margin-right: 10px; font-size: 0.85rem;
        }

        #main-content { flex: 1; display: flex; flex-direction: column; background-color: var(--bg-dark); overflow-y: auto; }

        .topbar {
            height: 70px; background-color: var(--bg-sidebar); border-bottom: 1px solid var(--border-color);
            display: flex; justify-content: space-between; align-items: center; padding: 0 2rem;
            position: sticky; top: 0; z-index: 100;
        }

        .fin-card {
            background-color: var(--bg-card); border-radius: 16px; padding: 1.5rem; border: 1px solid var(--border-color);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); transition: transform 0.3s;
        }
        .fin-card.primary { background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); color: white; border: none; }
        .fin-card:hover { transform: translateY(-5px); }

        .table-container { background-color: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; overflow: hidden; }
        .badge-income { background-color: rgba(16, 185, 129, 0.1); color: var(--income-color); padding: 0.4em 0.8em; border-radius: 6px; font-weight: 600; }
        .badge-expense { background-color: rgba(239, 68, 68, 0.1); color: var(--expense-color); padding: 0.4em 0.8em; border-radius: 6px; font-weight: 600; }

        .fab-btn {
            position: fixed; bottom: 2rem; right: 2rem; width: 60px; height: 60px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            color: white; display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; box-shadow: 0 10px 25px var(--accent-glow); z-index: 90; border: none;
        }

        @media (max-width: 991px) {
            #sidebar { position: fixed; left: -100%; height: 100vh; }
            #sidebar.show { left: 0; }
        }
    </style>
</head>

<body>
<div id="app-wrapper">
    
    <!-- Sidebar -->
    <div id="sidebar">
        <a href="dashboard.jsp" class="brand-box">
            <i class="fa-solid fa-wallet"></i> TrackMyCash
        </a>
        <div class="search-box">
            <input type="text" id="searchCustomer" placeholder="Search customer...">
        </div>
        <div class="customer-list-container" id="customerList">
            <%
              if(con != null) {
                  try {
                      PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE user_id=?");
                      ps.setInt(1, uid);
                      ResultSet rs = ps.executeQuery();
                      while(rs.next()){
                          int cid2 = rs.getInt("id");
                          String cname = rs.getString("name");
                          if(cname == null) cname = "Unknown";
                          
                          PreparedStatement balPS = con.prepareStatement(
                           "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) b FROM transactions WHERE customer_id=?"
                          );
                          balPS.setInt(1, cid2);
                          ResultSet balRS = balPS.executeQuery();
                          double b = 0;
                          if(balRS.next()) b = balRS.getDouble("b");
                          overallBalance += b;
                          
                          String currentCid = request.getParameter("cid");
                          String activeClass = (currentCid != null && currentCid.equals(String.valueOf(cid2))) ? "active" : "";
            %>
            <a href="dashboard.jsp?cid=<%=cid2%>" class="customer-item <%=activeClass%>" data-name="<%=cname.toLowerCase()%>">
                <div class="avatar"><%=cname.length() > 0 ? cname.substring(0, 1).toUpperCase() : "C"%></div>
                <div class="customer-info">
                    <div style="font-weight:500;"><%=cname%></div>
                    <div style="font-size:0.8rem;" class="<%= b >= 0 ? "text-success" : "text-danger" %>">
                        ₹<%=String.format("%.2f", b)%>
                    </div>
                </div>
            </a>
            <% 
                          balRS.close(); balPS.close();
                      } 
                      rs.close(); ps.close();
                  } catch (Exception e) { out.println("<!-- Sidebar Data Error: " + e.getMessage() + " -->"); }
              } else {
            %>
                <div class="p-3 text-muted small"><i class="fa-solid fa-circle-info me-1"></i> Connect database to view customers.</div>
            <% } %>
        </div>
        <button class="add-customer-btn p-3 m-3 btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
            <i class="fa-solid fa-plus me-2"></i>Add Customer
        </button>
    </div>

    <!-- Main Content -->
    <div id="main-content">
        <div class="topbar">
            <button class="btn text-white d-lg-none" onclick="document.getElementById('sidebar').classList.toggle('show')"><i class="fa-solid fa-bars"></i></button>
            <h4 class="mb-0 fw-bold">Dashboard</h4>
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-link text-muted" onclick="document.body.classList.toggle('light-mode')"><i class="fa-solid fa-moon"></i></button>
                <div class="dropdown">
                    <div class="d-flex align-items-center gap-2" data-bs-toggle="dropdown" style="cursor:pointer;">
                        <div class="avatar" style="margin:0;"><%=userName.substring(0,1).toUpperCase()%></div>
                        <span class="d-none d-md-block"><%=userName%></span>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item text-danger" href="LogoutServlet">Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="p-4">
            <% if (dbError != null) { %>
                <div class="alert alert-danger shadow-sm border-0" style="border-radius: 12px; background: rgba(239, 68, 68, 0.1); color: #fecaca;">
                    <h5 class="fw-bold"><i class="fa-solid fa-triangle-exclamation me-2"></i>Database Connection Issue</h5>
                    <p class="mb-0">Please ensure your environment variables are correctly set on Render. Error: <code><%= dbError %></code></p>
                </div>
            <% } %>

            <%
                if (con != null) {
                    try {
                        String cidStr = request.getParameter("cid");
                        if(cidStr == null) {
            %>
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="fin-card primary">
                        <div style="opacity:0.8;">Overall Balance</div>
                        <h2 class="fw-bold mt-1">₹<%=String.format("%.2f", overallBalance)%></h2>
                    </div>
                </div>
            </div>
            <div class="row g-4">
                <div class="col-md-8">
                    <div class="fin-card">
                        <h5 class="mb-4">Monthly Trends</h5>
                        <canvas id="monthlyChart" height="200"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="fin-card">
                        <h5 class="mb-4">Recent Activity</h5>
                        <p class="text-muted">Select a customer to view detailed transactions.</p>
                    </div>
                </div>
            </div>
            <% } else { 
                int cid = Integer.parseInt(cidStr);
                String cName = "";
                double cTotal = 0;
                PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE id=?");
                ps.setInt(1, cid);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) cName = rs.getString("name");
                rs.close(); ps.close();
                
                PreparedStatement psTotal = con.prepareStatement("SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) as t FROM transactions WHERE customer_id=?");
                psTotal.setInt(1, cid);
                ResultSet rsTotal = psTotal.executeQuery();
                if(rsTotal.next()) cTotal = rsTotal.getDouble("t");
                rsTotal.close(); psTotal.close();
            %>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-0"><%=cName%></h2>
                    <div class="<%= cTotal >= 0 ? "text-success" : "text-danger" %> fw-bold">Balance: ₹<%=String.format("%.2f", cTotal)%></div>
                </div>
                <div class="btn-group">
                    <button class="btn btn-outline-info" onclick="openEditCustomer('<%=cid%>','<%=cName%>','')">Edit</button>
                    <button class="btn btn-outline-danger" onclick="deleteCustomer('<%=cid%>')">Delete</button>
                </div>
            </div>

            <div class="table-container shadow-sm">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Date</th>
                            <th>Note</th>
                            <th class="text-end">Amount</th>
                            <th class="text-center">Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            PreparedStatement tps = con.prepareStatement("SELECT * FROM transactions WHERE customer_id=? ORDER BY date DESC");
                            tps.setInt(1, cid);
                            ResultSet trs = tps.executeQuery();
                            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy hh:mm a");
                            while(trs.next()){
                                String type = trs.getString("type");
                        %>
                        <tr>
                            <td><%= trs.getTimestamp("date") != null ? sdf.format(new java.util.Date(trs.getTimestamp("date").getTime())) : "-" %></td>
                            <td><%= trs.getString("note") != null ? trs.getString("note") : "-" %></td>
                            <td class="text-end fw-bold">₹<%=String.format("%.2f", trs.getDouble("amount"))%></td>
                            <td class="text-center">
                                <span class="<%= "got".equals(type) ? "badge-income" : "badge-expense" %>">
                                    <%= "got".equals(type) ? "Received" : "Paid" %>
                                </span>
                            </td>
                        </tr>
                        <% } trs.close(); tps.close(); %>
                    </tbody>
                </table>
            </div>
            <button class="fab-btn" data-bs-toggle="modal" data-bs-target="#addTxnModal"><i class="fa-solid fa-plus"></i></button>
            <% } 
                    } catch (Exception e) { 
                        out.println("<div class='alert alert-warning'>Error processing content: " + e.getMessage() + "</div>");
                    }
                } else { %>
                <div class="text-center mt-5">
                    <i class="fa-solid fa-database fa-4x text-muted mb-3"></i>
                    <h3>Ready to Track?</h3>
                    <p class="text-muted">Once your database is connected, you'll see your financial summary here.</p>
                </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Modals -->
<div class="modal fade" id="addCustomerModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5>Add Customer</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><form action="AddCustomerServlet" method="post"><div class="modal-body"><input type="text" name="name" class="form-control mb-3" placeholder="Name" required><input type="text" name="phone" class="form-control" placeholder="Phone"></div><div class="modal-footer"><button type="submit" class="btn btn-primary">Save</button></div></form></div></div></div>

<% if(request.getParameter("cid") != null) { %>
<div class="modal fade" id="addTxnModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5>Add Transaction</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><form action="AddTransactionServlet" method="post"><div class="modal-body"><input type="hidden" name="cid" value="<%=request.getParameter("cid")%>"><input type="number" name="amount" class="form-control mb-3" placeholder="Amount" required><input type="text" name="note" class="form-control mb-3" placeholder="Note"><div class="d-flex gap-2"><button type="submit" name="type" value="gave" class="btn btn-danger w-50">Paid</button><button type="submit" name="type" value="got" class="btn btn-success w-50">Received</button></div></div></form></div></div></div>
<% } %>

<%@ include file="UpdateCustomer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEditCustomer(id, name, phone) {
        document.getElementById('editCid').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editPhone').value = phone;
        new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
    }
    function deleteCustomer(id) { if(confirm("Delete customer?")) window.location.href="DeleteCustomerServlet?cid="+id; }
    
    if(document.getElementById('monthlyChart')) {
        new Chart(document.getElementById('monthlyChart'), {
            type: 'line',
            data: { labels: ['Jan','Feb','Mar','Apr','May','Jun'], datasets: [{ label: 'Expenses', data: [12,19,3,5,2,3], borderColor: '#3b82f6', tension: 0.3 }] },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    }
</script>
</body>
</html>
<% if (con != null) { try { con.close(); } catch(Exception e) {} } %>