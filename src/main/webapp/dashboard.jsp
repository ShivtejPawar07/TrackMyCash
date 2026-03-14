<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%
    // Session Security Check
    Object userIdObj = session.getAttribute("userId");
    if(userIdObj == null){
        System.out.println("[Dashboard JSP] No userId in session, redirecting to login...");
        response.sendRedirect("login.jsp");
        return;
    }
    
    int uid = (int)userIdObj;
    String userName = (String)session.getAttribute("userName");
    if (userName == null || userName.trim().isEmpty()) userName = "User";

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
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #5c67f2;
            --whatsapp-green: #25d366;
            --khatabook-red: #ea4335;
            --bg-light: #f4f7f6;
            --white: #ffffff;
            --text-dark: #2d3436;
            --text-muted: #636e72;
            --border-light: #e0e6ed;
            --sidebar-width: 320px;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            margin: 0;
            overflow: hidden;
        }

        #app-wrapper {
            display: flex;
            height: 100vh;
        }

        /* Sidebar Styles */
        #sidebar {
            width: var(--sidebar-width);
            background: var(--white);
            border-right: 1px solid var(--border-light);
            display: flex;
            flex-direction: column;
            z-index: 1000;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-header {
            padding: 20px;
            background: var(--primary);
            color: white;
        }

        .search-container {
            padding: 15px;
            background: #fff;
            border-bottom: 1px solid var(--border-light);
        }

        .search-bar {
            background: #f1f3f5;
            border: none;
            border-radius: 10px;
            padding: 10px 15px;
            width: 100%;
            outline: none;
        }

        .customer-list {
            flex: 1;
            overflow-y: auto;
        }

        .customer-card {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-light);
            text-decoration: none;
            color: inherit;
            transition: 0.2s;
        }

        .customer-card:hover {
            background: #f8f9fa;
        }

        .customer-card.active {
            background: rgba(92, 103, 242, 0.1);
            border-left: 4px solid var(--primary);
        }

        .customer-avatar {
            width: 48px;
            height: 48px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.2rem;
            margin-right: 15px;
        }

        .customer-details {
            flex: 1;
        }

        .customer-name {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 2px;
        }

        .customer-balance {
            font-size: 0.85rem;
            font-weight: 500;
        }

        .balance-positive { color: var(--whatsapp-green); }
        .balance-negative { color: var(--khatabook-red); }

        /* Main Content Styles */
        #main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--bg-light);
            position: relative;
        }

        .main-header {
            padding: 15px 25px;
            background: var(--white);
            border-bottom: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-info h4 {
            margin: 0;
            font-weight: 700;
        }

        .transaction-container {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-image: radial-gradient(#d1d1d1 1px, transparent 1px);
            background-size: 20px 20px;
        }

        /* Transaction Card Styles */
        .txn-card {
            background: var(--white);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 12px;
            border: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            transition: 0.2s;
        }

        .txn-card:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.05); }

        .txn-main { display: flex; align-items: center; }

        .txn-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .icon-got { background: rgba(37, 211, 102, 0.1); color: var(--whatsapp-green); }
        .icon-gave { background: rgba(234, 67, 53, 0.1); color: var(--khatabook-red); }

        .txn-text .note { font-weight: 600; font-size: 1rem; margin-bottom: 2px; }
        .txn-text .date { font-size: 0.8rem; color: var(--text-muted); }

        .txn-amount { text-align: right; }
        .amount-val { font-weight: 700; font-size: 1.1rem; }
        .amount-type { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }

        /* Floating Action Button */
        .fab {
            position: absolute;
            bottom: 30px;
            right: 30px;
            width: 65px;
            height: 65px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            box-shadow: 0 8px 16px rgba(92, 103, 242, 0.4);
            cursor: pointer;
            border: none;
            transition: 0.3s;
            z-index: 100;
        }

        .fab:hover { transform: rotate(90deg) scale(1.1); }

        /* Responsive */
        @media (max-width: 991px) {
            #sidebar {
                position: fixed;
                left: -100%;
                height: 100vh;
            }
            #sidebar.show { left: 0; }
            .menu-toggle { display: block !important; }
        }

        .empty-state {
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            text-align: center;
        }

        .empty-state i { font-size: 4rem; margin-bottom: 20px; opacity: 0.3; }

    </style>
</head>
<body>

