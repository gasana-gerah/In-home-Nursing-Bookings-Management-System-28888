CREATE OR REPLACE TRIGGER trg_audit_booking_compound
FOR INSERT OR UPDATE OR DELETE ON bookings
COMPOUND TRIGGER
    v_user   VARCHAR2(50);
    v_action VARCHAR2(10);

    AFTER EACH ROW IS
    BEGIN
        v_user := USER;
        
        IF INSERTING THEN 
            v_action := 'INSERT';
        ELSIF UPDATING THEN 
            v_action := 'UPDATE';
        ELSIF DELETING THEN 
            v_action := 'DELETE';
        END IF;

        IF INSERTING OR (UPDATING AND :NEW.status != :OLD.status) THEN
            INSERT INTO audit_logs (table_name, action, user_name, change_date)
            VALUES ('BOOKINGS', v_action, v_user, SYSTIMESTAMP);
        END IF;
    END AFTER EACH ROW;

END trg_audit_booking_compound;
/