-- ==============================================================================
-- SHIPTIVITY ANALYTICS - COMPLETE SQL QUERIES FOR DATA VISUALIZATIONS
-- Database: shiptivity.db (SQLite)
-- Feature Launch Date: 2018-06-02 (Kanban Board Release)
-- ==============================================================================

-- ==============================================================================
-- SECTION 1: GRAPH 1 - DAILY ACTIVE USERS (DAU) BEFORE AND AFTER FEATURE LAUNCH
-- Visualizes the impact of the June 2, 2018 Kanban Board release on active users
-- ==============================================================================

-- Query 1.1: Daily Active Users (DAU) Time Series (Powers the main timeline plot)
-- Maps out the unique active user count for each day across the whole observation window.
SELECT 
    date(login_timestamp, 'unixepoch') AS login_date,
    COUNT(DISTINCT user_id) AS daily_active_users,
    CASE 
        WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'Before Feature'
        ELSE 'After Feature'
    END AS feature_period
FROM login_history
GROUP BY login_date
ORDER BY login_date ASC;


-- Query 1.2: Aggregate Daily Average Users (DAU) Comparison (Powers the side bar chart)
-- Calculates the average DAU, total active days, and total user sessions before vs after launch.
WITH daily_user_counts AS (
    SELECT 
        date(login_timestamp, 'unixepoch') AS login_date,
        COUNT(DISTINCT user_id) AS dau,
        CASE 
            WHEN date(login_timestamp, 'unixepoch') < '2018-06-02' THEN 'Before Feature (2018-02-03 to 2018-06-01)'
            ELSE 'After Feature (2018-06-02 to 2019-02-01)'
        END AS period
    FROM login_history
    GROUP BY login_date
)
SELECT 
    period,
    ROUND(AVG(dau), 2) AS avg_daily_active_users,
    COUNT(login_date) AS total_active_days,
    SUM(dau) AS total_user_sessions
FROM daily_user_counts
GROUP BY period
ORDER BY period DESC;


-- Query 1.3: Monthly Active Users (MAU) & Average DAU Progression
-- Tracks month-over-month engagement trajectory to identify growth and plateaus.
WITH daily_activity AS (
    SELECT 
        date(login_timestamp, 'unixepoch') AS activity_day,
        strftime('%Y-%m', login_timestamp, 'unixepoch') AS activity_month,
        COUNT(DISTINCT user_id) AS dau
    FROM login_history
    GROUP BY activity_day
)
SELECT 
    activity_month,
    COUNT(activity_day) AS days_in_month,
    ROUND(AVG(dau), 2) AS avg_dau,
    MIN(dau) AS min_dau,
    MAX(dau) AS max_dau
FROM daily_activity
GROUP BY activity_month
ORDER BY activity_month ASC;


-- ==============================================================================
-- SECTION 2: GRAPH 2 - NUMBER OF STATUS CHANGES BY CARD & LIFECYCLE FLOW
-- Analyzes card movement frequencies, pipeline status, and transition velocities
-- ==============================================================================

-- Query 2.1: Total Status Changes by Card (Excluding Initial Creation)
-- Lists every card with its total status transitions (backlog -> in-progress -> complete).
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


-- Query 2.2: Distribution of Status Changes Across All 200 Cards (Powers Panel A Histogram)
-- Groups cards by number of transitions (0, 1, 2, 3, 4, 5 moves) including untouched backlog cards.
WITH card_move_counts AS (
    SELECT 
        c.id AS card_id,
        COUNT(CASE WHEN cch.oldStatus IS NOT NULL AND cch.oldStatus != cch.newStatus THEN 1 ELSE NULL END) AS changes_count
    FROM card c
    LEFT JOIN card_change_history cch ON c.id = cch.cardID
    GROUP BY c.id
)
SELECT 
    changes_count AS number_of_status_changes,
    COUNT(card_id) AS card_count,
    ROUND(COUNT(card_id) * 100.0 / 200, 1) AS percentage_of_total_cards
FROM card_move_counts
GROUP BY changes_count
ORDER BY changes_count ASC;


-- Query 2.3: Current Kanban Board Status Breakdown (Powers Panel B Donut/Pie Chart)
-- Shows how many cards currently reside in backlog, in-progress, and complete.
SELECT 
    status AS kanban_status,
    COUNT(*) AS total_cards,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM card), 1) AS percentage
FROM card
GROUP BY status
ORDER BY total_cards DESC;


-- Query 2.4: Top 15 Most Active Cards by Status Transitions (Powers Panel C Bar Chart)
-- Identifies cards that underwent the most workflow iterations and revisions.
SELECT 
    c.id AS card_id,
    c.name AS card_name,
    c.status AS current_status,
    c.priority AS current_priority,
    COUNT(cch.id) AS total_status_changes
FROM card c
INNER JOIN card_change_history cch ON c.id = cch.cardID
WHERE cch.oldStatus IS NOT NULL AND cch.oldStatus != cch.newStatus
GROUP BY c.id, c.name, c.status, c.priority
ORDER BY total_status_changes DESC, c.id ASC
LIMIT 15;


-- Query 2.5: Daily Volume of Status Changes Over Time (Powers Panel D / Subplot 2)
-- Measures day-by-day velocity of card moves across the entire team.
SELECT 
    date(timestamp, 'unixepoch') AS change_date,
    COUNT(*) AS daily_status_changes
FROM card_change_history
WHERE oldStatus IS NOT NULL AND oldStatus != newStatus
GROUP BY change_date
ORDER BY change_date ASC;


-- Query 2.6: Status Transition Matrix & Path Breakdown
-- Audits specific stage-to-stage movements (forward progressions vs rework/reopened).
SELECT 
    oldStatus AS from_stage,
    newStatus AS to_stage,
    COUNT(*) AS transition_count,
    ROUND(COUNT(*) * 100.0 / 286, 1) AS percentage_of_all_transitions
FROM card_change_history
WHERE oldStatus IS NOT NULL AND oldStatus != newStatus
GROUP BY oldStatus, newStatus
ORDER BY transition_count DESC;
