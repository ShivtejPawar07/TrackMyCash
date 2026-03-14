<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border: none; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" style="color: var(--primary);"><i class="fa-solid fa-user-pen me-2"></i>Edit Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <% if ("updateExists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger m-3 p-2 fs-6" style="border-radius: 10px;">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Customer already exists.
                </div>
            <% } %>
            <form action="UpdateCustomerServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="cid" id="editCid">
                    <div class="mb-4">
                        <label class="form-label small text-muted fw-bold">NAME</label>
                        <input type="text" name="name" id="editName" class="form-control form-control-lg" required style="border-radius: 10px; border: 1px solid var(--border-light); font-weight: 500;">
                    </div>
                    <div class="mb-4">
                        <label class="form-label small text-muted fw-bold">PHONE NUMBER</label>
                        <input type="text" name="phone" id="editPhone" class="form-control form-control-lg" style="border-radius: 10px; border: 1px solid var(--border-light); font-weight: 500;">
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="submit" class="btn btn-primary w-100 py-3 fw-bold" style="border-radius: 12px; background: var(--primary); box-shadow: 0 4px 12px rgba(92, 103, 242, 0.3);">Update Customer Info</button>
                </div>
            </form>
        </div>
    </div>
</div>
