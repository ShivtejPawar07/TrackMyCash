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
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-dark: #020617;
            --sidebar-bg: rgba(15, 23, 42, 0.8);
            --content-bg: rgba(15, 23, 42, 0.4);
            --accent-cyan: #06b6d4;
            --accent-purple: #8b5cf6;
            --accent-green: #10b981;
            --accent-red: #ef4444;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --glass-border: rgba(255, 255, 255, 0.05);
            --sidebar-width: 350px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Rajdhani', sans-serif;
            background: radial-gradient(circle at bottom left, #0f172a, #020617);
            color: var(--text-primary);
            height: 100vh;
            overflow: hidden;
        }

        #app-wrapper {
            display: flex;
            height: 100vh;
            position: relative;
        }

        /* Sidebar Styles */
        #sidebar {
            width: var(--sidebar-width);
            background: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            z-index: 1000;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-header {
            padding: 25px;
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.1), transparent);
            border-bottom: 1px solid var(--glass-border);
        }

        .sidebar-header h5 {
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 2px;
            text-transform: uppercase;
            font-size: 1.1rem;
            margin: 0;
        }

        .search-container {
            padding: 15px 25px;
            background: rgba(15, 23, 42, 0.2);
        }

        .search-bar {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 15px;
            width: 100%;
            outline: none;
            color: var(--text-primary);
            transition: all 0.3s;
        }

        .search-bar:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 10px rgba(6, 182, 212, 0.2);
        }

        .customer-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px 0;
        }

        .customer-list::-webkit-scrollbar { width: 5px; }
        .customer-list::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        .customer-card {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            margin-bottom: 2px;
        }

        .customer-card:hover {
            background: rgba(255, 255, 255, 0.03);
            padding-left: 30px;
        }

        .customer-card.active {
            background: linear-gradient(90deg, rgba(6, 182, 212, 0.1), transparent);
            border-left-color: var(--accent-cyan);
        }

        .customer-avatar {
            width: 48px;
            height: 48px;
            background: linear-gradient(45deg, var(--accent-cyan), var(--accent-purple));
            color: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-family: 'Orbitron', sans-serif;
            margin-right: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        .customer-details { flex: 1; }
        .customer-name { font-weight: 600; font-size: 1.1rem; letter-spacing: 0.5px; }
        .customer-balance { font-size: 0.9rem; margin-top: 2px; }

        .balance-positive { color: var(--accent-green); text-shadow: 0 0 8px rgba(16, 185, 129, 0.3); }
        .balance-negative { color: var(--accent-red); text-shadow: 0 0 8px rgba(239, 68, 68, 0.3); }

        /* Main Content Styles */
        #main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: var(--content-bg);
            position: relative;
        }

        .main-header {
            padding: 20px 30px;
            background: rgba(15, 23, 42, 0.3);
            border-bottom: 1px solid var(--glass-border);
            backdrop-filter: blur(10px);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-info h4 {
            font-family: 'Orbitron', sans-serif;
            margin: 0;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .transaction-container {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background: radial-gradient(circle at center, rgba(6, 182, 212, 0.02) 0%, transparent 80%);
        }

        /* Transaction Card Styles */
        .txn-card {
            background: rgba(255, 255, 255, 0.02);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .txn-card:hover {
            transform: scale(1.02);
            background: rgba(255, 255, 255, 0.04);
            border-color: rgba(6, 182, 212, 0.3);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .txn-main { display: flex; align-items: center; }

        .txn-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 1.2rem;
        }

        .icon-got { background: rgba(16, 185, 129, 0.1); color: var(--accent-green); border: 1px solid rgba(16, 185, 129, 0.2); }
        .icon-gave { background: rgba(239, 68, 68, 0.1); color: var(--accent-red); border: 1px solid rgba(239, 68, 68, 0.2); }

        .txn-text .note { font-weight: 600; font-size: 1.1rem; margin-bottom: 2px; }
        .txn-text .date { font-size: 0.85rem; color: var(--text-secondary); }

        .txn-amount { text-align: right; }
        .amount-val { font-family: 'Orbitron', sans-serif; font-weight: 700; font-size: 1.2rem; }
        .amount-type { font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; opacity: 0.7; }

        /* Floating Action Button */
        .fab {
            position: absolute;
            bottom: 40px;
            right: 40px;
            width: 70px;
            height: 70px;
            background: linear-gradient(45deg, var(--accent-cyan), var(--accent-purple));
            color: white;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            box-shadow: 0 10px 25px rgba(6, 182, 212, 0.4);
            cursor: pointer;
            border: none;
            transition: all 0.4s;
            z-index: 100;
        }

        .fab:hover { transform: translateY(-5px) rotate(90deg); box-shadow: 0 15px 35px rgba(6, 182, 212, 0.6); }

        /* Modals Redesign */
        .modal-content {
            background: #0f172a;
            border: 1px solid var(--accent-cyan);
            border-radius: 20px;
            color: var(--text-primary);
            box-shadow: 0 0 30px rgba(6, 182, 212, 0.2);
        }
        
        .modal-header { border-bottom: 1px solid var(--glass-border); padding: 25px; }
        .modal-footer { border-top: 1px solid var(--glass-border); padding: 20px; }
        
        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: white !important;
            padding: 12px;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.08);
            border-color: var(--accent-cyan);
            box-shadow: none;
        }

        /* Abstract Glow */
        .bg-pulse {
            position: absolute;
            width: 300px; height: 300px;
            background: var(--accent-cyan);
            opacity: 0.05;
            filter: blur(100px);
            z-index: -1;
            border-radius: 50%;
            animation: move-glow 20s infinite linear;
        }

        @keyframes move-glow {
            0% { top: 10%; left: 10%; }
            33% { top: 70%; left: 80%; }
            66% { top: 40%; left: 50%; }
            100% { top: 10%; left: 10%; }
        }

        @media (max-width: 991px) {
            #sidebar { position: fixed; left: -100%; height: 100vh; }
            #sidebar.show { left: 0; }
            .menu-toggle { display: block !important; }
        }

        .empty-state {
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            text-align: center;
        }

        .empty-state i { 
            font-size: 5rem; 
            margin-bottom: 25px; 
            background: linear-gradient(45deg, var(--accent-cyan), var(--accent-purple));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            opacity: 0.5; 
        }

    </style>
</head>
<body>

<div class="bg-pulse"></div>

<div id="app-wrapper">
    <!-- Sidebar -->
    <div id="sidebar">
        <div class="sidebar-header">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5>Accounts</h5>
                <a href="LogoutServlet" class="text-secondary hover-cyan" title="Logout"><i class="fa-solid fa-power-off"></i></a>
            </div>
            <button class="btn btn-primary w-100 fw-bold py-3 shadow-sm border-0" style="background: linear-gradient(45deg, var(--accent-cyan), var(--accent-blue));" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="fa-solid fa-plus-circle me-2"></i>ADD NEW ENTITY
            </button>
        </div>
        
        <div class="search-container">
            <input type="text" class="search-bar" id="searchCustomer" placeholder="Filter identities...">
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
                        <%= b >= 0 ? "RECEIVABLE" : "PAYABLE" %>: ₹<%=Math.abs(b)%>
                    </div>
                </div>
                <i class="fa-solid fa-angle-right text-muted opacity-50"></i>
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
                <button class="btn btn-outline-cyan d-lg-none me-3 menu-toggle" onclick="document.getElementById('sidebar').classList.toggle('show')">
                    <i class="fa-solid fa-bars"></i>
                </button>
                <div class="header-info">
                    <% 
                        String cidStr = request.getParameter("cid");
                        if(cidStr == null) {
                    %>
                        <h4>COMMAND CENTER</h4>
                    <% } else { %>
                        <h4 id="activeCustomerName">INITIALIZING...</h4>
                    <% } %>
                </div>
            </div>
            <div class="d-flex align-items-center gap-4">
                <div class="text-end d-none d-md-block">
                    <div class="small text-secondary fw-bold" style="letter-spacing: 1px;">TOTAL PORTFOLIO</div>
                    <div class="amount-val <%= overallBalance >= 0 ? "balance-positive" : "balance-negative" %>" style="font-size: 1.5rem;">₹<%=String.format("%.2f", overallBalance)%></div>
                </div>
                <!-- User Profile Placeholder -->
                <div class="d-flex align-items-center bg-dark p-2 rounded-pill px-3 border border-secondary border-opacity-25">
                    <div class="small fw-bold me-2"><%=userName%></div>
                    <img src="https://ui-avatars.com/api/?name=<%=userName%>&background=06b6d4&color=fff&rounded=true&size=32" alt="Avatar">
                </div>
            </div>
        </div>

        <!-- Transactions Area -->
        <div class="transaction-container">
            <% if (dbError != null) { %>
                <div class="alert alert-danger" style="background: rgba(239, 68, 68, 0.1); border-color: var(--accent-red); border-radius: 12px;">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <b>System Failure:</b> <%= dbError %>
                    <hr>
                    <a href="test-db.jsp" class="btn btn-sm btn-danger">Run Diagnostics</a>
                </div>
            <% } %>

            <%
                if (con != null) {
                    try {
                        if(cidStr == null) {
            %>
                <div class="empty-state">
                    <i class="fa-solid fa-microchip"></i>
                    <h3>Welcome to FinanceOS</h3>
                    <p class="max-600">Please select an entity from the database to view transaction history and adjust balances.</p>
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
                <script>document.getElementById('activeCustomerName').innerText = '<%=cName.toUpperCase()%>';</script>
                
                <div class="d-flex justify-content-between align-items-center mb-5 p-4 rounded-4" style="background: linear-gradient(90deg, rgba(6, 182, 212, 0.1), transparent); border: 1px solid var(--glass-border);">
                    <div>
                        <div class="text-secondary small fw-bold mb-1" style="letter-spacing: 2px;">NET SETTLEMENT</div>
                        <h2 class="<%= cTotal >= 0 ? "balance-positive" : "balance-negative" %> fw-bold m-0" style="font-family: 'Orbitron', sans-serif; font-size: 2.5rem;">₹<%=Math.abs(cTotal)%></h2>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-info rounded-3" onclick="openEditCustomer('<%=cid%>','<%=cName%>','')"><i class="fa-solid fa-pen-nib me-2"></i>Update</button>
                        <button class="btn btn-outline-danger rounded-3" onclick="deleteCustomer('<%=cid%>')"><i class="fa-solid fa-trash-can me-2"></i>Purge</button>
                    </div>
                </div>

                <div class="txn-list">
                    <%
                        PreparedStatement tps = con.prepareStatement("SELECT * FROM transactions WHERE customer_id=? ORDER BY date DESC");
                        tps.setInt(1, cid); ResultSet trs = tps.executeQuery();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy • HH:mm");
                        boolean hasTxns = false;
                        while(trs.next()){
                            hasTxns = true;
                            String type = trs.getString("type");
                    %>
                    <div class="txn-card">
                        <div class="txn-main">
                            <div class="txn-icon <%= "got".equals(type) ? "icon-got" : "icon-gave" %>">
                                <i class="fa-solid <%= "got".equals(type) ? "fa-circle-arrow-down" : "fa-circle-arrow-up" %>"></i>
                            </div>
                            <div class="txn-text">
                                <div class="note"><%= trs.getString("note") != null && !trs.getString("note").isEmpty() ? trs.getString("note") : "LOG_ENTRY_" + trs.getInt("id") %></div>
                                <div class="date"><i class="fa-regular fa-clock me-1"></i><%= trs.getTimestamp("date") != null ? sdf.format(new java.util.Date(trs.getTimestamp("date").getTime())) : "-" %></div>
                            </div>
                        </div>
                        <div class="txn-amount">
                            <div class="amount-val <%= "got".equals(type) ? "balance-positive" : "balance-negative" %>">
                                <%= "got".equals(type) ? "+" : "-" %> ₹<%=String.format("%.2f", trs.getDouble("amount"))%>
                            </div>
                            <div class="amount-type"><%= "got".equals(type) ? "Verified Credit" : "Verified Debit" %></div>
                        </div>
                    </div>
                    <% } 
                        if(!hasTxns){
                    %>
                        <div class="empty-state">
                            <i class="fa-solid fa-database"></i>
                            <h5>Zero Activity Detected</h5>
                            <p>Initialize your first transaction for this entity using the terminal below.</p>
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
                    } catch (Exception e) { out.println("<div class='alert alert-warning'>Exception: " + e.getMessage() + "</div>"); }
                } 
            %>
        </div>
    </div>
</div>

<!-- Modals -->
<div class="modal fade" id="addCustomerModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5 class="fw-bold"><i class="fa-solid fa-user-plus me-2 text-cyan"></i>Register Identity</h5><button class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div><form action="AddCustomerServlet" method="post"><div class="modal-body p-4"><div class="mb-4"><label class="form-label small fw-bold">LEGAL NAME</label><input type="text" name="name" class="form-control" placeholder="Full name of entity" required></div><div class="mb-3"><label class="form-label small fw-bold">CONTACT CHANNEL</label><input type="text" name="phone" class="form-control" placeholder="Optional phone or email"></div></div><div class="modal-footer"><button type="submit" class="btn btn-cyan w-100 py-3 fw-bold" style="background: var(--accent-cyan); color: #020617;">CONFIRM REGISTRATION</button></div></form></div></div></div>

<% if(request.getParameter("cid") != null) { %>
<div class="modal fade" id="addTxnModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content border-info"><div class="modal-header"><h5 class="fw-bold"><i class="fa-solid fa-bolt me-2 text-cyan"></i>Execute Transaction</h5><button class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div><form action="AddTransactionServlet" method="post"><div class="modal-body p-4"><input type="hidden" name="cid" value="<%=request.getParameter("cid")%>"><div class="mb-4"><label class="form-label small fw-bold">CREDIT/DEBIT AMOUNT (₹)</label><input type="number" name="amount" class="form-control form-control-lg fw-bold" placeholder="0.00" step="0.01" required></div><div class="mb-4"><label class="form-label small fw-bold">TRANSACTION NOTE</label><input type="text" name="note" class="form-control" placeholder="Purpose of funds transfer"></div><div class="row g-3"><div class="col-6"><button type="submit" name="type" value="gave" class="btn btn-outline-danger w-100 py-3 fw-bold"><i class="fa-solid fa-minus me-1"></i>I PAID</button></div><div class="col-6"><button type="submit" name="type" value="got" class="btn btn-cyan w-100 py-3 fw-bold" style="background: var(--accent-cyan); color: #020617;"><i class="fa-solid fa-plus me-1"></i>I GOT</button></div></div></div></form></div></div></div>
<% } %>

<!-- Update Customer Modal is typically included via include but we should style it or ensure it matches -->
<%@ include file="UpdateCustomer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEditCustomer(id, name, phone) {
        document.getElementById('editCid').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editPhone').value = phone;
        new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
    }
    function deleteCustomer(id) { if(confirm("DANGER: Purging this entity will delete all associated financial logs. Proceed?")) window.location.href="DeleteCustomerServlet?cid="+id; }
    
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
<% if (con != null) { try { con.close(); } catch(Exception e) {} } %>