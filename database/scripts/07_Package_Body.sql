
CREATE OR REPLACE PACKAGE BODY pkg_restaurant_ops IS

    FUNCTION fn_get_stock_level(p_ingredient_id NUMBER) RETURN NUMBER IS
        v_qty NUMBER;
    BEGIN
        SELECT stock_quantity INTO v_qty 
        FROM ingredients 
        WHERE ingredient_id = p_ingredient_id;
        RETURN v_qty;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
    END;

    FUNCTION fn_calculate_wait_time(p_order_id NUMBER) RETURN NUMBER IS
        v_total_minutes NUMBER := 0;
    BEGIN
        
        SELECT NVL(SUM(m.prep_time_min), 0) INTO v_total_minutes
        FROM kitchen_queue kq
        JOIN order_details od ON kq.detail_id = od.detail_id
        JOIN menu_items m ON od.menu_id = m.menu_id
        WHERE kq.status = 'WAITING';
        
        RETURN v_total_minutes;
    END;

  
    FUNCTION fn_is_table_available(p_table_id NUMBER) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT status INTO v_status FROM tables WHERE table_id = p_table_id;
        IF v_status = 'AVAILABLE' THEN RETURN 'Y'; ELSE RETURN 'N'; END IF;
    END;


    PROCEDURE sp_register_customer(
        p_first_name IN VARCHAR2, 
        p_last_name IN VARCHAR2, 
        p_phone IN VARCHAR2, 
        p_cust_id OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO customers (first_name, last_name, phone_number)
        VALUES (p_first_name, p_last_name, p_phone)
        RETURNING customer_id INTO p_cust_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Customer Registered. ID: ' || p_cust_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: Phone number already exists.');
    END;

   
    PROCEDURE sp_place_order(
        p_table_id IN NUMBER,
        p_cust_id IN NUMBER,
        p_menu_id IN NUMBER,
        p_qty IN NUMBER
    ) IS
        v_order_id NUMBER;
        v_price NUMBER;
        v_table_check VARCHAR2(1);
    BEGIN
    
        v_table_check := fn_is_table_available(p_table_id);
        IF v_table_check = 'N' THEN RAISE e_table_occupied; END IF;

       
        INSERT INTO orders (table_id, customer_id, status)
        VALUES (p_table_id, p_cust_id, 'PENDING')
        RETURNING order_id INTO v_order_id;

        
        SELECT price INTO v_price FROM menu_items WHERE menu_id = p_menu_id;

        
        INSERT INTO order_details (order_id, menu_id, quantity)
        VALUES (v_order_id, p_menu_id, p_qty);

        
        UPDATE orders SET total_amount = (v_price * p_qty) WHERE order_id = v_order_id;
        
    
        UPDATE tables SET status = 'OCCUPIED' WHERE table_id = p_table_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Order Placed Successfully. Order ID: ' || v_order_id);
        
    EXCEPTION
        WHEN e_table_occupied THEN
            DBMS_OUTPUT.PUT_LINE('Error: Table is currently occupied.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('System Error: ' || SQLERRM);
    END;

   
    PROCEDURE sp_process_kitchen_queue IS
        
        CURSOR c_queue IS 
            SELECT queue_id, detail_id FROM kitchen_queue WHERE status = 'WAITING';
            
        TYPE t_queue_tab IS TABLE OF c_queue%ROWTYPE;
        v_queue_list t_queue_tab;
    BEGIN
        OPEN c_queue;
        
        FETCH c_queue BULK COLLECT INTO v_queue_list;
        CLOSE c_queue;

        
        IF v_queue_list.COUNT > 0 THEN
            FORALL i IN 1..v_queue_list.COUNT
                UPDATE kitchen_queue 
                SET status = 'COOKING', started_at = SYSTIMESTAMP 
                WHERE queue_id = v_queue_list(i).queue_id;
                
            DBMS_OUTPUT.PUT_LINE('Processed ' || v_queue_list.COUNT || ' items to Cooking status.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Kitchen Queue is empty.');
        END IF;
        COMMIT;
    END;

END pkg_restaurant_ops;
/