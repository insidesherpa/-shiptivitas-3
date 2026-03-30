-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change

SELECT
    period,
    AVG(daily_users) AS avg_daily_users
FROM (
    SELECT
        DATE(login_timestamp, 'unixepoch') AS login_date,
        COUNT(DISTINCT user_id) AS daily_users,
        CASE
            WHEN login_timestamp < 1527897600 THEN 'before'
            ELSE 'after'
        END AS period
    FROM login_history
    GROUP BY login_date
) AS daily_counts
GROUP BY period;


-- PART 2: Create a SQL query that indicates the number of status changes by card

SELECT
    c.id AS card_id,
    c.name AS card_name,
    COUNT(cch.id) AS num_status_changes
FROM card c
LEFT JOIN card_change_history cch
    ON c.id = cch.cardID
    AND cch.oldStatus IS NOT NULL
GROUP BY c.id, c.name
ORDER BY num_status_changes DESC;
