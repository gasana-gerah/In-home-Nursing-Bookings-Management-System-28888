BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE seq_user_id START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_booking_id START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE seq_log_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pay_id START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_id START WITH 1 INCREMENT BY 1;

CREATE TABLE users (
    user_id NUMBER(10) DEFAULT seq_user_id.NEXTVAL PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    password_hash VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) CHECK (role IN ('PATIENT', 'NURSE', 'ADMIN')),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE patients (
    user_id NUMBER(10) PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    full_name VARCHAR2(100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR2(200) NOT NULL,
    medical_notes VARCHAR2(1000)
);

CREATE TABLE nurses (
    user_id NUMBER(10) PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    license_no VARCHAR2(50) UNIQUE NOT NULL,
    specialization VARCHAR2(100) NOT NULL,
    rating NUMBER(2,1) DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
    hourly_rate NUMBER(10,2) CHECK (hourly_rate > 0),
    is_verified CHAR(1) DEFAULT 'N' CHECK (is_verified IN ('Y', 'N'))
);

CREATE TABLE services (
    service_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    base_price NUMBER(10,2) CHECK (base_price > 0),
    duration_min NUMBER(3) NOT NULL
);

CREATE TABLE bookings (
    booking_id NUMBER(10) DEFAULT seq_booking_id.NEXTVAL PRIMARY KEY,
    patient_id NUMBER(10) REFERENCES patients(user_id),
    nurse_id NUMBER(10) REFERENCES nurses(user_id),
    service_id NUMBER(5) REFERENCES services(service_id),
    status VARCHAR2(20) CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    scheduled_time TIMESTAMP NOT NULL,
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE visit_logs (
    log_id NUMBER(10) DEFAULT seq_log_id.NEXTVAL PRIMARY KEY,
    booking_id NUMBER(10) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    actual_start TIMESTAMP NOT NULL,
    actual_end TIMESTAMP NOT NULL,
    nurse_notes VARCHAR2(1000)
);

CREATE TABLE payments (
    payment_id NUMBER(10) DEFAULT seq_pay_id.NEXTVAL PRIMARY KEY,
    booking_id NUMBER(10) REFERENCES bookings(booking_id),
    amount NUMBER(10,2) NOT NULL,
    method VARCHAR2(20) CHECK (method IN ('CASH', 'MOMO', 'CARD')),
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE admin_config (
    config_key VARCHAR2(50) PRIMARY KEY,
    config_value VARCHAR2(100) NOT NULL,
    last_updated DATE DEFAULT SYSDATE
);

CREATE TABLE audit_logs (
    audit_id NUMBER(10) DEFAULT seq_audit_id.NEXTVAL PRIMARY KEY,
    table_name VARCHAR2(30),
    action VARCHAR2(10),
    user_name VARCHAR2(50),
    change_date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX idx_booking_date ON bookings(scheduled_time);
CREATE INDEX idx_nurse_spec ON nurses(specialization);
CREATE INDEX idx_booking_status ON bookings(status);

PROMPT Tables Created Successfully.