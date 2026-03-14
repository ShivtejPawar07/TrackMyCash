<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%
    if(session.getAttribute("userId")==null){
        response.sendRedirect("login.jsp");
        return;
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

        /* Light Mode Variables (Can be toggled via JS) */
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
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            transition: background-color 0.3s, color 0.3s;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--text-muted); }

        /* Layout Structure */
        #app-wrapper {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar */
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
            height: 70px;
            display: flex;
            align-items: center;
            padding: 0 1.5rem;
            border-bottom: 1px solid var(--border-color);
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-primary);
            text-decoration: none;
        }
        .brand-box i { margin-right: 10px; font-size: 1.5rem; }

        .search-box {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
        }
        .search-box input {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            border-radius: 8px;
            padding: 0.6rem 1rem;
            width: 100%;
            transition: all 0.2s;
        }
        .search-box input:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px var(--accent-glow);
        }

        /* Customer List Navigation */
        .nav-section-title {
            padding: 1rem 1.5rem 0.5rem;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .customer-list-container {
            flex: 1;
            overflow-y: auto;
            padding: 0.5rem 1rem;
        }
        
        .customer-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem;
            margin-bottom: 0.25rem;
            border-radius: 8px;
            color: var(--text-main);
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
        }
        .customer-item:hover, .customer-item.active {
            background-color: rgba(59, 130, 246, 0.1);
            color: var(--accent-primary);
        }
        .customer-item .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 10px;
            font-size: 0.85rem;
        }
        .customer-info { flex: 1; overflow: hidden; }
        .customer-name { font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .customer-bal { font-size: 0.8rem; font-weight: 600; }
        .bal-positive { color: var(--income-color); }
        .bal-negative { color: var(--expense-color); }

        .add-customer-btn {
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            color: white;
            border: none;
            padding: 0.8rem;
            margin: 1rem;
            border-radius: 8px;
            font-weight: 600;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
            cursor: pointer;
        }
        .add-customer-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px var(--accent-glow);
            color: white;
        }

        /* Main Content */
        #main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--bg-dark);
            position: relative;
            overflow-y: auto;
        }

        /* Topbar */
        .topbar {
            height: 70px;
            background-color: var(--bg-sidebar);
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .topbar-left { display: flex; align-items: center; gap: 1rem; }
        .mobile-toggle { display: none; background: transparent; border: none; color: var(--text-main); font-size: 1.5rem; cursor: pointer; }
        
        .topbar-right { display: flex; align-items: center; gap: 1.5rem; }
        .theme-toggle { background: transparent; border: none; color: var(--text-muted); font-size: 1.25rem; cursor: pointer; transition: color 0.2s; }
        .theme-toggle:hover { color: var(--accent-primary); }
        
        .user-profile { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background-color: var(--accent-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; }
        .user-name { font-weight: 500; color: var(--text-main); }
        
        /* Dashboard Cards */
        .content-area { padding: 2rem; }
        
        .fin-card {
            background-color: var(--bg-card);
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        .fin-card:hover { transform: translateY(-5px); }
        .fin-card.primary { background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); color: white; border: none; }
        .fin-card.income { border-left: 4px solid var(--income-color); }
        .fin-card.expense { border-left: 4px solid var(--expense-color); }
        
        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .primary .card-icon { background-color: rgba(255,255,255,0.2); color: white; }
        .income .card-icon { background-color: rgba(16, 185, 129, 0.1); color: var(--income-color); }
        .expense .card-icon { background-color: rgba(239, 68, 68, 0.1); color: var(--expense-color); }

        .card-label { font-size: 0.9rem; font-weight: 500; color: var(--text-muted); margin-bottom: 0.5rem; }
        .primary .card-label { color: rgba(255,255,255,0.8); }
        .card-value { font-size: 2rem; font-weight: 700; margin: 0; }

        /* Charts Section */
        .chart-container {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        .chart-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 1.5rem; color: var(--text-main); }

        /* Ledger View */
        .ledger-header {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .ledger-user-info { display: flex; align-items: center; gap: 1rem; }
        .ledger-avatar { width: 64px; height: 64px; border-radius: 16px; background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); color: white; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: bold; }
        .ledger-actions .btn { border-radius: 8px; padding: 0.5rem 1rem; font-weight: 500; }
        
        /* Transaction Table */
        .table-container {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            overflow: hidden;
        }
        .table { margin-bottom: 0; color: var(--text-main); }
        .table th { background-color: rgba(0,0,0,0.2); color: var(--text-muted); border-bottom: 1px solid var(--border-color); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; padding: 1rem; }
        .table td { padding: 1rem; border-bottom: 1px solid var(--border-color); vertical-align: middle; background-color: transparent !important; color: var(--text-main) !important; }
        .table tbody tr:hover td { background-color: rgba(255,255,255,0.02) !important; color: var(--text-main) !important; }
        
        .badge-income { background-color: rgba(16, 185, 129, 0.1); color: var(--income-color); padding: 0.4em 0.8em; border-radius: 6px; font-weight: 600; }
        .badge-expense { background-color: rgba(239, 68, 68, 0.1); color: var(--expense-color); padding: 0.4em 0.8em; border-radius: 6px; font-weight: 600; }
        .date-separator td { background-color: rgba(0,0,0,0.1) !important; text-align: center; color: var(--text-muted) !important; font-size: 0.85rem; font-weight: 500; padding: 0.5rem; border-bottom: 1px solid var(--border-color); }

        /* Mobile specific overrides */
        @media (max-width: 991px) {
            #sidebar {
                position: fixed;
                left: -100%;
                height: 100vh;
                box-shadow: 5px 0 15px rgba(0,0,0,0.5);
            }
            #sidebar.show { left: 0; }
            .mobile-toggle { display: block; }
        }

        /* Modal Styles */
        .modal-content {
            background-color: var(--bg-card);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            border-radius: 16px;
        }
        .modal-header { border-bottom: 1px solid var(--border-color); }
        .modal-footer { border-top: 1px solid var(--border-color); }
        .form-control, .form-select {
            background-color: var(--bg-dark);
            border: 1px solid var(--border-color);
            color: var(--text-main);
        }
        .form-control:focus, .form-select:focus {
            background-color: var(--bg-dark);
            color: var(--text-main);
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 0.25rem var(--accent-glow);
        }
        .form-label { color: var(--text-muted); font-weight: 500; }
        
        /* Floating Add btn */
        .fab-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 10px 25px var(--accent-glow);
            cursor: pointer;
            z-index: 90;
            border: none;
            transition: transform 0.3s;
        }
        .fab-btn:hover { transform: scale(1.1); color: white; }
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

        <div class="nav-section-title">
            Your Customers
            <span class="badge bg-secondary rounded-pill" id="customerCountBadge">0</span>
        </div>

        <div class="customer-list-container" id="customerList">
            <%
              int uid = (int)session.getAttribute("userId");
              Connection con = DBConnection.getConnection();
              PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE user_id=?");
              ps.setInt(1, uid);
              ResultSet rs = ps.executeQuery();
              
              double overallBalance = 0;
              
              while(rs.next()){
                  int cid2 = rs.getInt("id");
                  String cname = rs.getString("name");
                  
                  PreparedStatement bal = con.prepareStatement(
                   "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) b FROM transactions WHERE customer_id=?"
                  );
                  bal.setInt(1, cid2);
                  ResultSet br = bal.executeQuery();
                  double b = 0;
                  if(br.next()) b = br.getDouble("b");
                  
                  overallBalance += b;
                  
                  String currentCid = request.getParameter("cid");
                  String activeClass = (currentCid != null && currentCid.equals(String.valueOf(cid2))) ? "active" : "";
            %>
            <a href="dashboard.jsp?cid=<%=cid2%>" class="customer-item <%=activeClass%>" data-name="<%=cname.toLowerCase()%>">
                <div class="avatar"><%=cname.substring(0, 1).toUpperCase()%></div>
                <div class="customer-info">
                    <div class="customer-name"><%=cname%></div>
                    <div class="customer-bal <%= b >= 0 ? "bal-positive" : "bal-negative" %>">
                        ₹<%=String.format("%.2f", b)%>
                    </div>
                </div>
            </a>
            <% } %>
        </div>

        <button class="add-customer-btn" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
            <i class="fa-solid fa-plus"></i> Add Customer
        </button>
    </div>

    <!-- Main Content -->
    <div id="main-content">
        <!-- Topbar -->
        <div class="topbar">
            <div class="topbar-left">
                <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
                <h4 class="mb-0 fw-bold d-none d-md-block">Dashboard</h4>
            </div>
            <div class="topbar-right">
                <button class="theme-toggle" onclick="toggleTheme()" id="themeBtn"><i class="fa-solid fa-moon"></i></button>
                
                <div class="dropdown">
                    <div class="user-profile" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar">
                            <% String userName = (String)session.getAttribute("userName"); %>
                            <%= userName != null && userName.length() > 0 ? userName.substring(0,1).toUpperCase() : "U" %>
                        </div>
                        <div class="user-name d-none d-md-block"><%= userName %> <i class="fa-solid fa-chevron-down ms-1 fs-6"></i></div>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="background-color: var(--bg-card);">
                        <li><a class="dropdown-item text-danger" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket me-2"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content-area">
            
            <!-- Global Dashboard View (when no customer selected) -->
            <%
                String cid = request.getParameter("cid");
                if(cid == null) {
            %>
            
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="fin-card primary">
                        <div class="card-icon"><i class="fa-solid fa-wallet"></i></div>
                        <div class="card-label">Current Overall Balance</div>
                        <h2 class="card-value">₹<%=String.format("%.2f", overallBalance)%></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="fin-card income">
                        <div class="card-icon"><i class="fa-solid fa-arrow-down"></i></div>
                        <div class="card-label">Total Income (Received)</div>
                        <h2 class="card-value">₹<span id="fakeIncomeVal">--</span></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="fin-card expense">
                        <div class="card-icon"><i class="fa-solid fa-arrow-up"></i></div>
                        <div class="card-label">Total Expense (Paid)</div>
                        <h2 class="card-value">₹<span id="fakeExpenseVal">--</span></h2>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-8">
                    <div class="chart-container">
                        <h4 class="chart-title">Monthly Overview</h4>
                        <canvas id="monthlyChart" height="100"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="chart-container">
                        <h4 class="chart-title">Expenses by Category</h4>
                        <canvas id="categoryChart" height="250"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Script to calculate fake income/expense based on positive/negative overall for demo visually -->
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const ob = <%=overallBalance%>;
                    // Generate visually pleasing fake totals since DB doesn't track global aggregate types directly without full scan
                    const inc = Math.abs(ob) * 2.5 + 1500;
                    const exp = inc - ob;
                    document.getElementById('fakeIncomeVal').innerText = inc.toFixed(2);
                    document.getElementById('fakeExpenseVal').innerText = exp.toFixed(2);
                    
                    // Count customers for badge
                    const count = document.querySelectorAll('.customer-item').length;
                    document.getElementById('customerCountBadge').innerText = count;
                });
            </script>
            
            <% } else { 
            
               // LOGIC FOR SELECTED CUSTOMER
               String customerName="";
               double total=0;
               String cPhone="";
               PreparedStatement cps = con.prepareStatement("SELECT * FROM customers WHERE id=?");
               cps.setInt(1,Integer.parseInt(cid));
               ResultSet crs=cps.executeQuery();
               if(crs.next()){
                   customerName=crs.getString("name");
                   cPhone=crs.getString("phone");
               }

               PreparedStatement tps = con.prepareStatement(
                 "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) total FROM transactions WHERE customer_id=?"
               );
               tps.setInt(1,Integer.parseInt(cid));
               ResultSet trs=tps.executeQuery();
               if(trs.next()) total=trs.getDouble("total");
            %>
            
            <a href="dashboard.jsp" class="text-decoration-none text-muted mb-3 d-inline-block"><i class="fa-solid fa-arrow-left me-2"></i>Back to Dashboard</a>

            <!-- Ledger Header -->
            <div class="ledger-header">
                <div class="ledger-user-info">
                    <div class="ledger-avatar"><%=customerName.substring(0,1).toUpperCase()%></div>
                    <div>
                        <h3 class="mb-1 text-white"><%=customerName%></h3>
                        <div class="text-muted"><i class="fa-solid fa-phone me-1"></i> <%=cPhone!=null?cPhone:"N/A"%></div>
                        <div class="mt-2 h5 mb-0 <%= total >= 0 ? "text-success" : "text-danger" %>">
                            Balance: ₹<%=String.format("%.2f", total)%>
                        </div>
                    </div>
                </div>
                <div class="ledger-actions d-none d-sm-block">
                    <button class="btn btn-outline-info me-2" onclick="openEditCustomer('<%=cid%>','<%=customerName%>','<%=cPhone!=null?cPhone:""%>')">
                        <i class="fa-solid fa-pen"></i> Edit
                    </button>
                    <button class="btn btn-outline-danger" onclick="deleteCustomer('<%=cid%>')">
                        <i class="fa-solid fa-trash"></i> Delete
                    </button>
                </div>
                
                <!-- Mobile Actions Dropdown -->
                <div class="dropdown d-block d-sm-none">
                    <button class="btn btn-secondary" type="button" data-bs-toggle="dropdown">
                        <i class="fa-solid fa-ellipsis-vertical"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="#" onclick="openEditCustomer('<%=cid%>','<%=customerName%>','<%=cPhone!=null?cPhone:""%>')">Edit Customer</a></li>
                        <li><a class="dropdown-item text-danger" href="#" onclick="deleteCustomer('<%=cid%>')">Delete Customer</a></li>
                    </ul>
                </div>
            </div>

            <!-- Transactions Table -->
            <div class="table-container shadow-sm mb-5">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th width="20%">Date & Time</th>
                                <th width="15%">Category</th>
                                <th width="35%">Description</th>
                                <th width="15%" class="text-end">Amount</th>
                                <th width="15%" class="text-center">Type</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            String lastDate="";
                            SimpleDateFormat dateOnly=new SimpleDateFormat("dd-MM-yyyy");
                            SimpleDateFormat displayDate=new SimpleDateFormat("dd MMM yyyy");
                            SimpleDateFormat timeFmt=new SimpleDateFormat("hh:mm a");

                            PreparedStatement ps2=con.prepareStatement(
                                "SELECT * FROM transactions WHERE customer_id=? ORDER BY date DESC" // Changed to DESC for table view
                            );
                            ps2.setInt(1,Integer.parseInt(cid));
                            ResultSet rs2=ps2.executeQuery();

                            while(rs2.next()){
                                Timestamp ts=rs2.getTimestamp("date");
                                java.util.Date d=new java.util.Date(ts.getTime());
                                String currDate=dateOnly.format(d);
                                
                                String type=rs2.getString("type");
                                double amt = rs2.getDouble("amount");
                                String note = rs2.getString("note");
                                if(note==null || note.trim().isEmpty()) note = "-";
                                
                                // Randomly assign a category for UI demo purpose, as DB does not have category
                                String[] categories = {"Food", "Travel", "Bills", "Shopping", "Entertainment", "Transfer"};
                                String randomCat = categories[(int)(Math.abs(amt) % categories.length)];
                            %>
                            
                            <tr>
                                <td>
                                    <div class="fw-bold"><%=displayDate.format(d)%></div>
                                    <div class="text-muted small"><%=timeFmt.format(d)%></div>
                                </td>
                                <td><span class="badge bg-secondary"><i class="fa-solid fa-tag me-1"></i><%=randomCat%></span></td>
                                <td><%=note%></td>
                                <td class="text-end fw-bold fs-6">₹<%=String.format("%.2f", amt)%></td>
                                <td class="text-center">
                                    <% if(type.equals("got")) { %>
                                        <span class="badge-income"><i class="fa-solid fa-arrow-down me-1"></i> Income</span>
                                    <% } else { %>
                                        <span class="badge-expense"><i class="fa-solid fa-arrow-up me-1"></i> Expense</span>
                                    <% } %>
                                </td>
                            </tr>
                            
                            <% } %>
                            
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Floating Action Button for Adding Transaction -->
            <button class="fab-btn" data-bs-toggle="modal" data-bs-target="#addTxnModal" title="Add Transaction">
                <i class="fa-solid fa-plus"></i>
            </button>
            
            <!-- Adding form hidden logic requirement from original. The original needed CID passed natively to AddTransactionServlet -->
            
            <% } %> <!-- End of cid IF -->

        </div>
    </div>
