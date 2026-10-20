
-- PART 1: Average daily active users before and after
-- the feature change (June 2, 2018).

WITH daily_active_users AS (
    SELECT
        DATE(login_timestamp, 'unixepoch') AS activity_date,
        COUNT(DISTINCT user_id) AS active_users
    FROM login_history
    GROUP BY DATE(login_timestamp, 'unixepoch')
)
SELECT
    CASE
        WHEN activity_date < '2018-06-02' THEN 'Before Feature'
        ELSE 'After Feature'
    END AS feature_period,
    ROUND(AVG(active_users), 2) AS average_daily_active_users
FROM daily_active_users
GROUP BY feature_period
ORDER BY feature_period;


-- PART 2: Number of status changes by card, per day.

SELECT
    DATE(timestamp, 'unixepoch') AS change_date,
    cardID AS card_id,
    COUNT(*) AS status_change_count
FROM card_change_history
WHERE oldStatus IS NOT NULL
  AND oldStatus <> newStatus
GROUP BY
    DATE(timestamp, 'unixepoch'),
    cardID
ORDER BY
    change_date,
    status_change_count DESC;
