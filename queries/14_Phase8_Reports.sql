
-- REPORT 1: Sales Performance by Category (Financial Report)
-- Q: Which food category makes the most money?
SELECT 
    m.category,
    COUNT(od.detail_id) AS Total_Items_Sold,
    TO_CHAR(SUM(m.price * od.quantity), 'L99,999,999') AS Total_Revenue,
    ROUND(AVG(m.price), 2) AS Avg_Item_Price
FROM order_details od
JOIN menu_items m ON od.menu_id = m.menu_id
GROUP BY m.category
ORDER BY SUM(m.price * od.quantity) DESC;

-- REPORT 2: Waiter Performance / Busy Hours (Operational Report)
-- Q: What are our busiest hours of the day?
SELECT 
    TO_CHAR(order_date, 'HH24') || ':00' AS Hour_of_Day,
    COUNT(order_id) AS Orders_Placed,
    SUM(total_amount) AS Hourly_Revenue
FROM orders
WHERE status = 'PAID'
GROUP BY TO_CHAR(order_date, 'HH24')
ORDER BY Orders_Placed DESC;

-- REPORT 3: "Dead Stock" Inventory Alert (Inventory Report)
-- Q: Which ingredients are running low (below reorder level)?
SELECT 
    name AS Ingredient,
    stock_quantity AS Current_Stock,
    reorder_level AS Alert_Level,
    (stock_quantity - reorder_level) AS Gap,
    CASE 
        WHEN stock_quantity <= reorder_level THEN 'CRITICAL'
        WHEN stock_quantity <= (reorder_level * 1.5) THEN 'WARNING'
        ELSE 'OK'
    END AS Status
FROM ingredients
ORDER BY stock_quantity ASC;