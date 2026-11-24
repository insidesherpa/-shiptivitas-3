-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change
-- The Kanban Board feature was released on 2018-06-02.

-- 1A. Daily Active Users (DAU) timeline before and after the Kanban board launch (2018-06-02)
-- Maps out daily active user counts across all recorded dates
SELECT 
    date(login_timestamp, 'unixepoch') AS login_date,
    COUNT(DISTINCT user_id) AS daily_active_users,
    CASE 
        WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'Before Feature'
        ELSE 'After Feature'
    END AS period
FROM login_history
GROUP BY login_date
ORDER BY login_date ASC;

-- 1B. Aggregate Daily Average Users before vs. after the Kanban board feature change
-- Compares the average DAU metric between the pre-feature and post-feature periods
WITH daily_dau AS (
    SELECT 
        date(login_timestamp, 'unixepoch') AS login_date,
        COUNT(DISTINCT user_id) AS dau,
        CASE 
            WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'Before Feature'
            ELSE 'After Feature'
        END AS period
    FROM login_history
    GROUP BY login_date
)
SELECT 
    period,
    ROUND(AVG(dau), 2) AS avg_daily_active_users,
    COUNT(login_date) AS total_active_days,
    SUM(dau) AS total_user_sessions
FROM daily_dau
GROUP BY period
ORDER BY period DESC;


-- PART 2: Create a SQL query that indicates the number of status changes by card

-- 2A. Number of status changes by card (tracking transitions between statuses: backlog -> in-progress -> complete)
SELECT 
    c.id AS card_id,
    c.name AS card_name,
    c.status AS current_status,
    COUNT(cch.id) AS total_status_changes
FROM card c
INNER JOIN card_change_history cch ON c.id = cch.cardID
WHERE cch.oldStatus IS NOT NULL AND cch.oldStatus != cch.newStatus
GROUP BY c.id, c.name, c.status
ORDER BY total_status_changes DESC, c.id ASC;

-- 2B. Daily number of status changes across all cards
SELECT 
    date(timestamp, 'unixepoch') AS change_date,
    COUNT(*) AS daily_status_changes
FROM card_change_history
WHERE oldStatus IS NOT NULL AND oldStatus != newStatus
GROUP BY change_date
ORDER BY change_date ASC;