<div id="app-wrapper">
    <!-- Sidebar -->
    <div id="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="m-0 fw-bold">My Customers</h5>
                <a href="LogoutServlet" class="text-white"><i class="fa-solid fa-right-from-bracket"></i></a>
            </div>
            <button class="btn btn-light w-100 fw-bold py-2" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="fa-solid fa-user-plus me-2"></i>Add Customer
            </button>
        </div>
        
        <div class="search-container">
            <input type="text" class="search-bar" id="searchCustomer" placeholder="Search customer...">
        </div>

        <div class="customer-list">
            <%
              if(con != null) {
                  try {
                      PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE user_id=?");
                      ps.setInt(1, uid);
                      ResultSet rs = ps.executeQuery();
                      while(rs.next()){
                          int cid2 = rs.getInt("id");
                          String cname = rs.getString("name");
                          if(cname == null || cname.isEmpty()) cname = "Unknown";
                          
                          PreparedStatement balPS = con.prepareStatement(
                           "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) b FROM transactions WHERE customer_id=?"
                          );
                          balPS.setInt(1, cid2);
                          ResultSet balRS = balPS.executeQuery();
                          double b = 0; if(balRS.next()) b = balRS.getDouble("b");
                          overallBalance += b;
                          
                          String currentCid = request.getParameter("cid");
                          boolean isActive = (currentCid != null && currentCid.equals(String.valueOf(cid2)));
            %>
            <a href="dashboard.jsp?cid=<%=cid2%>" class="customer-card <%=isActive ? "active" : ""%>" data-name="<%=cname.toLowerCase()%>">
                <div class="customer-avatar"><%= cname.substring(0, 1).toUpperCase() %></div>
                <div class="customer-details">
                    <div class="customer-name"><%=cname%></div>
                    <div class="customer-balance <%= b >= 0 ? "balance-positive" : "balance-negative" %>">
                        <%= b >= 0 ? "You'll get" : "You'll give" %>: ₹<%=Math.abs(b)%>
                    </div>
                </div>
                <i class="fa-solid fa-chevron-right text-muted" style="font-size:0.8rem;"></i>
            </a>
            <% 
                          balRS.close(); balPS.close();
                      } 
                      rs.close(); ps.close();
                  } catch (Exception e) {}
              } 
            %>
        </div>
    </div>

    <!-- Main Content -->
    <div id="main-content">
        <!-- Top Bar -->
        <div class="main-header">
            <div class="d-flex align-items-center">
                <button class="btn btn-outline-primary d-lg-none me-3 menu-toggle" onclick="document.getElementById('sidebar').classList.toggle('show')">
                    <i class="fa-solid fa-bars"></i>
                </button>
                <div class="header-info">
                    <% 
                        String cidStr = request.getParameter("cid");
                        if(cidStr == null) {
                    %>
                        <h4>Welcome, <%=userName%></h4>
                    <% } else { 
                        // We fetch customer name in the code below, but we show a placeholder for now
                    %>
                        <h4 id="activeCustomerName">Loading...</h4>
                    <% } %>
                </div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-md-block">
                    <div class="small text-muted">Overall Balance</div>
                    <div class="fw-bold <%= overallBalance >= 0 ? "text-success" : "text-danger" %>">₹<%=String.format("%.2f", overallBalance)%></div>
                </div>
            </div>
        </div>

        <!-- Transactions Area -->
        <div class="transaction-container">
            <% if (dbError != null) { %>
                <div class="alert alert-danger mx-auto mt-4" style="max-width:500px">
                    <b>Database Error:</b> <%= dbError %>
                    <br><a href="test-db.jsp">Run Diagnostics</a>
                </div>
            <% } %>

            <%
                if (con != null) {
                    try {
                        if(cidStr == null) {
            %>
                <div class="empty-state">
                    <i class="fa-solid fa-wallet"></i>
                    <h3>Select a customer to track cash</h3>
                    <p>Track your receivables and payables effortlessly.</p>
                </div>
            <% } else { 
                int cid = Integer.parseInt(cidStr);
                String cName = ""; double cTotal = 0;
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
                <script>document.getElementById('activeCustomerName').innerText = '<%=cName%>';</script>
                
                <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 rounded-3 shadow-sm">
                    <div>
                        <div class="text-muted small">Current Balance</div>
                        <h3 class="<%= cTotal >= 0 ? "balance-positive" : "balance-negative" %> fw-bold m-0">₹<%=Math.abs(cTotal)%></h3>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-outline-info me-2" onclick="openEditCustomer('<%=cid%>','<%=cName%>','')"><i class="fa-solid fa-pen"></i></button>
                        <button class="btn btn-sm btn-outline-danger" onclick="deleteCustomer('<%=cid%>')"><i class="fa-solid fa-trash"></i></button>
                    </div>
                </div>

                <div class="txn-list">
                    <%
                        PreparedStatement tps = con.prepareStatement("SELECT * FROM transactions WHERE customer_id=? ORDER BY date DESC");
                        tps.setInt(1, cid); ResultSet trs = tps.executeQuery();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, hh:mm a");
                        boolean hasTxns = false;
                        while(trs.next()){
                            hasTxns = true;
                            String type = trs.getString("type");
                    %>
                    <div class="txn-card">
                        <div class="txn-main">
                            <div class="txn-icon <%= "got".equals(type) ? "icon-got" : "icon-gave" %>">
                                <i class="fa-solid <%= "got".equals(type) ? "fa-arrow-down" : "fa-arrow-up" %>"></i>
                            </div>
                            <div class="txn-text">
                                <div class="note"><%= trs.getString("note") != null ? trs.getString("note") : "Transaction" %></div>
                                <div class="date"><%= trs.getTimestamp("date") != null ? sdf.format(new java.util.Date(trs.getTimestamp("date").getTime())) : "-" %></div>
                            </div>
                        </div>
                        <div class="txn-amount">
                            <div class="amount-val <%= "got".equals(type) ? "balance-positive" : "balance-negative" %>">
                                <%= "got".equals(type) ? "+" : "-" %> ₹<%=String.format("%.2f", trs.getDouble("amount"))%>
                            </div>
                            <div class="amount-type text-muted"><%= "got".equals(type) ? "Received" : "Paid" %></div>
                        </div>
                    </div>
                    <% } 
                        if(!hasTxns){
                    %>
                        <div class="empty-state">
                            <i class="fa-solid fa-receipt"></i>
                            <h5>No transactions yet</h5>
                            <p>Click the + button to add your first transaction.</p>
                        </div>
                    <%
                        }
                        trs.close(); tps.close(); 
                    %>
                </div>

                <button class="fab" data-bs-toggle="modal" data-bs-target="#addTxnModal">
                    <i class="fa-solid fa-plus"></i>
                </button>
            <% } 
                    } catch (Exception e) { out.println("<div class='alert alert-warning'>Error: " + e.getMessage() + "</div>"); }
                } 
            %>
        </div>
    </div>
