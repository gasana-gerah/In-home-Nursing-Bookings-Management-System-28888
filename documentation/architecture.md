#System Architecture**Database:** Oracle Database 21c XE
**Tools:** SQL Developer, SQL*Plus, Data Modeler
**Architecture Type:** Client-Server (Two-Tier)

##Layers1. **Data Layer:**
* **Core Entities:** Oracle Tables (`PATIENTS`, `NURSES`, `BOOKINGS`, `VISIT_LOGS`) designed in 3NF to ensure data integrity.
* **Constraints:** Primary Keys, Foreign Keys, and Check constraints (e.g., preventing negative durations or invalid status).
* **Optimization:** Indexes on frequent query columns like `SCHEDULED_TIME` and `LICENSE_NO`.


2. **Logic Layer:**
* **Encapsulation:** PL/SQL Package (`PKG_NURSING_OPS`) serves as the API for all operations.
* **Business Rules:** Stored Procedures handle complex logic such as `SP_AUTO_MATCH_NURSE` (matching algorithms) and `SP_LOG_VISIT` (compliance verification).
* **Automation:** Jobs and schedulers (simulated) for sending visit reminders.


3. **Security Layer:**
* **Access Control:** Triggers (`TRG_PREVENT_WEEKDAY_CHANGES`) strictly enforce the academic rule blocking administrative updates on weekdays.
* **Audit Compliance:** Autonomous Triggers (`TRG_AUDIT_SENSITIVE_DATA`) capture every modification to booking records in the `AUDIT_LOGS` table.


4. **Presentation Layer:**
* **Reporting:** SQL scripts generating Key Performance Indicators (Nurse Utilization Rates, Missed Visit Ratios).
* **Analytics:** BI Dashboard mockups visualizing demand heatmaps and financial performance.
