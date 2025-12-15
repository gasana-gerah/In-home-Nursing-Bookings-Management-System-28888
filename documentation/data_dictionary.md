# Data Dictionary: In-Home Nursing Bookings System

**Student:** Gerardine GASANA (28888)

| Table Name | Column | Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| **USERS** | USER_ID | NUMBER(10) | PK | Unique system identifier for login |
|  | USERNAME | VARCHAR2(50) | UNIQUE, NOT NULL | Login credential |
|  | ROLE | VARCHAR2(20) | CHECK IN ('PATIENT','NURSE','ADMIN') | Access level discriminator |
| **PATIENTS** | USER_ID | NUMBER(10) | PK, FK | Link to USERS table |
|  | ADDRESS | VARCHAR2(200) | NOT NULL | Home location for visits |
|  | DOB | DATE | NOT NULL | Date of Birth for age validation |
| **NURSES** | USER_ID | NUMBER(10) | PK, FK | Link to USERS table |
|  | LICENSE_NO | VARCHAR2(50) | UNIQUE | Professional medical license ID |
|  | RATING | NUMBER(2,1) | CHECK (0-5) | Average customer satisfaction score |
|  | SPECIALIZATION | VARCHAR2(100) | NOT NULL | e.g., 'Wound Care', 'Pediatrics' |
| **SERVICES** | SERVICE_ID | NUMBER(5) | PK | Unique medical service ID |
|  | NAME | VARCHAR2(100) | NOT NULL | Service name (e.g., 'Injection') |
|  | BASE_PRICE | NUMBER(10,2) | CHECK > 0 | Cost per visit in RWF |
|  | DURATION_MIN | NUMBER(3) | NOT NULL | Expected time (minutes) |
| **BOOKINGS** | BOOKING_ID | NUMBER(10) | PK | Unique transaction ID |
|  | PATIENT_ID | NUMBER(10) | FK | Who requested the service |
|  | NURSE_ID | NUMBER(10) | FK | Assigned nurse |
|  | STATUS | VARCHAR2(20) | CHECK IN ('PENDING', 'CONFIRMED') | Workflow state of the booking |
|  | SCHEDULED_TIME | TIMESTAMP | NOT NULL | Planned start time of visit |
| **VISIT_LOGS** | LOG_ID | NUMBER(10) | PK | Proof of visit execution |
|  | BOOKING_ID | NUMBER(10) | FK | Link to original booking |
|  | ACTUAL_START | TIMESTAMP | NOT NULL | Nurse arrival timestamp |
|  | ACTUAL_END | TIMESTAMP | NOT NULL | Nurse departure timestamp |
| **ADMIN_CONFIG** | CONFIG_KEY | VARCHAR2(50) | PK | Setting name (Target for Weekday Rule) |
|  | LAST_UPDATED | DATE | NOT NULL | Timestamp of last setting change |
| **AUDIT_LOGS** | AUDIT_ID | NUMBER(10) | PK | Security tracking ID |
|  | TABLE_NAME | VARCHAR2(30) | NOT NULL | Target of the modification |
|  | ACTION | VARCHAR2(10) | CHECK IN ('INSERT','UPDATE') | Type of database operation |