</div>

<!-- Modals -->
<div class="modal fade" id="addCustomerModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5 class="fw-bold">New Customer</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><form action="AddCustomerServlet" method="post"><div class="modal-body"><div class="mb-3"><label class="form-label">Full Name</label><input type="text" name="name" class="form-control" placeholder="Enter customer name" required></div><div class="mb-3"><label class="form-label">Phone Number</label><input type="text" name="phone" class="form-control" placeholder="Optional"></div></div><div class="modal-footer"><button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Save Customer</button></div></form></div></div></div>

<% if(request.getParameter("cid") != null) { %>
<div class="modal fade" id="addTxnModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header border-0 pb-0"><h5 class="fw-bold">Add Transaction</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><form action="AddTransactionServlet" method="post"><div class="modal-body"><input type="hidden" name="cid" value="<%=request.getParameter("cid")%>"><div class="mb-4"><label class="form-label small text-muted">Amount (₹)</label><input type="number" name="amount" class="form-control form-control-lg fw-bold" placeholder="0.00" required></div><div class="mb-4"><label class="form-label small text-muted">Note / Description</label><input type="text" name="note" class="form-control" placeholder="What is this for?"></div><div class="row g-2"><div class="col-6"><button type="submit" name="type" value="gave" class="btn btn-outline-danger w-100 py-3 fw-bold">I PAID</button></div><div class="col-6"><button type="submit" name="type" value="got" class="btn btn-primary w-100 py-3 fw-bold">I RECEIVED</button></div></div></div></form></div></div></div>
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
    function deleteCustomer(id) { if(confirm("Delete this customer and all their transactions?")) window.location.href="DeleteCustomerServlet?cid="+id; }
    
    // Search Customer
    document.getElementById('searchCustomer').addEventListener('input', function(e) {
        let q = e.target.value.toLowerCase();
        document.querySelectorAll('.customer-card').forEach(card => {
            card.style.display = card.dataset.name.includes(q) ? 'flex' : 'none';
        });
    });
</script>
</body>
</html>
<% if (con != null) { try { con.close(); } catch(Exception e)<% if (con != null) { try { con.close(); } catch(Exception e) {} } %>
 {} } %>