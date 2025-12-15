INSERT INTO services VALUES (101, 'General Wound Care', 15000, 45);
INSERT INTO services VALUES (102, 'Postnatal Checkup', 25000, 60);
INSERT INTO services VALUES (103, 'IV Injection / Infusion', 10000, 30);
INSERT INTO services VALUES (104, 'Elderly Hygiene Care', 20000, 90);
INSERT INTO services VALUES (105, 'Physiotherapy Session', 30000, 60);

INSERT INTO admin_config VALUES ('MAX_DAILY_VISITS', '5', SYSDATE);
INSERT INTO admin_config VALUES ('BASE_TAX_RATE', '0.18', SYSDATE);

COMMIT;

DECLARE
    v_user_id NUMBER;
    v_nurse_id NUMBER;
    v_booking_id NUMBER;
    v_service_id NUMBER;
    v_price NUMBER;
    v_status VARCHAR2(20);
    v_schedule DATE;
BEGIN

    FOR i IN 1..50 LOOP
        INSERT INTO users (username, password_hash, role)
        VALUES ('patient' || i, 'hash123', 'PATIENT')
        RETURNING user_id INTO v_user_id;

        INSERT INTO patients (user_id, full_name, dob, address, medical_notes)
        VALUES (v_user_id, 'Patient ' || i, TO_DATE('1980-01-01','YYYY-MM-DD') + i, 
                'Kigali Sector ' || MOD(i, 10), 'Chronic condition example');
    END LOOP;

    FOR i IN 1..20 LOOP
        INSERT INTO users (username, password_hash, role)
        VALUES ('nurse' || i, 'hash123', 'NURSE')
        RETURNING user_id INTO v_user_id;

        INSERT INTO nurses (user_id, license_no, specialization, rating, hourly_rate, is_verified)
        VALUES (v_user_id, 'RN-' || 1000+i, 
                CASE MOD(i, 3) 
                    WHEN 0 THEN 'Wound Care' 
                    WHEN 1 THEN 'Pediatrics' 
                    ELSE 'General Practice' 
                END,
                4.0 + (MOD(i,10)/10), 15000, 'Y');
    END LOOP;

    FOR i IN 1..500 LOOP

        SELECT user_id INTO v_user_id FROM (SELECT user_id FROM patients ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;
        SELECT service_id, base_price INTO v_service_id, v_price FROM services ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY;
        
        SELECT user_id INTO v_nurse_id FROM (SELECT user_id FROM nurses ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;

        v_schedule := SYSDATE + DBMS_RANDOM.VALUE(-60, 30);
        
        IF v_schedule < SYSDATE THEN
            v_status := 'COMPLETED';
        ELSE
            v_status := 'PENDING';
        END IF;

        INSERT INTO bookings (patient_id, nurse_id, service_id, status, scheduled_time, created_date)
        VALUES (v_user_id, v_nurse_id, v_service_id, v_status, v_schedule, v_schedule - 2)
        RETURNING booking_id INTO v_booking_id;

        IF v_status = 'COMPLETED' THEN
            INSERT INTO visit_logs (booking_id, actual_start, actual_end, nurse_notes)
            VALUES (v_booking_id, v_schedule, v_schedule + (1/24), 'Visit completed successfully. Patient stable.');

            INSERT INTO payments (booking_id, amount, method)
            VALUES (v_booking_id, v_price, 'MOMO');
        END IF;

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data Generation Complete: 50 Patients, 20 Nurses, 500+ Bookings.');
END;
/