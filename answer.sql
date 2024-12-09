-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change

SELECT
DATE(datetime(login_timestamp, 'unixepoch')) AS login_date,
COUNT(DISTINCT user_id) AS unique_users
FROM login_history
GROUP BY login_date
ORDER BY login_date;


-- PART 2: Create a SQL query that indicates the number of status changes by card


SELECT 
    cardID,
    COUNT(*) AS status_change_count
FROM 
    card_change_history
WHERE 
    oldStatus IS NOT NULL -- Exclude initial status entries
GROUP BY 
    cardID
ORDER BY 
    cardID;


