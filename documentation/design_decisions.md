# Design Decisions

1. **Compound Triggers:** Implemented `trg_audit_booking_compound` to efficiently handle `INSERT`, `UPDATE`, and `DELETE` events in a single block, avoiding "mutating table" errors during status updates.
2. **Autonomous Transactions:** Applied in `trg_restrict_admin_config` to ensure security violations are logged to `AUDIT_LOGS` even when the unauthorized transaction is rolled back.
3. **Packages:** Encapsulated all business logic (Matching, Booking, Logging) into `PKG_NURSING_OPS` to modularize code and improve database memory performance.
4. **Indexing:** Added indexes on `BOOKINGS(scheduled_time)` and `NURSES(specialization)` to optimize the "Auto-Match" algorithm and "Missed Visit" reporting queries.
