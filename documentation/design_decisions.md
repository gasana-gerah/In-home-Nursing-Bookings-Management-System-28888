# Design Decisions
1.  **Compound Triggers:** Used for Audit Logging to handle bulk operations efficiently and avoid mutating table errors.
2.  **Autonomous Transactions:** Used in Security Triggers to ensure `BLOCKED` attempts are logged even when the main transaction is rolled back.
3.  **Packages:** Grouped procedures into `PKG_RESTAURANT_OPS` to improve code organization and compilation performance.
4.  **Indexing:** Added indexes on `customer_id` and `order_date` to optimize the performance of the "Sales by Category" report.