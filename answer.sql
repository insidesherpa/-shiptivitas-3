-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change

-- Query 1 (Official Model): Daily active users mapped by day of year
SELECT 
    count(distinct user_id) as daily_users,
    DATE(login_timestamp, 'unixepoch') as login_date,
    strftime('%j', DATE(login_timestamp, 'unixepoch')) AS day_of_year
FROM login_history
GROUP BY day_of_year;

-- Query 1 (Enhanced Chronological Timeline): Grouped by full date to preserve year boundary (2018 vs 2019)
SELECT 
    count(distinct user_id) as daily_users,
    DATE(login_timestamp, 'unixepoch') as login_date,
    strftime('%j', DATE(login_timestamp, 'unixepoch')) AS day_of_year,
    CASE 
        WHEN DATE(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'before'
        ELSE 'after'
    END AS period
FROM login_history
GROUP BY login_date
ORDER BY login_date;

-- Query 1 (Aggregate Summary): Average Daily Active Users before vs after feature release (2018-06-02)
WITH daily_dau AS (
    SELECT 
        DATE(login_timestamp, 'unixepoch') AS login_date,
        count(distinct user_id) AS daily_users
    FROM login_history
    GROUP BY login_date
)
SELECT 
    CASE 
        WHEN login_date < '2018-06-02' THEN 'before'
        ELSE 'after'
    END AS period,
    ROUND(AVG(daily_users), 2) AS avg_daily_users,
    COUNT(login_date) AS total_days
FROM daily_dau
GROUP BY period;


-- PART 2: Create a SQL query that indicates the number of status changes by card

-- Query 2 (Official Model): Number of status changes by cardId
SELECT
    cardId,
    count(id) as n_status_change
FROM card_change_history
WHERE oldStatus <> newStatus
GROUP BY cardId
ORDER BY n_status_change DESC;

-- Query 2 (Enhanced): Joined with card metadata (card name and current status)
SELECT
    c.id AS card_id,
    c.name AS card_name,
    c.status AS current_status,
    count(ch.id) AS n_status_change
FROM card c
LEFT JOIN card_change_history ch 
    ON c.id = ch.cardID 
    AND ch.oldStatus <> ch.newStatus
GROUP BY c.id, c.name, c.status
ORDER BY n_status_change DESC, c.id ASC;
