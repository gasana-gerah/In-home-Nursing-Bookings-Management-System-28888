SELECT 
    p.full_name,
    n.license_no,
    s.name,
    TO_CHAR(b.scheduled_time, 'YYYY-MM-DD HH24:MI'),
    b.status
FROM bookings b
JOIN patients p ON b.patient_id = p.user_id
JOIN nurses n ON b.nurse_id = n.user_id
JOIN services s ON b.service_id = s.service_id
WHERE ROWNUM <= 10;

SELECT 
    s.name, 
    COUNT(b.booking_id) AS Total_Requests
FROM bookings b
JOIN services s ON b.service_id = s.service_id
GROUP BY s.name
ORDER BY Total_Requests DESC;

SELECT 
    payment_id, 
    booking_id, 
    amount, 
    method
FROM payments
WHERE amount > (SELECT AVG(amount) FROM payments)
ORDER BY amount DESC
FETCH FIRST 5 ROWS ONLY;

SELECT 'Patients' AS Table_Name, COUNT(*) AS Total_Rows FROM patients
UNION ALL
SELECT 'Nurses', COUNT(*) FROM nurses
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings;