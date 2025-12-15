CREATE OR REPLACE PACKAGE BODY pkg_nursing_ops IS

    FUNCTION fn_calculate_cost(p_service_id NUMBER) RETURN NUMBER IS
        v_price NUMBER;
    BEGIN
        SELECT base_price INTO v_price FROM services WHERE service_id = p_service_id;
        RETURN v_price;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
    END;

    FUNCTION fn_is_nurse_free(p_nurse_id NUMBER, p_time TIMESTAMP) RETURN VARCHAR2 IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM bookings 
        WHERE nurse_id = p_nurse_id 
          AND status = 'CONFIRMED'
          AND ABS(EXTRACT(HOUR FROM (scheduled_time - p_time))) < 2;
          
        IF v_count = 0 THEN RETURN 'Y'; ELSE RETURN 'N'; END IF;
    END;

    PROCEDURE sp_request_booking(
        p_patient_id IN NUMBER,
        p_service_id IN NUMBER,
        p_schedule   IN TIMESTAMP,
        p_booking_id OUT NUMBER
    ) IS
    BEGIN

        INSERT INTO bookings (patient_id, service_id, scheduled_time, status)
        VALUES (p_patient_id, p_service_id, p_schedule, 'PENDING')
        RETURNING booking_id INTO p_booking_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Booking Request Created. ID: ' || p_booking_id);
    END;

    PROCEDURE sp_auto_match_nurse(p_booking_id IN NUMBER) IS
        v_best_nurse_id NUMBER;
    BEGIN
        SELECT user_id INTO v_best_nurse_id
        FROM (
            SELECT user_id 
            FROM nurses n
            WHERE n.is_verified = 'Y' 
              AND n.rating >= 4.0
            ORDER BY n.rating DESC, DBMS_RANDOM.VALUE
        ) WHERE ROWNUM = 1;

        IF v_best_nurse_id IS NOT NULL THEN
            UPDATE bookings 
            SET nurse_id = v_best_nurse_id, status = 'CONFIRMED'
            WHERE booking_id = p_booking_id;
            
            DBMS_OUTPUT.PUT_LINE('Success: Matched Nurse ' || v_best_nurse_id || ' to Booking ' || p_booking_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Alert: No suitable nurse found for Booking ' || p_booking_id);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No nurses available in system.');
    END;

    PROCEDURE sp_log_visit(
        p_booking_id IN NUMBER,
        p_actual_start IN TIMESTAMP,
        p_actual_end IN TIMESTAMP,
        p_notes IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO visit_logs (booking_id, actual_start, actual_end, nurse_notes)
        VALUES (p_booking_id, p_actual_start, p_actual_end, p_notes);
        
        UPDATE bookings SET status = 'COMPLETED' WHERE booking_id = p_booking_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Visit Logged Successfully.');
    END;

END pkg_nursing_ops;
/