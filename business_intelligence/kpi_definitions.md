# KPI Definitions
| KPI Name | Definition | Target | Frequency |
| :--- | :--- | :--- | :--- |
| **Revenue per Hour** | Sum of `total_amount` grouped by `HH24`. | > 50,000 RWF | Daily |
| **Kitchen Wait Time** | Avg duration between Order Placed and Served. | < 20 Mins | Real-time |
| **Dead Stock Rate** | % of Ingredients where `stock_quantity` < `reorder_level`. | < 5% | Daily |
| **Security Incidents** | Count of `BLOCKED` actions in `AUDIT_LOGS`. | 0 | Real-time |