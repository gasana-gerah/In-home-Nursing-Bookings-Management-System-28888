CREATE OR REPLACE TRIGGER trg_audit_menu_compound
FOR INSERT OR UPDATE OR DELETE ON menu_items
COMPOUND TRIGGER
    v_user   VARCHAR2(50);
    v_action VARCHAR2(10);

    AFTER EACH ROW IS
    BEGIN
        v_user := USER;
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSIF DELETING THEN v_action := 'DELETE';
        END IF;

        INSERT INTO audit_logs (table_name, action, user_name, change_date)
        VALUES ('MENU_ITEMS', v_action, v_user, SYSTIMESTAMP);
    END AFTER EACH ROW;
END trg_audit_menu_compound;
/