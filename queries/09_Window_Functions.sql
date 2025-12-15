SELECT 
    p.full_name,
    COUNT(b.booking_id) AS Total_Visits,
    SUM(pay.amount) AS Total_Spent,
    DENSE_RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS Spending_Rank
FROM patients p
JOIN bookings b ON p.user_id = b.patient_id
JOIN payments pay ON b.booking_id = pay.booking_id
GROUP BY p.user_id, p.full_name
FETCH FIRST 10 ROWS ONLY;

SELECT 
    payment_id,
    payment_date,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY payment_date) AS Previous_Payment,
    amount - LAG(amount, 1, 0) OVER (ORDER BY payment_date) AS Diff_From_Last
FROM payments
ORDER BY payment_date DESC
FETCH FIRST 10 ROWS ONLY;

SELECT 
    specialization,
    license_no,
    rating,
    hourly_rate,
    ROW_NUMBER() OVER (PARTITION BY specialization ORDER BY rating DESC) AS Rank_In_Specialty
FROM nurses;