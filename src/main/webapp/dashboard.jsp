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
<html>
<head>
<title>TrackMyCash</title>
<meta charset="UTF-8">

<style>
/* Body */
body {
    margin:0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background:#121212;
    color:#fff;
}

/* Container */
.container {
    display:flex;
    height:90vh;
}

/* LEFT */
.left {
    width:30%;
    background:#1e1e1e;
    border-right:1px solid #333;
    padding:15px;
    display:flex;
    flex-direction:column;
    gap:10px;
}

.left h3 {
    margin:0;
    color:#00f2ff;
}

/* Search */
#searchCustomer {
    margin-bottom:10px;
    padding:8px;
    border:none;
    border-radius:6px;
    background:#2b2b2b;
    color:#fff;
}

/* Add Customer Form */
.left form input {
    width:100%;
    margin:5px 0;
    padding:8px;
    border:none;
    border-radius:6px;
    background:#2b2b2b;
    color:#fff;
}

.left form button {
    width:100%;
    padding:8px;
    border:none;
    border-radius:6px;
    background:linear-gradient(90deg, #00f2ff, #0066ff);
    color:#fff;
    font-weight:bold;
    cursor:pointer;
}

/* Customer List */
.customer {
    padding:10px;
    border-radius:6px;
    margin:4px 0;
    background:#2b2b2b;
    cursor:pointer;
    transition:0.2s;
}

.customer:hover {
    background:#333;
}

/* RIGHT */
.right {
    flex:1;
    padding:15px;
    display:flex;
    flex-direction:column;
    gap:10px;
    background:#181818;
}

/* Customer header with menu */
.customer-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.customer-header h3 {
    margin:0;
    color:#00f2ff;
}

#customerMenu {
    display:none;
    position:absolute;
    background:#1e1e1e;
    border:1px solid #333;
    border-radius:6px;
    box-shadow:0 2px 6px rgba(0,0,0,0.5);
    padding:6px 0;
    z-index:10;
}

#customerMenu a {
    display:block;
    padding:8px 16px;
    text-decoration:none;
    color:#fff;
}

#customerMenu a:hover {
    background:#333;
}

/* Chat ledger */
.chat {
    flex:1;
    overflow-y:auto;
    padding:10px;
    background:#222;
    display:flex;
    flex-direction:column;
    gap:6px;
}

/* Chat bubbles */
.chat-bubble {
    padding:12px 16px;
    border-radius:16px;
    max-width:65%;
    font-size:14px;
    line-height:1.4;
    position:relative;
}

.chat-bubble.debit {
    /*background:#ff4d6d;*/
    background:#00f2ff33;
    margin-left:auto;
    border-bottom-right-radius:4px;
}

.chat-bubble.credit {
    background:#ff4d6d;
    margin-right:auto;
    border-bottom-left-radius:4px;
}

/* Date separator */
.date-separator {
    text-align:center;
    background:#333;
    color:#fff;
    font-size:12px;
    padding:6px 14px;
    margin:10px auto;
    border-radius:14px;
}

/* Footer */
.footer {
    display:flex;
    gap:5px;
}

.footer input {
    flex:1;
    padding:10px;
    border-radius:6px;
    border:none;
}

.footer button {
    padding:10px 12px;
    border:none;
    border-radius:6px;
    font-weight:bold;
    cursor:pointer;
}

.footer button[name="type"][value="gave"] {
    background:#00f2ff;
    color:#000;
}

.footer button[name="type"][value="got"] {
    background:#ff4d6d;
    color:#fff;
}

/* Responsive */

@media (max-width:768px){

  /* layout */
  .container{
    flex-direction:column;
    height:100vh;
  }

  /* customer list = screen 1 */
  .left{
    width:100%;
    height:100vh;
    display:block;
  }

  /* chat = screen 2 */
  .right{
    display:none;
    height:100vh;
    padding:0;
  }

  .right.active{
    display:flex;
    flex-direction:column;
  }

  /* mobile header */
  .mobile-header{
    display:flex;
  }

  /* footer fixed */
  .footer{
    position:sticky;
    bottom:0;
    background:#181818;
    padding:8px;
  }
}

</style>
</head>

