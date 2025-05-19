-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change
SELECT 
  DATE(login_timestamp, 'unixepoch') AS day,
  COUNT(DISTINCT user_id) AS daily_active_users
FROM login_history
GROUP BY day
ORDER BY day;
-- PART 2: Create a SQL query that indicates the number of status changes by card
SELECT 
  DATE(timestamp, 'unixepoch') AS day,
  cardid,
  COUNT(*) AS status_changes
FROM card_change_history
GROUP BY day, cardid
ORDER BY day, cardid;

