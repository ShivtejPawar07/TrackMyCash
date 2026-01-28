<div id="editCustomerModal"
     style="display:none; position:fixed; top:0; left:0;
            width:100%; height:100%;
            background:rgba(0,0,0,0.6);
            justify-content:center;
            align-items:center;
            z-index:1000;">

  <div style="background:#1e1e1e; padding:20px; border-radius:8px; width:300px; position:relative;">

    <span onclick="closeEditModal()" style="position:absolute; top:10px; right:12px; cursor:pointer; color:#fff;">&times;</span>

    <h3 style="color:#00f2ff;">Edit Customer</h3>

    <% if ("updateExists".equals(request.getParameter("error"))) { %>
      <div style="color:#ff4d4d; margin-bottom:10px;">
        Customer already exists
      </div>
    <% } %>

    <form action="UpdateCustomerServlet" method="post">
      <input type="hidden" name="cid" id="editCid">

      <input type="text" name="name" id="editName" required>
      <input type="text" name="phone" id="editPhone">

      <button type="submit">Update</button>
    </form>
  </div>
</div>
