#In-home Nursing Bookings Management System**Oracle Database PL/SQL Capstone Project**

---

###**Student Information*** **Name:** Gerardine GASANA
* **Student ID:** 28888
* **Institution:** Adventist University of Central Africa (AUCA)
* **Course:** Database Development with PL/SQL (INSY 8311)
* **Lecturer:** Eric Maniraguha
* **Submission Date:** December 2025

---

##🚀 Project Navigation (Phases I - VIII)This repository is organized according to the 8-Phase Capstone Project structure. Below is the documentation, code, and evidence for each phase of development.

---

###**PHASE I: Problem Identification*** **Current Issue:** Manual phone coordination for home care leads to double-bookings and dangerous missed visits.
* **Pain Points:** Lack of audit trails makes compliance impossible; manual nurse matching is slow and geographically inefficient.
* **Key Goals:**
* Reduce double bookings to **0** via database constraints.
* Automate **Nurse-to-Patient matching** based on Skills (e.g., Wound Care) and Proximity.
* Ensure strict compliance with **Visit Logging** (Start/End times).


* **Key Deliverable:** [Project Overview & Objectives (PPT)](https://www.google.com/search?q=documentation/Grp_28888_Gerardine_NursingBooking_DB.pptx)

---

###**PHASE II: Business Process Modeling****Objective:** Model the business flow and system architecture.

* **Explanation:** The Business Process Model (BPMN) illustrates the end-to-end flow from **"Patient Booking Request"** to **"Nurse Dispatch"** and final **"Visit Log Verification."** It includes automated decision nodes for validating nurse availability and compliance.
* **📄 Documentation:**
* [View Business Process Model (BPMN Explanation)](https://www.google.com/search?q=documentation/Grp_28888_Gerardine_Nursing_Process.pdf)
* [View System Architecture](https://www.google.com/search?q=documentation/architecture.md)


* **🖼️ Evidence (BPMN Diagram):**

---

###**PHASE III: Logical Database Design****Objective:** Design a normalized Entity-Relationship (ER) model.

* **Explanation:** The database uses a **3NF schema** to ensure data integrity. The Logical Data Model details all core entities (**Patients, Nurses, Bookings, Services, Visit Logs**) and their relationships.
* **📄 Documentation:**
* [View Logical Data Model Report (PDF)](https://www.google.com/search?q=documentation/Grp_28888_Gerardine_Nursing_DataModel.pdf)
* [View Data Dictionary](https://www.google.com/search?q=documentation/data_dictionary.md)


* **🖼️ Evidence (ER Diagram):**

---

###**PHASE IV: Database Creation****Objective:** Configure the Oracle PDB and Environment.

* **Explanation:** Created the `NURSING_DB` pluggable database, configured `TBS_NURSING_DATA` tablespaces, and established the `ADMIN_NURSE` user with appropriate privileges.
* **📂 Files:** [View Admin Scripts](https://www.google.com/search?q=database/scripts/01_Database_Setup.sql)

---

###**PHASE V: Table Implementation & Data****Objective:** Create physical tables and populate with realistic data.

* **Explanation:** 10 Tables were created including `BOOKINGS` (Fact Table) and `ADMIN_CONFIG` (Control Table). A PL/SQL loop generated **500+ realistic booking records** with varying statuses (Completed, Cancelled, Pending) to simulate real-world usage.
* **📂 Code:** [Create Tables](https://www.google.com/search?q=database/scripts/03_Create_Tables.sql) | [Insert Data Script](https://www.google.com/search?q=database/scripts/04_Insert_Data.sql)
* **🖼️ Evidence (500+ Rows Generated):**

---

###**PHASE VI: PL/SQL Development****Objective:** Develop Procedures, Functions, and Packages.

* **Explanation:** All core logic is encapsulated in the `PKG_NURSING_OPS` package.
* `sp_request_booking`: Validates patient rules and initializes requests.
* `sp_auto_match`: Finds the best nurse based on **Skill + Rating**.
* `fn_calculate_cost`: Computes fees based on Service Type and Duration.


* **📂 Code:** [Package Specification](https://www.google.com/search?q=database/scripts/06_Package_Spec.sql) | [Package Body](https://www.google.com/search?q=database/scripts/07_Package_Body.sql)

---

###**PHASE VII: Advanced Programming & Security****Objective:** Implement Triggers, Auditing, and Restriction Rules.

* **CRITICAL RULE:** Administrative changes to `ADMIN_CONFIG` (e.g., Pay Rates) are **BLOCKED** on Weekdays (Mon-Fri) to ensure stability during peak operations.
* **Auditing:** All sensitive changes to Booking Status are logged via an **Autonomous Trigger** into `AUDIT_LOGS`.
* **📂 Code:** [Restriction Trigger](https://www.google.com/search?q=database/scripts/11_Restriction_Trigger.sql) | [Audit Trigger](https://www.google.com/search?q=database/scripts/12_Audit_Trigger.sql)

**🖼️ Evidence 1: System Blocking a Weekday Config Change**
*(The system correctly throws Error ORA-20005: "Maintenance Prohibited on Weekdays")*

**🖼️ Evidence 2: Audit Log Capturing the Attempt**
*(The audit trail recorded the "BLOCKED" action despite the transaction rollback)*

---

###**PHASE VIII: BI & Analytics****Objective:** Dashboards, KPIs, and Performance Tuning.

* **Explanation:** Analytical queries track **Nurse Utilization Rates** and **Missed Visit Ratios**. Performance is optimized using indexes on `scheduled_time` and `nurse_id`.
* **📂 Code:** [BI Reporting Queries](https://www.google.com/search?q=queries/bi_reporting_queries.sql)
* **📄 Full Report:** [View BI Dashboard Mockups (PDF)](https://www.google.com/search?q=business_intelligence/dashboards.pdf)

**🖼️ Evidence 1: Nurse Utilization (Visits per Specialist)**
*(Generated from Phase VIII Analytics)*

**🖼️ Evidence 2: Performance Tuning (Explain Plan)**
*(Proves use of Index Range Scans for date filtering)*

**🖼️ Evidence 3: System Monitoring (OEM Dashboard)**
*(Real-time database health monitoring)*

---

###**Declaration**I confirm that this work is original and complies with the academic integrity policy of AUCA. All code, documentation, and testing results were generated individually for this Capstone Project.