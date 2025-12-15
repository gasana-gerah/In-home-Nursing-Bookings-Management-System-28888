# System Architecture
**Database:** Oracle Database 21c XE
**Tools:** SQL Developer, SQL*Plus
**Architecture Type:** Client-Server (Two-Tier)

## Layers
1.  **Data Layer:** Oracle Tables with constraints and indexes.
2.  **Logic Layer:** PL/SQL Packages (`PKG_RESTAURANT_OPS`) handling business rules.
3.  **Security Layer:** Triggers (`TRG_RESTRICT_MENU`) enforcing access control.
4.  **Presentation Layer:** BI Dashboards (Mockups) and Reporting Queries.