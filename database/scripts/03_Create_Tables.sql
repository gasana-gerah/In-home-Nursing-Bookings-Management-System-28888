BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE seq_cust_id START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_order_id START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE seq_detail_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_queue_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_txn_id START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE seq_notif_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_log_id START WITH 1 INCREMENT BY 1;

CREATE TABLE customers (
    customer_id NUMBER(5) DEFAULT seq_cust_id.NEXTVAL PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    phone_number VARCHAR2(15) UNIQUE,
    email VARCHAR2(100),
    loyalty_points NUMBER(5) DEFAULT 0,
    registration_date DATE DEFAULT SYSDATE
);


CREATE TABLE tables (
    table_id NUMBER(3) PRIMARY KEY,
    table_number NUMBER(3) UNIQUE NOT NULL,
    capacity NUMBER(2) CHECK (capacity > 0),
    status VARCHAR2(20) CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'RESERVED'))
);


CREATE TABLE menu_items (
    menu_id NUMBER(5) PRIMARY KEY,
    item_name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50) CHECK (category IN ('APPETIZER','MAIN','DESSERT','BEVERAGE')),
    price NUMBER(10,2) CHECK (price > 0),
    prep_time_min NUMBER(3) NOT NULL,
    is_available CHAR(1) DEFAULT 'Y' CHECK (is_available IN ('Y', 'N'))
);


CREATE TABLE ingredients (
    ingredient_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(100) UNIQUE NOT NULL,
    stock_quantity NUMBER(10,2) CHECK (stock_quantity >= 0),
    reorder_level NUMBER(10,2) NOT NULL,
    unit_measure VARCHAR2(20)
);


CREATE TABLE recipes (
    recipe_id NUMBER(5) PRIMARY KEY,
    menu_id NUMBER(5) REFERENCES menu_items(menu_id),
    ingredient_id NUMBER(5) REFERENCES ingredients(ingredient_id),
    qty_needed NUMBER(10,2) CHECK (qty_needed > 0)
);


CREATE TABLE orders (
    order_id NUMBER(10) DEFAULT seq_order_id.NEXTVAL PRIMARY KEY,
    table_id NUMBER(3) REFERENCES tables(table_id),
    customer_id NUMBER(5) REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    status VARCHAR2(20) CHECK (status IN ('PENDING', 'READY', 'SERVED', 'PAID', 'CANCELLED')),
    total_amount NUMBER(10,2) DEFAULT 0
);


CREATE TABLE order_details (
    detail_id NUMBER(10) DEFAULT seq_detail_id.NEXTVAL PRIMARY KEY,
    order_id NUMBER(10) REFERENCES orders(order_id) ON DELETE CASCADE,
    menu_id NUMBER(5) REFERENCES menu_items(menu_id),
    quantity NUMBER(3) CHECK (quantity > 0),
    item_status VARCHAR2(20) DEFAULT 'PENDING'
);


CREATE TABLE kitchen_queue (
    queue_id NUMBER(10) DEFAULT seq_queue_id.NEXTVAL PRIMARY KEY,
    detail_id NUMBER(10) REFERENCES order_details(detail_id),
    priority_score NUMBER(5),
    status VARCHAR2(20) DEFAULT 'WAITING',
    started_at TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE transactions (
    txn_id NUMBER(10) DEFAULT seq_txn_id.NEXTVAL PRIMARY KEY,
    order_id NUMBER(10) REFERENCES orders(order_id),
    amount_paid NUMBER(10,2),
    payment_method VARCHAR2(20) CHECK (payment_method IN ('CASH', 'CARD', 'MOMO')),
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE notifications (
    notif_id NUMBER(10) DEFAULT seq_notif_id.NEXTVAL PRIMARY KEY,
    order_id NUMBER(10) REFERENCES orders(order_id),
    message VARCHAR2(255),
    sent_time TIMESTAMP DEFAULT SYSTIMESTAMP,
    status VARCHAR2(20) DEFAULT 'SENT'
);


CREATE TABLE audit_logs (
    log_id NUMBER(10) DEFAULT seq_log_id.NEXTVAL PRIMARY KEY,
    table_name VARCHAR2(30),
    action VARCHAR2(10),
    user_name VARCHAR2(30),
    change_date TIMESTAMP DEFAULT SYSTIMESTAMP
);


CREATE INDEX idx_cust_phone ON customers(phone_number);
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_menu_cat ON menu_items(category);


SELECT table_name FROM user_tables ORDER BY table_name;