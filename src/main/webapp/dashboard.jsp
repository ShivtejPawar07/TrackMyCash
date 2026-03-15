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
    } catch (Exception e) {}
    
    String cid = request.getParameter("cid");
    boolean hasSelectedCustomer = (cid != null && !cid.isEmpty());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>TrackMyCash - Command Center</title>
    <!-- Bootstrap 5 CSS -->
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
            height: 100dvh; /* Dynamic viewport height for mobile browser bars */
            background: var(--bg-dark);
            color: var(--text-main);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* TOP NAVIGATION */
        .top-nav {
            padding: 12px 25px;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--glass-border);
            z-index: 100;
            flex-shrink: 0;
        }

        .top-nav h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .top-nav .user-name {
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
        }

        .logout-btn {
            padding: 6px 16px;
            background: rgba(255, 77, 77, 0.1);
            border: 1px solid rgba(255, 77, 77, 0.4);
            color: #ff4d4d;
            text-decoration: none;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .logout-btn:hover { background: #ff4d4d; color: #fff; }

        /* MAIN APP CONTAINER */
        .app-container {
            flex: 1;
            display: flex;
            height: 0; /* Important for flex-grow to work without overflow issues */
            position: relative;
        }

        /* SIDEBAR (LEFT) - List View */
        .sidebar {
            width: 380px;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            z-index: 50;
            flex-shrink: 0;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid var(--glass-border);
        }

        #searchCustomer {
            width: 100%;
            padding: 12px 18px;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: rgba(255, 255, 255, 0.04);
            color: #fff;
            outline: none;
            font-size: 15px;
        }

        .customer-list {
            flex: 1;
            overflow-y: auto;
            padding: 8px;
        }

        .customer-item {
            padding: 18px 20px;
            margin-bottom: 5px;
            border-radius: 16px;
            background: transparent;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .customer-item:hover { background: rgba(255, 255, 255, 0.05); }

        .customer-item.active { background: rgba(0, 234, 255, 0.1); }

        .customer-info b { font-size: 16px; color: #fff; font-weight: 600; }
        .customer-balance { font-size: 13px; margin-top: 3px; }
        .bal-pos { color: var(--accent-cyan); }
        .bal-neg { color: var(--accent-red); }

        /* CONTENT AREA (RIGHT) - Chat View */
        .content-area {
            flex: 1;
            background: rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .ledger-header {
            padding: 15px 25px;
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            gap: 15px;
            flex-shrink: 0;
        }

        .back-btn {
            display: none; /* Only mobile */
            color: var(--accent-cyan);
            font-size: 20px;
            cursor: pointer;
            text-decoration: none;
        }

        .ledger-header h3 {
            margin: 0;
            color: #fff;
            font-size: 20px;
            font-weight: 600;
        }

        /* CHAT LEDGER */
        .ledger-chat {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .bubble {
            max-width: 75%;
            padding: 12px 18px;
            border-radius: 18px;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
        }

        .bubble.paid {
            background: rgba(0, 234, 255, 0.12);
            border: 1px solid rgba(0, 234, 255, 0.2);
            margin-left: auto;
            border-bottom-right-radius: 4px;
            color: var(--accent-cyan);
        }

        .bubble.received {
            background: rgba(255, 77, 109, 0.12);
            border: 1px solid rgba(255, 77, 109, 0.2);
            margin-right: auto;
            border-bottom-left-radius: 4px;
            color: var(--accent-red);
        }

        .bubble .note { font-weight: 500; font-size: 14px; color: #fff; display: block; margin-bottom: 3px;}
        .bubble .amount { font-size: 18px; font-weight: 700; }
        .bubble .time { font-size: 10px; opacity: 0.5; text-align: right; margin-top: 5px; }

        .date-divider { text-align: center; margin: 15px 0; }
        .date-divider span { background: #1e293b; color: #94a3b8; font-size: 11px; padding: 4px 12px; border-radius: 20px; }

        /* LEDGER FOOTER */
        .ledger-footer {
            padding: 15px 20px;
            background: rgba(15, 23, 42, 0.7);
            border-top: 1px solid var(--glass-border);
            flex-shrink: 0;
        }

        .input-row { display: flex; gap: 10px; }
        .input-row input {
            flex: 1;
            padding: 12px 15px;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            background: rgba(255, 255, 255, 0.04);
            color: #fff;
            outline: none;
            font-size: 14px;
        }

        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            font-size: 13px;
            transition: 0.3s;
        }

        .btn-paid { background: var(--accent-cyan); color: #002a33; }
        .btn-received { background: var(--accent-red); color: #fff; }

        /* Add Button */
        .fab-add {
            position: absolute;
            bottom: 30px;
            right: 30px;
            width: 55px;
            height: 55px;
            background: var(--accent-cyan);
            color: #002a33;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            box-shadow: 0 8px 25px rgba(0, 234, 255, 0.4);
            cursor: pointer;
            z-index: 100;
            border: none;
        }

        /* MODALS */
        .modal-content { background: #0f172a; color: #fff; border-radius: 20px; border: 1px solid var(--glass-border); }

        /* WHATSAPP STYLE MOBILE NAVIGATION */
        @media (max-width: 991px) {
            body { height: 100dvh; }
            .app-container { height: calc(100dvh - 65px); }

            <% if (!hasSelectedCustomer) { %>
                /* Show List, Hide Chat */
                .sidebar { width: 100%; display: flex; }
                .content-area { display: none; }
                .top-nav { display: flex; }
            <% } else { %>
                /* Show Chat, Hide List */
                .sidebar { display: none; }
                .content-area { width: 100%; display: flex; }
                .top-nav { display: none; }
                .back-btn { display: block; }
            <% } %>

            .ledger-header { padding: 15px 20px; position: sticky; top: 0; z-index: 200; }
            .ledger-chat { padding-bottom: 20px; }
            .input-row { flex-wrap: wrap; }
            .input-row input { width: 100%; margin-bottom: 5px; }
            .btn-action { flex: 1; padding: 15px; }
        }
    </style>
</head>
<body>

    <!-- Top Nav (List View Navigation) -->
    <nav class="top-nav">
        <h2>Track<span class="user-name">MyCash</span></h2>
        <div class="d-flex align-items-center gap-3">
            <span class="d-none d-sm-inline opacity-50">Identity: <%=userName%></span>
            <a href="LogoutServlet" class="logout-btn">Exit</a>
        </div>
    </nav>

    <div class="app-container">
        <!-- Sidebar: Contact List -->
        <div class="sidebar">
            <div class="sidebar-header">
                <input type="text" id="searchCustomer" placeholder="Search identities...">
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
                            double totalBal = 0; if(balRs.next()) totalBal = balRs.getDouble("b");
                            boolean isActive = (cid != null && cid.equals(String.valueOf(listCid)));
                %>
                <div class="customer-item <%=isActive ? "active" : ""%>" onclick="location.href='dashboard.jsp?cid=<%=listCid%>'">
                    <div class="customer-info">
                        <b><%=listRs.getString("name")%></b>
                        <span class="customer-balance <%= totalBal >= 0 ? "bal-pos" : "bal-neg" %>">
                            ₹<%=Math.abs(totalBal)%> <%= totalBal >= 0 ? "Receivable" : "Payable" %>
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

            <!-- WhatsApp FAB for Adding Customer -->
            <button class="fab-add" onclick="document.getElementById('addCustomerModal').style.display='flex'">
                <i class="fa-solid fa-plus"></i>
            </button>
        </div>

        <!-- Content Area: Chat/Ledger -->
        <div class="content-area">
            <%
                if(hasSelectedCustomer && con != null){
                  String customerName = ""; double netTotal = 0;
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
                <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>
                <div class="flex-grow-1">
                    <h3><%=customerName%></h3>
                    <div style="font-size: 12px; color: <%= netTotal >= 0 ? "var(--accent-cyan)" : "var(--accent-red)" %>;">
                        Net Protocol: ₹<%=Math.abs(netTotal)%> <%= netTotal >= 0 ? "(You get)" : "(You give)" %>
                    </div>
                </div>
                <!-- Mini Dropdown for Edit/Delete -->
                <div class="dropdown">
                    <button class="icon-btn text-white opacity-50" data-bs-toggle="dropdown"><i class="fa-solid fa-ellipsis-vertical"></i></button>
                    <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end" style="background:#1e293b; border: 1px solid var(--glass-border);">
                        <li><a class="dropdown-item" href="#" onclick="openEditCustomer('<%=cid%>','<%=customerName%>')"><i class="fa-solid fa-pen-to-square me-2"></i> Edit Profile</a></li>
                        <li><a class="dropdown-item text-danger" href="#" onclick="deleteCustomer('<%=cid%>')"><i class="fa-solid fa-trash-can me-2"></i> Purge Identity</a></li>
                    </ul>
                </div>
            </div>

            <div class="ledger-chat" id="chatBox">
                <%
                    try {
                        String lastDateStr = "";
                        // Standard formats for IST
                        SimpleDateFormat dateOnly = new SimpleDateFormat("dd-MM-yyyy");
                        SimpleDateFormat displayDate = new SimpleDateFormat("dd MMM yyyy");
                        SimpleDateFormat timeFmt = new SimpleDateFormat("hh:mm a");
                        
                        // CALIBRATE TO IST
                        TimeZone ist = TimeZone.getTimeZone("Asia/Kolkata");
                        dateOnly.setTimeZone(ist);
                        displayDate.setTimeZone(ist);
                        timeFmt.setTimeZone(ist);

                        PreparedStatement ps2 = con.prepareStatement("SELECT * FROM transactions WHERE customer_id=? ORDER BY date");
                        ps2.setInt(1, Integer.parseInt(cid));
                        ResultSet rs2 = ps2.executeQuery();
                        while(rs2.next()){
                            Timestamp ts = rs2.getTimestamp("date");
                            java.util.Date d = new java.util.Date(ts.getTime());
                            String currDate = dateOnly.format(d);
                            if(!currDate.equals(lastDateStr)){
                                String label = displayDate.format(d);
                                Calendar c1 = Calendar.getInstance(ist); 
                                Calendar c2 = Calendar.getInstance(ist); 
                                c2.setTime(d);
                                if(c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR) && c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR)) 
                                    label = "Today";
                                else { 
                                    c1.add(Calendar.DATE, -1); 
                                    if(c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR) && c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR)) 
                                        label = "Yesterday"; 
                                }
                %>
                <div class="date-divider"><span><%=label%></span></div>
                <%
                                lastDateStr = currDate;
                            }
                            String type = rs2.getString("type");
                %>
                <div class="bubble <%=type.equals("gave") ? "paid" : "received"%>">
                    <% if(rs2.getString("note") != null && !rs2.getString("note").isEmpty()) { %>
                        <span class="note text-uppercase opacity-75" style="font-size: 11px; letter-spacing: 1px;"><%=rs2.getString("note")%></span>
                    <% } %>
                    <span class="amount">₹<%=rs2.getDouble("amount")%></span>
                    <div class="time"><%=timeFmt.format(d)%></div>
                </div>
                <% } rs2.close(); ps2.close(); } catch (Exception e) {} %>
            </div>

            <div class="ledger-footer">
                <form action="AddTransactionServlet" method="post" autocomplete="off">
                    <input type="hidden" name="cid" value="<%=cid%>">
                    <div class="input-row">
                        <input type="number" name="amount" min="1" step="0.01" placeholder="Protocol Amount" required>
                        <input type="text" name="note" placeholder="Data Note...">
                        <button type="submit" name="type" value="gave" class="btn-action btn-paid">PAID</button>
                        <button type="submit" name="type" value="got" class="btn-action btn-received">GOT</button>
                    </div>
                </form>
            </div>

            <% } else { %>
            <div class="d-none d-lg-flex flex-column justify-content-center align-items-center h-100 opacity-25">
                <i class="fa-solid fa-microchip fs-1 mb-3"></i>
                <p>Select an identity to initialize ledger protocol</p>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Modals (Add / Edit) -->
    <div id="addCustomerModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); backdrop-filter:blur(10px); justify-content:center; align-items:center; z-index:2000;">
        <div class="modal-content" style="width:90%; max-width:400px; padding:30px;">
            <div class="d-flex justify-content-between mb-4">
                <h3 style="margin:0; font-size:20px; color:var(--accent-cyan);">Register Identity</h3>
                <span onclick="this.parentElement.parentElement.parentElement.style.display='none'" style="cursor:pointer; font-size:24px;">&times;</span>
            </div>
            <form action="AddCustomerServlet" method="post">
                <input type="text" name="name" class="form-control mb-3 bg-dark text-white border-secondary p-3" placeholder="Entity Name" required>
                <input type="text" name="phone" class="form-control mb-4 bg-dark text-white border-secondary p-3" placeholder="Contact Protocol (Optional)">
                <button type="submit" class="btn-action btn-paid w-100 py-3">SAVE PROTOCOL</button>
            </form>
        </div>
    </div>

    <div id="editCustomerModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); backdrop-filter:blur(10px); justify-content:center; align-items:center; z-index:2000;">
        <div class="modal-content" style="width:90%; max-width:400px; padding:30px;">
            <div class="d-flex justify-content-between mb-4">
                <h3 style="margin:0; font-size:20px; color:var(--accent-cyan);">Update Identity</h3>
                <span onclick="this.parentElement.parentElement.parentElement.style.display='none'" style="cursor:pointer; font-size:24px;">&times;</span>
            </div>
            <form action="UpdateCustomerServlet" method="post">
                <input type="hidden" name="cid" id="editCid">
                <input type="text" name="name" id="editName" class="form-control mb-3 bg-dark text-white border-secondary p-3" placeholder="Name" required>
                <button type="submit" class="btn-action btn-paid w-100 py-3">SUBMIT AMENDMENT</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search Filter
        document.getElementById('searchCustomer')?.addEventListener('input', function() {
            let filter = this.value.toLowerCase();
            document.querySelectorAll('.customer-item').forEach(function(item) {
                item.style.display = item.innerText.toLowerCase().includes(filter) ? 'flex' : 'none';
            });
        });

        function openEditCustomer(id, name) {
            document.getElementById("editCid").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editCustomerModal").style.display = "flex";
        }

        function deleteCustomer(cid) {
            if (confirm("DANGER: This will permanently purge the identity and all associated ledger data. Proceed?")) {
                window.location.href = "DeleteCustomerServlet?cid=" + cid;
            }
        }

        const chatBox = document.getElementById("chatBox");
        if (chatBox) chatBox.scrollTop = chatBox.scrollHeight;
    </script>
</body>
</html>
<% if (con != null) { try { con.close(); } catch(Exception e) {} } %>