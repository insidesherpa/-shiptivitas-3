-- TYPE YOUR SQL QUERY BELOW

-- ============================================================================
-- PART 1: Daily Active Users Before and After the Feature Change (2018-06-02)
-- ============================================================================

-- Query 1A: Daily Active Users with Period Classification
SELECT 
    date(login_timestamp, 'unixepoch') as date,
    COUNT(DISTINCT user_id) as daily_active_users,
    CASE 
        WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'before'
        ELSE 'after'
    END as period
FROM login_history 
GROUP BY date 
ORDER BY date;

-- Query 1B: Average Daily Users Before and After Feature Change
SELECT 
    'Before Kanban (2018-02-03 to 2018-06-01)' as period,
    ROUND(AVG(daily_users), 2) as avg_daily_active_users,
    COUNT(*) as total_days
FROM (
    SELECT 
        date(login_timestamp, 'unixepoch') as date, 
        COUNT(DISTINCT user_id) as daily_users 
    FROM login_history 
    WHERE date(login_timestamp, 'unixepoch') < '2018-06-02'
    GROUP BY date
)

UNION ALL

SELECT 
    'After Kanban (2018-06-02 to 2019-02-01)' as period,
    ROUND(AVG(daily_users), 2) as avg_daily_active_users,
    COUNT(*) as total_days
FROM (
    SELECT 
        date(login_timestamp, 'unixepoch') as date, 
        COUNT(DISTINCT user_id) as daily_users 
    FROM login_history 
    WHERE date(login_timestamp, 'unixepoch') >= '2018-06-02'
    GROUP BY date
);


-- ============================================================================
-- PART 2: Number of Status Changes by Card
-- ============================================================================

-- Query 2A: Total Status Changes Per Card (sorted by most active cards)
SELECT 
    c.id as card_id,
    c.name as card_name,
    c.status as current_status,
    COUNT(cch.id) as total_status_changes
FROM card c
LEFT JOIN card_change_history cch ON c.id = cch.cardID
GROUP BY c.id
ORDER BY total_status_changes DESC;

-- Query 2B: Distribution of Cards by Number of Status Changes
SELECT 
    total_changes,
    COUNT(*) as number_of_cards
FROM (
    SELECT 
        cardID,
        COUNT(*) as total_changes
    FROM card_change_history
    GROUP BY cardID
)
GROUP BY total_changes
ORDER BY total_changes;

-- Query 2C: Status Transition Patterns (Flow Analysis)
SELECT 
    COALESCE(oldStatus, 'NEW') as from_status,
    newStatus as to_status,
    COUNT(*) as transition_count
FROM card_change_history
GROUP BY oldStatus, newStatus
ORDER BY transition_count DESC;

-- Query 2D: Daily Status Changes Over Time
SELECT 
    date(timestamp, 'unixepoch') as date,
    COUNT(*) as daily_status_changes,
    COUNT(DISTINCT cardID) as unique_cards_changed
FROM card_change_history
GROUP BY date
ORDER BY date;
