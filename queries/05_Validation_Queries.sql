
SELECT c.first_name, o.order_date, m.item_name, od.quantity, m.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items m ON od.menu_id = m.menu_id
WHERE ROWNUM <= 10;


SELECT m.item_name, COUNT(od.menu_id) AS Total_Sold
FROM order_details od
JOIN menu_items m ON od.menu_id = m.menu_id
GROUP BY m.item_name
ORDER BY Total_Sold DESC;


SELECT order_id, total_amount, status
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC
FETCH FIRST 5 ROWS ONLY;

SELECT 'Customers' as Tbl, COUNT(*) as Rows_Count FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders;