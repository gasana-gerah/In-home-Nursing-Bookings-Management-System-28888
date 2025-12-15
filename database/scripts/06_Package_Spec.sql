
CREATE OR REPLACE PACKAGE pkg_restaurant_ops IS
    
    e_insufficient_stock EXCEPTION;
    e_table_occupied     EXCEPTION;
    e_invalid_status     EXCEPTION;

 
    

    FUNCTION fn_get_stock_level(p_ingredient_id NUMBER) RETURN NUMBER;

    FUNCTION fn_calculate_wait_time(p_order_id NUMBER) RETURN NUMBER;
    

    FUNCTION fn_is_table_available(p_table_id NUMBER) RETURN VARCHAR2;


    PROCEDURE sp_register_customer(
        p_first_name IN VARCHAR2, 
        p_last_name IN VARCHAR2, 
        p_phone IN VARCHAR2, 
        p_cust_id OUT NUMBER 
    );

  
    PROCEDURE sp_place_order(
        p_table_id IN NUMBER,
        p_cust_id IN NUMBER,
        p_menu_id IN NUMBER,
        p_qty IN NUMBER
    );
    
    PROCEDURE sp_process_kitchen_queue;

END pkg_restaurant_ops;
/