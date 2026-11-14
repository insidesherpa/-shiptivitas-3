-- PART 1: Create a SQL query that maps out the daily active users before and after the feature change
SELECT 
    DATE(login_timestamp, 'unixepoch') AS activity_date, 
    COUNT(DISTINCT user_id) AS daily_active_users
FROM 
    login_history 
GROUP BY 
    DATE(login_timestamp, 'unixepoch')
ORDER BY 
    activity_date ASC;

-- PART 2: Create a SQL query that indicates the number of status changes by card
SELECT 
    cardID, 
    COUNT(id) AS total_status_changes
FROM 
    card_change_history
WHERE 
    oldStatus IS NOT newStatus
GROUP BY 
    cardID
ORDER BY 
    total_status_changes DESC;

