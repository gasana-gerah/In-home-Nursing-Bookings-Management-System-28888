DECLARE
    v_count NUMBER;
BEGIN

    SELECT count(*) INTO v_count FROM user_tables WHERE table_name = 'PUBLIC_HOLIDAYS';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE public_holidays (
            holiday_date DATE PRIMARY KEY, 
            description VARCHAR2(100)
        )';
        DBMS_OUTPUT.PUT_LINE('Table PUBLIC_HOLIDAYS created.');
    END IF;
END;
/

BEGIN

    INSERT INTO public_holidays VALUES (TO_DATE('2025-12-25', 'YYYY-MM-DD'), 'Christmas Day');

    INSERT INTO public_holidays VALUES (TO_DATE('2025-12-26', 'YYYY-MM-DD'), 'Boxing Day');

    INSERT INTO public_holidays VALUES (TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'New Year Day');

    INSERT INTO public_holidays VALUES (TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'Heroes Day');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Holiday data inserted successfully.');
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN 
        NULL;
END;
/