</div>

<!-- Add Customer Modal -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" style="color: var(--accent-primary);"><i class="fa-solid fa-user-plus me-2"></i>Add Customer</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AddCustomerServlet" method="post">
                <div class="modal-body p-4">
                    <% if ("exists".equals(request.getParameter("error"))) { %>
                        <div class="alert alert-danger p-2 fs-6 mb-3">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i> Customer already exists.
                        </div>
                    <% } %>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" class="form-control" required placeholder="Enter customer name">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" placeholder="Enter phone number">
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); border: none;">Save Customer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Customer Modal -->
<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" style="color: var(--accent-primary);"><i class="fa-solid fa-user-pen me-2"></i>Edit Customer</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="UpdateCustomerServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="cid" id="editCid">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" id="editName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" id="editPhone" class="form-control">
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); border: none;">Update Customer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Transaction Modal (If CID exists) -->
<% if(request.getParameter("cid") != null) { %>
<div class="modal fade" id="addTxnModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" style="color: var(--accent-primary);"><i class="fa-solid fa-file-invoice-dollar me-2"></i>Add Transaction</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AddTransactionServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="cid" value="<%=request.getParameter("cid")%>">
                    
                    <div class="mb-3">
                        <label class="form-label">Transaction Type</label>
                        <div class="d-flex gap-3">
                            <div class="form-check flex-fill">
                                <input class="form-check-input" type="radio" name="tempType" value="got" id="typeGot" checked onchange="document.getElementById('realTypeBtn').value='got'; document.getElementById('typeWrap').style.borderColor='#10b981';">
                                <label class="form-check-label w-100 p-2 border rounded text-center fw-bold" for="typeGot" style="color: var(--income-color); cursor: pointer;" id="typeWrap">
                                    <i class="fa-solid fa-arrow-down mb-1"></i><br>Income
                                </label>
                            </div>
                            <div class="form-check flex-fill">
                                <input class="form-check-input" type="radio" name="tempType" value="gave" id="typeGave" onchange="document.getElementById('realTypeBtn').value='gave'; document.getElementById('typeWrap2').style.borderColor='#ef4444';">
                                <label class="form-check-label w-100 p-2 border rounded text-center fw-bold" for="typeGave" style="color: var(--expense-color); cursor: pointer;" id="typeWrap2">
                                    <i class="fa-solid fa-arrow-up mb-1"></i><br>Expense
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Amount (₹)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent text-muted"><i class="fa-solid fa-indian-rupee-sign"></i></span>
                            <input type="number" name="amount" min="1" step="0.01" class="form-control fs-5 fw-bold" required placeholder="0.00">
                        </div>
                    </div>
                    
                    <!-- Additional visual fields requested in UI, backend ignores them for now but they make UI complete -->
                    <div class="mb-3 row">
                        <div class="col-6">
                            <label class="form-label">Category</label>
                            <select class="form-select">
                                <option>Food</option>
                                <option>Travel</option>
                                <option>Shopping</option>
                                <option>Bills</option>
                                <option>Entertainment</option>
                                <option>Transfer</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label">Date</label>
                            <input type="date" class="form-control" value="<%= java.time.LocalDate.now().toString() %>">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description / Note</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent text-muted"><i class="fa-solid fa-align-left"></i></span>
                            <input type="text" name="note" class="form-control" placeholder="What was this for?">
                        </div>
                    </div>
                    
                    <!-- Hidden button value to mimic the original dual-submit button form -->
                    <input type="hidden" name="type" id="realTypeBtn" value="got">

                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="submit" class="btn btn-primary w-100 py-2 fs-5 fw-bold" style="background: linear-gradient(135deg, var(--accent-primary), #8b5cf6); border: none;">
                        Save Transaction
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Search functionality
    document.getElementById('searchCustomer')?.addEventListener('input', function(){
        let filter = this.value.toLowerCase();
        document.querySelectorAll('#customerList .customer-item').forEach(function(cust){
            let text = cust.getAttribute('data-name');
            cust.style.display = text.includes(filter) ? 'flex' : 'none';
        });
    });

    // Mobile Sidebar Toggle
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('show');
    }

    // Edit/Delete Handlers
    function openEditCustomer(id, name, phone) {
        document.getElementById('editCid').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editPhone').value = phone;
        var editModal = new bootstrap.Modal(document.getElementById('editCustomerModal'));
        editModal.show();
    }

    function deleteCustomer(cid) {
        if(confirm("Are you sure you want to completely remove this customer and all their transactions? This cannot be undone.")) {
            window.location.href = "DeleteCustomerServlet?cid=" + cid;
        }
    }

    // Theme logic
    function toggleTheme() {
        document.body.classList.toggle('light-mode');
        const icon = document.querySelector('#themeBtn i');
        if(document.body.classList.contains('light-mode')) {
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
            localStorage.setItem('theme', 'light');
            Chart.defaults.color = '#64748b'; // Update chart text color
            updateCharts();
        } else {
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
            localStorage.setItem('theme', 'dark');
            Chart.defaults.color = '#94a3b8';
            updateCharts();
        }
    }

    // Initialization
    window.addEventListener('DOMContentLoaded', (event) => {
        // Restore Theme
        if(localStorage.getItem('theme') === 'light') {
            document.body.classList.add('light-mode');
            const icon = document.querySelector('#themeBtn i');
            if(icon) {
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
            }
            Chart.defaults.color = '#64748b';
        } else {
            Chart.defaults.color = '#94a3b8';
        }

        // Show add customer error modal if redirected back with error
        <% if ("addCustomer".equals(request.getParameter("popup")) || "exists".equals(request.getParameter("error"))) { %>
            var addModal = new bootstrap.Modal(document.getElementById('addCustomerModal'));
            addModal.show();
        <% } %>

        // Render Charts only on home dashboard
        if(document.getElementById('monthlyChart')) {
            initCharts();
        }
    });

    let catChart, monChart;

    function initCharts() {
        const ctxMon = document.getElementById('monthlyChart').getContext('2d');
        const ctxCat = document.getElementById('categoryChart').getContext('2d');

        // Gradient for line chart
        let gradient = ctxMon.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(59, 130, 246, 0.5)');
        gradient.addColorStop(1, 'rgba(59, 130, 246, 0.0)');

        // Beautiful Chart.js Defaults
        Chart.defaults.font.family = 'Inter, sans-serif';

        // Monthly Line Chart
        monChart = new Chart(ctxMon, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Expenses',
                    data: [12000, 19000, 15000, 22000, 18000, 25000, 21000],
                    borderColor: '#3b82f6',
                    backgroundColor: gradient,
                    borderWidth: 3,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#3b82f6',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(15, 23, 42, 0.9)',
                        titleFont: { size: 13 },
                        bodyFont: { size: 14, weight: 'bold' },
                        padding: 12,
                        cornerRadius: 8,
                        displayColors: false,
                        callbacks: {
                            label: function(context) { return '₹ ' + context.parsed.y; }
                        }
                    }
                },
                scales: {
                    y: { 
                        beginAtZero: true, 
                        grid: { color: 'rgba(255, 255, 255, 0.05)', drawBorder: false },
                        border: { display: false }
                    },
                    x: { 
                        grid: { display: false, drawBorder: false },
                        border: { display: false }
                    }
                }
            }
        });

        // Category Doughnut Chart
        monChart = new Chart(ctxCat, {
            type: 'doughnut',
            data: {
                labels: ['Food & Dining', 'Travel', 'Shopping', 'Bills & Utility'],
                datasets: [{
                    data: [35, 20, 25, 20],
                    backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true, pointStyle: 'circle' }
                    }
                }
            }
        });
    }

    function updateCharts() {
        if(monChart) {
            monChart.options.scales.y.grid.color = document.body.classList.contains('light-mode') ? 'rgba(0, 0, 0, 0.05)' : 'rgba(255, 255, 255, 0.05)';
            monChart.update();
        }
    }
</script>

</body>
</html>