<body>
<div style="display:flex; justify-content:space-between; align-items:center; padding:0 20px;">
     <h2 style="
        font-size:26px;
        font-weight:600;
        color:#ffffff;
        margin-bottom:6px;
    ">
        Welcome, 
        <span style="
            background:linear-gradient(90deg,#00f2ff,#0066ff);
            -webkit-background-clip:text;
            -webkit-text-fill-color:transparent;
        ">
            <%=session.getAttribute("userName")%>
        </span>
    </h2>

    <a href="LogoutServlet"
       style="
         padding:8px 16px;
         background:#ff4d4d;
         color:#fff;
         text-decoration:none;
         border-radius:6px;
         font-weight:bold;
       ">
        Logout
    </a>
</div>


<div class="container">

<!-- LEFT -->
<div class="left">
  <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; position:relative;">

    <h3 style="color:#00f2ff; margin:0;">TrackMyCash</h3>
    <!-- Hamburger Icon -->
    <div id="menuIcon" style="cursor:pointer; width:30px; display:flex; flex-direction:column; justify-content:space-between; height:20px;">
    <span style="display:block; height:3px; background:#fff; border-radius:2px;"></span>
    <span style="display:block; height:3px; background:#fff; border-radius:2px;"></span>
    <span style="display:block; height:3px; background:#fff; border-radius:2px;"></span>
  </div>

  <!-- ✅ Dropdown Menu (NOW CORRECT) -->
  <div id="menuPopup"
       style="display:none;
              position:absolute;
              top:30px;
              right:0;
              background:#1e1e1e;
              border-radius:8px;
              box-shadow:0 4px 10px rgba(0,0,0,0.3);
              z-index:100;
              min-width:140px;">
    <a href="#" id="addCustomerBtn"
       style="display:block;padding:10px;color:#00f2ff;text-decoration:none;font-weight:bold;">
       Add Customer
    </a>
   <!--   <a href="#" style="display:block;padding:10px;color:#fff;text-decoration:none;">XYZ</a>
    <a href="#" style="display:block;padding:10px;color:#fff;text-decoration:none;">ABC</a>-->
  </div>
  </div>
<input type="text" id="searchCustomer" placeholder="Search customer...">




<!-- Add Customer Modal -->
<div id="addCustomerModal"
     style="display:none;
            position:fixed;
            top:0; left:0;
            width:100%; height:100%;
            background:rgba(0,0,0,0.6);
            justify-content:center;
            align-items:center;
            z-index:1000;">

  <div style="background:#1e1e1e;
              padding:20px;
              border-radius:8px;
              width:300px;
              position:relative;">

    <span id="closeModal"
          style="position:absolute;
                 top:10px; right:12px;
                 cursor:pointer;
                 font-size:18px;
                 color:#fff;">&times;</span>

    <h3 style="color:#00f2ff; margin-bottom:15px;">Add Customer</h3>

    <!-- ✅ ERROR MESSAGE INSIDE POPUP -->
    <% if ("exists".equals(request.getParameter("error"))) { %>
        <div style="
            color:#ff4d4d;
            background:#2a0000;
            padding:8px;
            border-radius:6px;
            margin-bottom:10px;
            text-align:center;
            font-size:13px;">
            Customer already exists (same name & mobile)
        </div>
    <% } %>

    <form action="AddCustomerServlet" method="post"
          style="display:flex; flex-direction:column; gap:10px;">

      <input type="text" name="name" placeholder="Name" required
             style="padding:8px; border-radius:6px;
                    border:none; background:#2b2b2b; color:#fff;">

      <input type="text" name="phone" placeholder="Phone"
             style="padding:8px; border-radius:6px;
                    border:none; background:#2b2b2b; color:#fff;">

      <button type="submit"
              style="padding:10px;
                     border:none;
                     border-radius:6px;
                     background:linear-gradient(90deg,#00f2ff,#0066ff);
                     color:#fff;
                     font-weight:bold;
                     cursor:pointer;">
        Add Customer
      </button>
    </form>
  </div>
</div>

 
  <hr>

  <div id="customerList">
    <%
      int uid = (int)session.getAttribute("userId");
      Connection con = DBConnection.getConnection();
      PreparedStatement ps = con.prepareStatement("SELECT * FROM customers WHERE user_id=?");
      ps.setInt(1, uid);
      ResultSet rs = ps.executeQuery();
      while(rs.next()){
          int cid2 = rs.getInt("id");
          PreparedStatement bal = con.prepareStatement(
           "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) b FROM transactions WHERE customer_id=?"
          );
          bal.setInt(1, cid2);
          ResultSet br = bal.executeQuery();
          double b = 0;
          if(br.next()) b = br.getDouble("b");
    %>
    <div class="customer" data-cid="<%=cid2%>" onclick="location.href='dashboard.jsp?cid=<%=cid2%>'">
      <b><%=rs.getString("name")%></b> (₹<%=b%>)
    </div>
    <% } %>
  </div>
</div>

<!-- RIGHT -->
<div class="right">

<%
String cid = request.getParameter("cid");
if(cid!=null){
  String customerName="";
  double total=0;
  PreparedStatement cps = con.prepareStatement("SELECT name FROM customers WHERE id=?");
  cps.setInt(1,Integer.parseInt(cid));
  ResultSet crs=cps.executeQuery();
  if(crs.next()) customerName=crs.getString("name");

  PreparedStatement tps = con.prepareStatement(
    "SELECT SUM(CASE WHEN type='got' THEN amount ELSE -amount END) total FROM transactions WHERE customer_id=?"
  );
  tps.setInt(1,Integer.parseInt(cid));
  ResultSet trs=tps.executeQuery();
  if(trs.next()) total=trs.getDouble("total");
%>

<div class="customer-header" style="position:relative;">
  
  <!-- Customer Name (CLICKABLE) -->
  <h3 onclick="toggleMenu()" style="cursor:pointer;">
    <%=customerName%>
  </h3>

  <!-- Hidden Menu -->
  <div id="customerMenu"
       style="display:none;
              position:absolute;
              top:35px;
              left:0;
              background:#1e1e1e;
              border-radius:8px;
              box-shadow:0 4px 10px rgba(0,0,0,0.3);
              z-index:100;
              min-width:140px;">

   <!-- <a href="UpdateCustomerServlet?cid=<%=cid%>"
       style="display:block;padding:10px;color:#00f2ff;text-decoration:none;">
       ✏ Edit Customer
    </a>

    <a href="DeleteCustomerServlet?cid=<%=cid%>"
       onclick="return confirm('Are you sure?')"
       style="display:block;padding:10px;color:#ff4d6d;text-decoration:none;">
       🗑 Delete Customer
    </a> -->
	
 <a href="#"
   onclick="openEditCustomer('<%=cid%>','<%=customerName%>','')"
   style="display:block;padding:10px;color:#00f2ff;text-decoration:none;">
   ✏ Edit Customer
</a>

<a href="#"
   onclick="deleteCustomer('<%=cid%>')"
   style="display:block;padding:10px;color:#ff4d6d;text-decoration:none;">
   🗑 Delete Customer
</a>
 

	
  </div>
</div>

<small style="color:<%= total>=0 ? "#00f2ff":"#ff4d6d"%>;">
  Total Balance: ₹ <%=total%>
</small>


<div class="chat" id="chatBox">


<%
String lastDate="";
SimpleDateFormat dateOnly=new SimpleDateFormat("dd-MM-yyyy");
SimpleDateFormat displayDate=new SimpleDateFormat("dd MMM yyyy");
SimpleDateFormat timeFmt=new SimpleDateFormat("hh:mm a");

PreparedStatement ps2=con.prepareStatement(
 "SELECT * FROM transactions WHERE customer_id=? ORDER BY date"
);
ps2.setInt(1,Integer.parseInt(cid));
ResultSet rs2=ps2.executeQuery();

while(rs2.next()){
 Timestamp ts=rs2.getTimestamp("date");
 java.util.Date d=new java.util.Date(ts.getTime());
 String currDate=dateOnly.format(d);

 if(!currDate.equals(lastDate)){
    String label=displayDate.format(d);
    Calendar c1=Calendar.getInstance();
    Calendar c2=Calendar.getInstance();
    c2.setTime(d);
    if(c1.get(Calendar.DAY_OF_YEAR)==c2.get(Calendar.DAY_OF_YEAR))
        label="Today";
    else{c1.add(Calendar.DATE,-1);if(c1.get(Calendar.DAY_OF_YEAR)==c2.get(Calendar.DAY_OF_YEAR)) label="Yesterday";}
%>
<div class="date-separator"><%=label%></div>
<%
    lastDate=currDate;
 }

 String type=rs2.getString("type");
%>

<div class="chat-bubble <%=type.equals("gave")?"debit":"credit"%>">
 ₹<%=rs2.getDouble("amount")%><br>
 <%=rs2.getString("note")==null?"":rs2.getString("note")%>
 <div class="time"><%=timeFmt.format(d)%></div>
</div>

<% } %>

</div>

<form class="footer" action="AddTransactionServlet" method="post">
<input type="hidden" name="cid" value="<%=cid%>">
<input type="number" name="amount" min="1" placeholder="Amount" required>

<input type="text" name="note" placeholder="Note">
<button name="type" value="gave">Paid</button>
<button name="type" value="got">Received</button>
</form>

<% } else { %>
<h3>Select customer to view ledger</h3>
<% } %>

</div>
</div>

<script>
// Customer menu
document.getElementById('customerMenuBtn')?.addEventListener('click', function(){
  let menu = document.getElementById('customerMenu');
  menu.style.display = menu.style.display==='block'?'none':'block';
});

// Search functionality
document.getElementById('searchCustomer').addEventListener('input', function(){
  let filter = this.value.toLowerCase();
  document.querySelectorAll('#customerList .customer').forEach(function(cust){
    let text = cust.innerText.toLowerCase();
    cust.style.display = text.includes(filter)?'block':'none';
  });
});


function toggleMenu(){
  let menu = document.getElementById("customerMenu");
  menu.style.display = (menu.style.display === "block") ? "none" : "block";
}

/* Outside click = close menu */
document.addEventListener("click", function(e){
  if(!e.target.closest(".customer-header")){
    document.getElementById("customerMenu").style.display="none";
  }
});

window.onload = function () {
    let chat = document.getElementById("chatBox");
    if(chat){
        chat.scrollTop = chat.scrollHeight;
    }
};


//Toggle dropdown menu on hamburger click
document.getElementById("menuIcon").addEventListener("click", function(){
    let popup = document.getElementById("menuPopup");
    popup.style.display = popup.style.display === "block" ? "none" : "block";
});

// Close dropdown if click outside
document.addEventListener("click", function(e){
    let popup = document.getElementById("menuPopup");
    let icon = document.getElementById("menuIcon");
    if(!popup.contains(e.target) && !icon.contains(e.target)){
        popup.style.display = "none";
    }
});

// Open Add Customer modal when menu item clicked
document.getElementById("addCustomerBtn").addEventListener("click", function(e){
    e.preventDefault();
    document.getElementById("addCustomerModal").style.display = "flex";
    document.getElementById("menuPopup").style.display = "none";
});

// Close modal
document.getElementById("closeModal").addEventListener("click", function(){
    document.getElementById("addCustomerModal").style.display = "none";
});

// Click outside modal to close
window.addEventListener("click", function(e){
    let modal = document.getElementById("addCustomerModal");
    if(e.target === modal){
        modal.style.display = "none";
    }
});

window.addEventListener("click", function(e){
    let modal = document.getElementById("editCustomerModal");
    if(e.target === modal){
        modal.style.display = "none";
    }
});
<% if ("addCustomer".equals(request.getParameter("popup"))) { %>
    document.getElementById("addCustomerModal").style.display = "flex";
<% } %>

document.getElementById("closeModal").onclick = function () {
    document.getElementById("addCustomerModal").style.display = "none";
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
		  if (confirm("Are you sure you want to delete this customer?")) {
		    window.location.href = "DeleteCustomerServlet?cid=" + cid;
		  }
		}

</script>

</body>
<div id="editCustomerModal"
style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
background:rgba(0,0,0,0.6); z-index:999; justify-content:center; align-items:center;">

  <div style="background:#1e1e1e; padding:20px; border-radius:8px; width:300px; position:relative;">
    <span onclick="closeEditModal()" style="position:absolute; top:8px; right:12px; cursor:pointer;">✖</span>

    <h3 style="color:#00f2ff">Edit Customer</h3>

    <form action="UpdateCustomerServlet" method="post"
          style="display:flex; flex-direction:column; gap:10px;">
      <input type="hidden" name="cid" id="editCid">

      <input type="text"
             name="name"
             id="editName"
             required
             placeholder="Name"
             style="padding:8px; border-radius:6px;
                    border:none; background:#2b2b2b; color:#fff;">

      <input type="text"
             name="phone"
             id="editPhone"
             placeholder="Phone"
             style="padding:8px; border-radius:6px;
                    border:none; background:#2b2b2b; color:#fff;">

      <button type="submit"
              style="padding:10px;
                     border:none;
                     border-radius:6px;
                     background:linear-gradient(90deg,#00f2ff,#0066ff);
                     color:#fff;
                     font-weight:bold;
                     cursor:pointer;">
        Update
      </button>
    </form>
  </div>
</div>

</html>