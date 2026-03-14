<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background-color: #1e293b; color: #f8fafc; border: 1px solid #334155; border-radius: 16px;">
            <div class="modal-header" style="border-bottom: 1px solid #334155;">
                <h5 class="modal-title fw-bold" style="color: #3b82f6;"><i class="fa-solid fa-user-pen me-2"></i>Edit Customer</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" onclick="closeEditModal()"></button>
            </div>
            <% if ("updateExists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger m-3 p-2 fs-6">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Customer already exists.
                </div>
            <% } %>
            <form action="UpdateCustomerServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="cid" id="editCid">
                    <div class="mb-3">
                        <label class="form-label" style="color: #94a3b8; font-weight: 500;">Name</label>
                        <input type="text" name="name" id="editName" class="form-control" required style="background-color: #0f172a; border: 1px solid #334155; color: #f8fafc;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="color: #94a3b8; font-weight: 500;">Phone Number</label>
                        <input type="text" name="phone" id="editPhone" class="form-control" style="background-color: #0f172a; border: 1px solid #334155; color: #f8fafc;">
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()" style="border-radius: 8px;">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, #3b82f6, #8b5cf6); border: none; border-radius: 8px;">Update Customer</button>
                </div>
            </form>
        </div>
    </div>
</div>
