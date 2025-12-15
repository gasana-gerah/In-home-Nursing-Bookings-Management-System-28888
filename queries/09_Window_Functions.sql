
SELECT 
    c.first_name || ' ' || c.last_name AS Customer_Name,
    COUNT(o.order_id) as Total_Orders,
    SUM(o.total_amount) as Total_Spent,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) as Spending_Rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
FETCH FIRST 10 ROWS ONLY;

SELECT 
    order_id,
    order_date,
    total_amount,
    LAG(total_amount, 1, 0) OVER (ORDER BY order_date) as Previous_Order_Amt,
    total_amount - LAG(total_amount, 1, 0) OVER (ORDER BY order_date) as Difference
FROM orders
WHERE status = 'PAID'
FETCH FIRST 10 ROWS ONLY;

SELECT 
    category,
    item_name,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as Price_Rank_In_Cat
FROM menu_items;