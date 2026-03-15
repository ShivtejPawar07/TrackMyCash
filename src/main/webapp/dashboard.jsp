<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%
    // Session Security Check
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    int uid = (int)session.getAttribute("userId");
    String userName = (String)session.getAttribute("userName");
    if (userName == null) userName = "User";

    Connection con = null;
    try {
        con = DBConnection.getConnection();
    } catch (Exception e) {
        // Handle connection error if needed
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackMyCash - Command Center</title>
    <!-- Bootstrap 5 CSS (Optional but helpful for modals) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #050b14;
            --accent-cyan: #00eaff;
            --accent-blue: #0099ff;
            --accent-purple: #8b5cf6;
            --accent-red: #ff4d6d;
            --glass-bg: rgba(255, 255, 255, 0.06);
            --glass-border: rgba(255, 255, 255, 0.1);
            --text-main: #e8fdff;
            --text-muted: #94a3b8;
        }

        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            margin: 0;
            height: 100vh;
            background: var(--bg-dark);
            color: var(--text-main);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* TOP NAVIGATION */
        .top-nav {
            padding: 15px 30px;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--glass-border);
            z-index: 100;
        }

        .top-nav h2 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }

        .top-nav .user-name {
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }

        .logout-btn {
            padding: 8px 20px;
            background: rgba(255, 77, 77, 0.15);
            border: 1px solid #ff4d4d;
            color: #ff4d4d;
            text-decoration: none;
            border-radius: 30px;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: #ff4d4d;
            color: #fff;
            box-shadow: 0 0 15px rgba(255, 77, 77, 0.4);
        }

        /* MAIN APP CONTAINER */
        .app-container {
            flex: 1;
            display: flex;
            height: calc(100vh - 70px);
        }

        /* SIDEBAR (LEFT) */
        .sidebar {
            width: 350px;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-header {
            padding: 25px;
            border-bottom: 1px solid var(--glass-border);
        }

        .sidebar-title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .sidebar-title-row h3 {
            margin: 0;
            color: var(--accent-cyan);
            font-size: 18px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .icon-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            font-size: 20px;
            cursor: pointer;
            transition: color 0.3s;
        }

        .icon-btn:hover { color: var(--accent-cyan); }

        #searchCustomer {
            width: 100%;
            padding: 12px 15px;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            outline: none;
            transition: all 0.3s;
        }

        #searchCustomer:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 10px rgba(0, 234, 255, 0.2);
        }

        /* CUSTOMER LIST */
        .customer-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .customer-list::-webkit-scrollbar { width: 5px; }
        .customer-list::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.1); border-radius: 10px; }

        .customer-item {
            padding: 15px 20px;
            margin-bottom: 8px;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .customer-item:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: var(--glass-border);
            transform: translateX(5px);
        }

        .customer-item.active {
            background: linear-gradient(90deg, rgba(0, 234, 255, 0.1), transparent);
            border-left: 4px solid var(--accent-cyan);
            border-color: rgba(0, 234, 255, 0.2);
        }

        .customer-info b {
            display: block;
            font-size: 16px;
            color: #fff;
        }

        .customer-balance {
            font-size: 13px;
            margin-top: 4px;
        }

        .bal-pos { color: var(--accent-cyan); }
        .bal-neg { color: var(--accent-red); }

        /* CONTENT AREA (RIGHT) */
        .content-area {
            flex: 1;
            background: rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .ledger-header {
            padding: 20px 40px;
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ledger-header h3 {
            margin: 0;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .ledger-header h3:hover { color: var(--accent-cyan); }

        /* CHAT LEDGER */
        .ledger-chat {
            flex: 1;
            padding: 30px 40px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
            background: radial-gradient(circle at center, rgba(0, 234, 255, 0.03) 0%, transparent 80%);
        }

        .ledger-chat::-webkit-scrollbar { width: 6px; }
        .ledger-chat::-webkit-scrollbar-thumb { background: rgba(0, 234, 255, 0.2); border-radius: 10px; }

        .date-divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }

        .date-divider span {
            background: #222;
            color: var(--text-muted);
            font-size: 12px;
            padding: 5px 15px;
            border-radius: 20px;
            border: 1px solid var(--glass-border);
        }

        .bubble {
            max-width: 60%;
            padding: 15px 20px;
            border-radius: 20px;
            font-size: 15px;
            position: relative;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .bubble.paid {
            background: rgba(0, 234, 255, 0.15);
            border: 1px solid rgba(0, 234, 255, 0.3);
            margin-left: auto;
            border-bottom-right-radius: 4px;
            color: var(--accent-cyan);
        }

        .bubble.received {
            background: rgba(255, 77, 109, 0.15);
            border: 1px solid rgba(255, 77, 109, 0.3);
            margin-right: auto;
            border-bottom-left-radius: 4px;
            color: var(--accent-red);
        }

        .bubble .note {
            display: block;
            font-weight: 500;
            margin-bottom: 5px;
            color: #fff;
        }

        .bubble .amount {
            font-size: 18px;
            font-weight: 700;
        }

        .bubble .time {
            font-size: 11px;
            opacity: 0.6;
            margin-top: 5px;
            text-align: right;
        }

        /* LEDGER FOOTER (INPUTS) */
        .ledger-footer {
            padding: 20px 40px;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(20px);
            border-top: 1px solid var(--glass-border);
        }

        .input-row {
            display: flex;
            gap: 15px;
        }

        .input-row input {
            flex: 1;
            padding: 12px 20px;
            border-radius: 15px;
            border: 1px solid var(--glass-border);
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            outline: none;
        }

        .input-row input:focus { border-color: var(--accent-cyan); }

        .btn-action {
            padding: 0 25px;
            border: none;
            border-radius: 30px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .btn-paid {
            background: var(--accent-cyan);
            color: #002a33;
            box-shadow: 0 0 15px rgba(0, 234, 255, 0.4);
        }

        .btn-received {
            background: var(--accent-red);
            color: #fff;
            box-shadow: 0 0 15px rgba(255, 77, 109, 0.4);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 25px currentColor;
        }

        /* MODALS */
        .modal-content {
            background: #0f172a;
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            color: #fff;
            box-shadow: 0 0 30px rgba(0, 234, 255, 0.2);
        }

        .modal-header { border-bottom: 1px solid var(--glass-border); padding: 25px; }
        .modal-body { padding: 30px; }

        .modern-input {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: #fff;
            outline: none;
        }

        .modern-input:focus { border-color: var(--accent-cyan); }

        /* EMPTY STATE */
        .empty-center {
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: var(--text-muted);
        }

        .empty-center i { font-size: 80px; margin-bottom: 20px; opacity: 0.2; }

        /* RESPONSIVE */
        @media (max-width: 991px) {
            .sidebar {
                position: fixed;
                left: -100%;
                width: 100%;
                z-index: 1000;
                height: 100%;
            }

            .sidebar.active { left: 0; }

            .content-area { width: 100%; }

            .ledger-header { padding: 15px 20px; }
            .ledger-chat { padding: 20px; }
            .ledger-footer { padding: 15px 20px; }
            
            .input-row { flex-direction: column; }
            .btn-action { width: 100%; padding: 15px; justify-content: center; }
        }
    </style>
</head>
<body>

    <!-- Top Navigation -->
    <nav class="top-nav">
        <div class="d-flex align-items-center gap-3">
            <button class="icon-btn d-lg-none" id="mobileToggle">
                <i class="fa-solid fa-bars"></i>
            </button>
            <h2>TrackMyCash</h2>
        </div>
        <div class="d-flex align-items-center gap-4">
            <div class="d-none d-md-block">
                Welcome, <span class="user-name"><%=userName%></span>
            </div>
            <a href="LogoutServlet" class="logout-btn">
                <i class="fa-solid fa-power-off me-2"></i>Logout
            </a>
        </div>
    </nav>

    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-title-row">
                    <h3>Accounts</h3>
                    <div id="menuIcon" class="icon-btn">
                        <i class="fa-solid fa-ellipsis-vertical"></i>
                    </div>
                    
                    <!-- Dropdown Popup -->
                    <div id="menuPopup" style="display:none; position:absolute; top:45px; right:20px; background:#1e1e1e; border-radius:12px; box-shadow:0 8px 30px rgba(0,0,0,0.5); z-index:1100; min-width:160px; border: 1px solid var(--glass-border);">
                        <a href="#" id="addCustomerBtn" style="display:block; padding:12px 20px; color:var(--accent-cyan); text-decoration:none; font-weight:600; font-size:14px;">
                            <i class="fa-solid fa-user-plus me-2"></i>Add Customer
                        </a>
                    </div>
                </div>
                <input type="text" id="searchCustomer" placeholder="Filter identities...">
            </div>

            <div class="customer-list" id="customerList">
                <%
                  if(con != null) {
                    try {
                        PreparedStatement listPs = con.prepareStatement("SELECT * FROM customers WHERE user_id=?");
                        listPs.setInt(1, uid);
                        ResultSet listRs = listPs.executeQuery();
                        while(listRs.next()){
                            int listCid = listRs.getInt("id");
                            PreparedStatement balPs = con.prepareStatement(
                             "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) b FROM transactions WHERE customer_id=?"
                            );
                            balPs.setInt(1, listCid);
                            ResultSet balRs = balPs.executeQuery();
                            double totalBal = 0;
                            if(balRs.next()) totalBal = balRs.getDouble("b");
                            
                            String activeCid = request.getParameter("cid");
                            boolean isActive = (activeCid != null && activeCid.equals(String.valueOf(listCid)));
                %>
                <div class="customer-item <%=isActive ? "active" : ""%>" onclick="location.href='dashboard.jsp?cid=<%=listCid%>'">
                    <div class="customer-info">
                        <b><%=listRs.getString("name")%></b>
                        <span class="customer-balance <%= totalBal >= 0 ? "bal-pos" : "bal-neg" %>">
                            <%= totalBal >= 0 ? "Receivable" : "Payable" %>: ₹<%=Math.abs(totalBal)%>
                        </span>
                    </div>
                    <i class="fa-solid fa-chevron-right opacity-25"></i>
                </div>
                <% 
                            balRs.close(); balPs.close();
                        }
                        listRs.close(); listPs.close();
                    } catch (Exception e) {}
                  }
                %>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content-area">
            <%
                String cid = request.getParameter("cid");
                if(cid != null && con != null){
                  String customerName = "";
                  double netTotal = 0;
                  try {
                      PreparedStatement cps = con.prepareStatement("SELECT name FROM customers WHERE id=?");
                      cps.setInt(1, Integer.parseInt(cid));
                      ResultSet crs = cps.executeQuery();
                      if(crs.next()) customerName = crs.getString("name");
                      crs.close(); cps.close();

                      PreparedStatement tps = con.prepareStatement(
                        "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) total FROM transactions WHERE customer_id=?"
                      );
                      tps.setInt(1, Integer.parseInt(cid));
                      ResultSet trs = tps.executeQuery();
                      if(trs.next()) netTotal = trs.getDouble("total");
                      trs.close(); tps.close();
                  } catch (Exception e) {}
            %>
            
            <div class="ledger-header">
                <div class="d-flex flex-column">
                    <h3 onclick="toggleHeaderMenu()">
                        <%=customerName%>
                        <i class="fa-solid fa-caret-down fs-6 opacity-50"></i>
                    </h3>
                    <div style="font-size: 14px; font-weight: 600; color: <%= netTotal >= 0 ? "var(--accent-cyan)" : "var(--accent-red)" %>;">
                        Net Protocol: ₹<%=String.format("%.2f", Math.abs(netTotal))%> <%= netTotal >= 0 ? "(Credit)" : "(Debit)" %>
                    </div>
                </div>

                <!-- Inner Menu (Update/Delete) -->
                <div id="customerMenu" style="display:none; position:absolute; top:65px; left:40px; background:#1e1e1e; border-radius:12px; box-shadow:0 8px 30px rgba(0,0,0,0.5); z-index:1100; min-width:180px; border: 1px solid var(--glass-border);">
                    <a href="#" onclick="openEditCustomer('<%=cid%>','<%=customerName%>','')" style="display:block; padding:12px 20px; color:var(--accent-cyan); text-decoration:none; font-size:14px;">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Edit Profile
                    </a>
                    <a href="#" onclick="deleteCustomer('<%=cid%>')" style="display:block; padding:12px 20px; color:var(--accent-red); text-decoration:none; font-size:14px;">
                        <i class="fa-solid fa-trash-can me-2"></i>Purge Entity
                    </a>
                </div>

                <div class="d-flex gap-2">
                    <button class="icon-btn" onclick="location.reload()" title="Synchronize"><i class="fa-solid fa-rotate"></i></button>
                </div>
            </div>

            <div class="ledger-chat" id="chatBox">
                <%
                    try {
                        String lastLabel = "";
                        SimpleDateFormat dateOnly = new SimpleDateFormat("dd-MM-yyyy");
                        SimpleDateFormat displayDate = new SimpleDateFormat("dd MMM yyyy");
                        SimpleDateFormat timeFmt = new SimpleDateFormat("hh:mm a");

                        PreparedStatement ps2 = con.prepareStatement("SELECT * FROM transactions WHERE customer_id=? ORDER BY date");
                        ps2.setInt(1, Integer.parseInt(cid));
                        ResultSet rs2 = ps2.executeQuery();

                        while(rs2.next()){
                            Timestamp ts = rs2.getTimestamp("date");
                            java.util.Date d = new java.util.Date(ts.getTime());
                            String currDate = dateOnly.format(d);

                            if(!currDate.equals(lastLabel)){
                                String label = displayDate.format(d);
                                Calendar c1 = Calendar.getInstance();
                                Calendar c2 = Calendar.getInstance();
                                c2.setTime(d);
                                if(c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR)) label = "Today";
                                else {
                                    c1.add(Calendar.DATE, -1);
                                    if(c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR)) label = "Yesterday";
                                }
                %>
                <div class="date-divider"><span><%=label%></span></div>
                <%
                                lastLabel = currDate;
                            }
                            String type = rs2.getString("type");
                %>
                <div class="bubble <%=type.equals("gave") ? "paid" : "received"%>">
                    <% if(rs2.getString("note") != null && !rs2.getString("note").isEmpty()) { %>
                        <span class="note"><%=rs2.getString("note")%></span>
                    <% } %>
                    <span class="amount">₹<%=String.format("%.2f", rs2.getDouble("amount"))%></span>
                    <div class="time"><%=timeFmt.format(d)%></div>
                </div>
                <% 
                        }
                        rs2.close(); ps2.close();
                    } catch (Exception e) {}
                %>
            </div>

            <div class="ledger-footer">
                <form action="AddTransactionServlet" method="post" autocomplete="off">
                    <input type="hidden" name="cid" value="<%=cid%>">
                    <div class="input-row">
                        <input type="number" name="amount" min="1" step="0.01" placeholder="Enter Amount (₹)" required>
                        <input type="text" name="note" placeholder="Transaction protocol note...">
                        <div class="d-flex gap-2">
                            <button type="submit" name="type" value="gave" class="btn-action btn-paid">
                                <i class="fa-solid fa-arrow-up"></i>PAID
                            </button>
                            <button type="submit" name="type" value="got" class="btn-action btn-received">
                                <i class="fa-solid fa-arrow-down"></i>GOT
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <% } else { %>
            <div class="empty-center">
                <i class="fa-solid fa-microchip"></i>
                <h2>Select an Entity</h2>
                <p>Initialize a secure ledger to view historical data and execute transactions.</p>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Modals -->
    <!-- Add Customer Modal -->
    <div id="addCustomerModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); backdrop-filter:blur(5px); justify-content:center; align-items:center; z-index:2000;">
        <div class="modal-content" style="width:350px; padding:30px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 style="margin:0; font-size:20px; color:var(--accent-cyan);">Register Node</h3>
                <span id="closeModal" style="cursor:pointer; font-size:24px;">&times;</span>
            </div>
            
            <% if ("exists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger py-2 small mb-3">Collision: Identity already exists.</div>
            <% } %>

            <form action="AddCustomerServlet" method="post">
                <input type="text" name="name" class="modern-input" placeholder="Entity Name" required>
                <input type="text" name="phone" class="modern-input" placeholder="Contact Protocol (Optional)">
                <button type="submit" class="btn-action btn-paid w-100 py-3 mt-2">CONFIRM LINK</button>
            </form>
        </div>
    </div>

    <!-- Edit Customer Modal -->
    <div id="editCustomerModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); backdrop-filter:blur(5px); justify-content:center; align-items:center; z-index:2000;">
        <div class="modal-content" style="width:350px; padding:30px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 style="margin:0; font-size:20px; color:var(--accent-cyan);">Edit Profile</h3>
                <span onclick="closeEditModal()" style="cursor:pointer; font-size:24px;">&times;</span>
            </div>
            <form action="UpdateCustomerServlet" method="post">
                <input type="hidden" name="cid" id="editCid">
                <input type="text" name="name" id="editName" class="modern-input" placeholder="Entity Name" required>
                <input type="text" name="phone" id="editPhone" class="modern-input" placeholder="Contact Protocol">
                <button type="submit" class="btn-action btn-paid w-100 py-3 mt-2">UPDATE DATA</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Sidebar Toggle for Mobile
        document.getElementById('mobileToggle').addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // Dropdown Menu Logic
        const menuIcon = document.getElementById("menuIcon");
        const menuPopup = document.getElementById("menuPopup");
        menuIcon.addEventListener("click", (e) => {
            e.stopPropagation();
            menuPopup.style.display = menuPopup.style.display === "block" ? "none" : "block";
        });

        function toggleHeaderMenu() {
            const menu = document.getElementById("customerMenu");
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        }

        // Close Popups on Outside Click
        document.addEventListener("click", (e) => {
            if (menuPopup) menuPopup.style.display = "none";
            const headerMenu = document.getElementById("customerMenu");
            if (headerMenu && !e.target.closest('.ledger-header')) headerMenu.style.display = "none";
        });

        // Search Filter
        document.getElementById('searchCustomer').addEventListener('input', function() {
            let filter = this.value.toLowerCase();
            document.querySelectorAll('.customer-item').forEach(function(item) {
                let text = item.innerText.toLowerCase();
                item.style.display = text.includes(filter) ? 'flex' : 'none';
            });
        });

        // Modal Logic
        const addModal = document.getElementById("addCustomerModal");
        document.getElementById("addCustomerBtn").addEventListener("click", (e) => {
            e.preventDefault();
            addModal.style.display = "flex";
        });

        document.getElementById("closeModal").addEventListener("click", () => addModal.style.display = "none");

        window.onclick = (e) => {
            if (e.target === addModal) addModal.style.display = "none";
            const editModal = document.getElementById("editCustomerModal");
            if (e.target === editModal) editModal.style.display = "none";
        };

        function openEditCustomer(id, name, phone) {
            document.getElementById("editCid").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editPhone").value = phone;
            document.getElementById("editCustomerModal").style.display = "flex";
        }

        function closeEditModal() {
            document.getElementById("editCustomerModal").style.display = "none";
        }

        function deleteCustomer(cid) {
            if (confirm("DANGER: Purging this entity will delete all historical data. Continue?")) {
                window.location.href = "DeleteCustomerServlet?cid=" + cid;
            }
        }

        // Auto Scroll Ledger
        const chatBox = document.getElementById("chatBox");
        if (chatBox) chatBox.scrollTop = chatBox.scrollHeight;

        <% if ("addCustomer".equals(request.getParameter("popup"))) { %>
            addModal.style.display = "flex";
        <% } %>
    </script>
</body>
</html>
<% if (con != null) { try { con.close(); } catch(Exception e) {} } %>