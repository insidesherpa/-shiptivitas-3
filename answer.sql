-- PART 1: Create a SQL query that indicates the number of cards by status  
.mode csv
.output daily_active_users.csv
SELECT 
  DATE(datetime(login_timestamp, 'unixepoch')) AS login_date, 
  COUNT(DISTINCT user_id) AS unique_users
FROM login_history
GROUP BY login_date
ORDER BY login_date;
.output stdout




-- PART 2: Create a SQL query that indicates the number of status changes by card
.mode csv
.output status_changes_by_card.csv
SELECT 
  cardID,
  COUNT(*) AS status_change_count
FROM 
  card_change_history
WHERE 
  oldStatus IS NOT NULL
GROUP BY 
  cardID
ORDER BY 
  cardID;
.output stdout

