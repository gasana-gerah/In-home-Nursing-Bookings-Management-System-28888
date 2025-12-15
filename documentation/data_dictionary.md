# Data Dictionary: Smart Restaurant System
**Student:** Tricia Nshuti (27253)

| Table Name | Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- | :--- |
| **CUSTOMERS** | CUSTOMER_ID | NUMBER(5) | PK | Unique ID for registered customers |
| | PHONE_NUMBER | VARCHAR2(15) | UNIQUE | Contact number for notifications |
| **MENU_ITEMS** | MENU_ID | NUMBER(5) | PK | Unique dish identifier |
| | CATEGORY | VARCHAR2(50) | CHECK | Food group (Main, Dessert, etc.) |
| | PRICE | NUMBER(10,2) | CHECK > 0 | Unit cost in RWF |
| **ORDERS** | ORDER_ID | NUMBER(10) | PK | Transaction ticket number |
| | STATUS | VARCHAR2(20) | CHECK | Order state (Pending, Paid, Served) |
| **INGREDIENTS** | INGREDIENT_ID | NUMBER(5) | PK | Inventory tracking ID |
| | REORDER_LEVEL | NUMBER(10,2) | NOT NULL | Threshold for "Low Stock" alerts |
| **AUDIT_LOGS** | LOG_ID | NUMBER(10) | PK | Security trail ID |
| | ACTION | VARCHAR2(10) | - | Type of change (INSERT/UPDATE/BLOCK) |