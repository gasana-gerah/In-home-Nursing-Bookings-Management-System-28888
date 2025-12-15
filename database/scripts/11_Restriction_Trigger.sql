CREATE OR REPLACE TRIGGER trg_restrict_admin_config
BEFORE INSERT OR UPDATE OR DELETE ON admin_config
FOR EACH ROW
DECLARE
    v_day_of_week VARCHAR2(10);
    v_is_holiday  NUMBER;
    
    PROCEDURE log_violation(p_msg VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO audit_logs (table_name, action, user_name, change_date)
        VALUES ('ADMIN_CONFIG', 'BLOCKED', USER, SYSTIMESTAMP);
        COMMIT;
    END;

BEGIN

    SELECT TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') INTO v_day_of_week FROM DUAL;

    SELECT COUNT(*) INTO v_is_holiday 
    FROM public_holidays 
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);


    IF v_day_of_week IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_is_holiday > 0 THEN
        
        log_violation('Attempted config change during restricted period');
        
        RAISE_APPLICATION_ERROR(-20005, 'SECURITY ALERT: Maintenance is restricted on Weekdays and Public Holidays.');
        
    END IF;
END;
/