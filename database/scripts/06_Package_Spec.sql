CREATE OR REPLACE PACKAGE pkg_nursing_ops IS
    
    e_nurse_unavailable  EXCEPTION;
    e_invalid_status     EXCEPTION;
    e_duplicate_booking  EXCEPTION;

    FUNCTION fn_calculate_cost(p_service_id NUMBER) RETURN NUMBER;

    FUNCTION fn_is_nurse_free(p_nurse_id NUMBER, p_time TIMESTAMP) RETURN VARCHAR2;

    PROCEDURE sp_request_booking(
        p_patient_id IN NUMBER,
        p_service_id IN NUMBER,
        p_schedule   IN TIMESTAMP,
        p_booking_id OUT NUMBER
    );

    PROCEDURE sp_auto_match_nurse(
        p_booking_id IN NUMBER
    );
    
    PROCEDURE sp_log_visit(
        p_booking_id IN NUMBER,
        p_actual_start IN TIMESTAMP,
        p_actual_end IN TIMESTAMP,
        p_notes IN VARCHAR2
    );

END pkg_nursing_ops;
/