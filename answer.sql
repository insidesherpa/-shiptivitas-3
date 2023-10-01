-- TYPE YOUR SQL QUERY BELOW


-- I tried my best to understand the task but couldn't wrap my head around it. Wish there were more explanation 

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change

-- Calculate daily average users before the feature change
SELECT
    DATE(date_column) AS date,
    AVG(users) AS daily_avg_users_before
FROM
    user_activity
WHERE
    date_column < 'feature_change_date'
GROUP BY
    DATE(date_column)
ORDER BY
    DATE(date_column);

-- Calculate daily average users after the feature change
SELECT
    DATE(date_column) AS date,
    AVG(users) AS daily_avg_users_after
FROM
    user_activity
WHERE
    date_column >= 'feature_change_date'
GROUP BY
    DATE(date_column)
ORDER BY
    DATE(date_column);



-- PART 2: Create a SQL query that indicates the number of status changes by card




-- Count the number of status changes by card
SELECT
    card_id,
    COUNT(*) AS num_status_changes
FROM
    card_status_changes
GROUP BY
    card_id
ORDER BY
    num_status_changes DESC;

