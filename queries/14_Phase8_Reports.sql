SELECT 
    s.name AS Service_Name,
    COUNT(b.booking_id) AS Total_Bookings,
    TO_CHAR(SUM(p.amount), 'L99,999,999') AS Total_Revenue,
    ROUND(AVG(p.amount), 2) AS Avg_Cost_Per_Visit
FROM bookings b
JOIN services s ON b.service_id = s.service_id
JOIN payments p ON b.booking_id = p.booking_id
GROUP BY s.name
ORDER BY SUM(p.amount) DESC;

SELECT 
    TO_CHAR(scheduled_time, 'HH24') || ':00' AS Hour_of_Day,
    COUNT(booking_id) AS Visit_Volume,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS Completed_Visits
FROM bookings
GROUP BY TO_CHAR(scheduled_time, 'HH24')
ORDER BY Visit_Volume DESC;

SELECT 
    b.booking_id,
    p.full_name AS Patient,
    s.name AS Service_Required,
    b.scheduled_time,
    ROUND(SYSDATE - b.scheduled_time, 1) AS Days_Overdue,
    CASE 
        WHEN (SYSDATE - b.scheduled_time) > 7 THEN 'CRITICAL - Missed > 1 Week'
        WHEN (SYSDATE - b.scheduled_time) > 1 THEN 'WARNING - Missed > 24 Hours'
        ELSE 'Review Needed'
    END AS Compliance_Status
FROM bookings b
JOIN patients p ON b.patient_id = p.user_id
JOIN services s ON b.service_id = s.service_id
WHERE b.status = 'PENDING' 
AND b.scheduled_time < SYSDATE
ORDER BY b.scheduled_time ASC;