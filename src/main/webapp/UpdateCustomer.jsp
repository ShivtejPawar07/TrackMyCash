<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background: #0f172a; border: 1px solid var(--accent-cyan); border-radius: 20px; box-shadow: 0 0 30px rgba(6, 182, 212, 0.2);">
            <div class="modal-header border-0 pb-0" style="padding: 25px;">
                <h5 class="modal-title fw-bold" style="color: var(--text-primary); font-family: 'Orbitron', sans-serif; letter-spacing: 1px;"><i class="fa-solid fa-user-pen me-2 text-cyan"></i>UPDATE IDENTITY</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <% if ("updateExists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger m-3 p-2 fs-6" style="background: rgba(239, 68, 68, 0.1); border: 1px solid var(--accent-red); border-radius: 12px; color: var(--accent-red);">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Identity already in database.
                </div>
            <% } %>
            <form action="UpdateCustomerServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="cid" id="editCid">
                    <div class="mb-4">
                        <label class="form-label small text-secondary fw-bold" style="letter-spacing: 1px;">ENTITY NAME</label>
                        <input type="text" name="name" id="editName" class="form-control" required style="background: rgba(255, 255, 255, 0.05); border: 1px solid var(--glass-border); border-radius: 10px; color: white !important; padding: 12px;">
                    </div>
                    <div class="mb-4">
                        <label class="form-label small text-secondary fw-bold" style="letter-spacing: 1px;">CONTACT CHANNEL</label>
                        <input type="text" name="phone" id="editPhone" class="form-control" style="background: rgba(255, 255, 255, 0.05); border: 1px solid var(--glass-border); border-radius: 10px; color: white !important; padding: 12px;">
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0" style="padding: 20px;">
                    <button type="submit" class="btn btn-cyan w-100 py-3 fw-bold" style="background: var(--accent-cyan); color: #020617; border-radius: 12px; border: none;">SYNC CHANGES</button>
                </div>
            </form>
        </div>
    </div>
</div>
