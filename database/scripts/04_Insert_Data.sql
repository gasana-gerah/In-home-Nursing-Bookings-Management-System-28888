
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO tables (table_id, table_number, capacity, status)
        VALUES (i, i, 4, 'AVAILABLE');
    END LOOP;
    COMMIT;
END;
/

INSERT INTO menu_items VALUES (101, 'Grilled Tilapia', 'MAIN', 8000, 25, 'Y');
INSERT INTO menu_items VALUES (102, 'Beef Brochette', 'MAIN', 4000, 15, 'Y');
INSERT INTO menu_items VALUES (103, 'Chicken Curry', 'MAIN', 7500, 20, 'Y');
INSERT INTO menu_items VALUES (104, 'Vegetable Sambaza', 'APPETIZER', 3000, 10, 'Y');
INSERT INTO menu_items VALUES (105, 'Fruit Salad', 'DESSERT', 3500, 5, 'Y');
INSERT INTO menu_items VALUES (106, 'Passion Juice', 'BEVERAGE', 2000, 2, 'Y');
INSERT INTO menu_items VALUES (107, 'Heineken', 'BEVERAGE', 2500, 1, 'Y');
INSERT INTO menu_items VALUES (108, 'Chips', 'APPETIZER', 2000, 10, 'Y');


INSERT INTO ingredients VALUES (1, 'Raw Tilapia', 50, 10, 'kg');
INSERT INTO ingredients VALUES (2, 'Beef', 100, 20, 'kg');
INSERT INTO ingredients VALUES (3, 'Potatoes', 200, 30, 'kg');
INSERT INTO ingredients VALUES (4, 'Cooking Oil', 50, 5, 'liters');
INSERT INTO ingredients VALUES (5, 'Passion Fruit', 60, 10, 'kg');


INSERT INTO recipes VALUES (1, 101, 1, 0.5);
INSERT INTO recipes VALUES (2, 108, 3, 0.3);
INSERT INTO recipes VALUES (3, 108, 4, 0.1);

COMMIT;


DECLARE
    v_cust_id NUMBER;
    v_order_id NUMBER;
    v_menu_id NUMBER;
    v_price NUMBER;
BEGIN
    
    FOR i IN 1..100 LOOP
        INSERT INTO customers (first_name, last_name, phone_number, email)
        VALUES ('Customer' || i, 'Rwanda', '0780000' || LPAD(i, 3, '0'), 'user' || i || '@gmail.com');
    END LOOP;

 
    FOR i IN 1..400 LOOP
        
        SELECT customer_id INTO v_cust_id 
        FROM (SELECT customer_id FROM customers ORDER BY dbms_random.value) 
        WHERE rownum = 1;

        INSERT INTO orders (table_id, customer_id, status, total_amount)
        VALUES (TRUNC(DBMS_RANDOM.VALUE(1, 20)), v_cust_id, 'PAID', 0) 
        RETURNING order_id INTO v_order_id;

        
        FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 4)) LOOP
            SELECT menu_id, price INTO v_menu_id, v_price 
            FROM menu_items ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY;
            
            INSERT INTO order_details (order_id, menu_id, quantity) VALUES (v_order_id, v_menu_id, 1);
            UPDATE orders SET total_amount = total_amount + v_price WHERE order_id = v_order_id;
        END LOOP;
        
        
        INSERT INTO transactions (order_id, amount_paid, payment_method)
        VALUES (v_order_id, (SELECT total_amount FROM orders WHERE order_id = v_order_id), 'CASH');
    END LOOP;
    COMMIT;
END;
/