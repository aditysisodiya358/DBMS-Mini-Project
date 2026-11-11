-- ============================================================
-- NETFLIX DBMS PROJECT
-- 26 SQL QUERIES EXECUTED IN MYSQL WORKBENCH
-- Database: netflix_streaming_db
-- MySQL 8.0+
-- ============================================================

USE netflix_streaming_db;

-- QUERY 01: Display all registered users
SELECT user_id, full_name, email, country, signup_date
FROM Users
ORDER BY user_id;

-- QUERY 02: Display all movies
SELECT content_id, title, release_year, duration_minutes, imdb_rating
FROM Content
WHERE content_type = 'Movie'
ORDER BY title;

-- QUERY 03: Display currently active subscriptions
SELECT u.full_name, sp.plan_name, s.start_date, s.end_date, s.status
FROM Users u
JOIN Subscriptions s ON u.user_id = s.user_id
JOIN Subscription_Plans sp ON s.plan_id = sp.plan_id
WHERE s.status = 'Active'
ORDER BY u.full_name;

-- QUERY 04: Display users along with their profiles
SELECT u.user_id, u.full_name, p.profile_id, p.profile_name, p.is_kids_profile
FROM Users u
JOIN Profiles p ON u.user_id = p.user_id
ORDER BY u.user_id, p.profile_id;

-- QUERY 05: Display content titles with their genres
SELECT c.title, c.content_type, g.genre_name
FROM Content c
JOIN Content_Genre cg ON c.content_id = cg.content_id
JOIN Genres g ON cg.genre_id = g.genre_id
ORDER BY c.title, g.genre_name;

-- QUERY 06: Find the five most-watched titles by number of watch sessions
SELECT c.title, COUNT(wh.history_id) AS total_watch_sessions
FROM Content c
JOIN Watch_History wh ON c.content_id = wh.content_id
GROUP BY c.content_id, c.title
ORDER BY total_watch_sessions DESC
LIMIT 5;

-- QUERY 07: Calculate revenue grouped by subscription plan
-- This query sums all payment records, regardless of payment status.
SELECT sp.plan_name, SUM(p.amount) AS total_revenue
FROM Subscription_Plans sp
JOIN Subscriptions s ON sp.plan_id = s.plan_id
JOIN Payments p ON s.subscription_id = p.subscription_id
GROUP BY sp.plan_id, sp.plan_name
ORDER BY total_revenue DESC;

-- QUERY 08: Calculate average user rating for each content title
SELECT c.title, ROUND(AVG(r.rating), 2) AS average_user_rating
FROM Content c
JOIN Ratings r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title
ORDER BY average_user_rating DESC;

-- QUERY 09: Find users who have never watched any content
SELECT u.user_id, u.full_name
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Profiles p
    JOIN Watch_History wh ON p.profile_id = wh.profile_id
    WHERE p.user_id = u.user_id
);

-- QUERY 10: Calculate total watch minutes for each profile
SELECT p.profile_name, SUM(wh.minutes_watched) AS total_minutes_watched
FROM Profiles p
JOIN Watch_History wh ON p.profile_id = wh.profile_id
GROUP BY p.profile_id, p.profile_name
ORDER BY total_minutes_watched DESC;

-- QUERY 11: Display all watchlist entries
SELECT p.profile_name, c.title, w.added_date
FROM Watchlist w
JOIN Profiles p ON w.profile_id = p.profile_id
JOIN Content c ON w.content_id = c.content_id
ORDER BY p.profile_name, w.added_date DESC;

-- QUERY 12: Find titles with an IMDb rating above the overall average
SELECT title, imdb_rating
FROM Content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM Content)
ORDER BY imdb_rating DESC;

-- QUERY 13: Count titles by content type
SELECT content_type, COUNT(*) AS total_titles
FROM Content
GROUP BY content_type;

-- QUERY 14: Find genres associated with more than two titles
SELECT g.genre_name, COUNT(cg.content_id) AS total_titles
FROM Genres g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 2;

-- QUERY 15: Summarize successful payments by payment method
SELECT payment_method,
       COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM Payments
WHERE payment_status = 'Successful'
GROUP BY payment_method
ORDER BY total_amount DESC;

-- QUERY 16: Display content that has been completely watched
SELECT c.title, wh.progress_percent, wh.minutes_watched
FROM Content c
JOIN Watch_History wh ON c.content_id = wh.content_id
WHERE wh.progress_percent = 100;

-- QUERY 17: Find titles that are not present in anyone's watchlist
SELECT c.content_id, c.title
FROM Content c
WHERE NOT EXISTS (
    SELECT 1
    FROM Watchlist w
    WHERE w.content_id = c.content_id
);

-- QUERY 18: Display users who have made successful payments
-- Payments links to Subscriptions; Subscriptions links to Users.
SELECT DISTINCT u.user_id, u.full_name, u.email
FROM Users u
JOIN Subscriptions s ON u.user_id = s.user_id
JOIN Payments p ON s.subscription_id = p.subscription_id
WHERE p.payment_status = 'Successful';

-- QUERY 19: Find the latest subscription start date for each user
SELECT u.full_name, MAX(s.start_date) AS latest_subscription
FROM Users u
JOIN Subscriptions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.full_name;

-- QUERY 20: Display highly IMDb-rated content with user ratings
SELECT c.title, c.imdb_rating, r.rating AS user_rating
FROM Content c
JOIN Ratings r ON c.content_id = r.content_id
WHERE c.imdb_rating >= 8
ORDER BY c.imdb_rating DESC;

-- QUERY 21: Generate a complete payment report with the associated user
-- Correct relationship: Payments -> Subscriptions -> Users.
SELECT p.payment_id, u.full_name, p.amount, p.payment_method,
       p.payment_status, p.payment_date
FROM Payments p
JOIN Subscriptions s ON p.subscription_id = s.subscription_id
JOIN Users u ON s.user_id = u.user_id
ORDER BY p.payment_date DESC;

-- QUERY 22: Display watch history from the last 30 days
SELECT p.profile_name, c.title, wh.watched_at, wh.minutes_watched
FROM Watch_History wh
JOIN Profiles p ON wh.profile_id = p.profile_id
JOIN Content c ON wh.content_id = c.content_id
WHERE wh.watched_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY wh.watched_at DESC;

-- QUERY 23: Find the most popular genres based on watch sessions
SELECT g.genre_name, COUNT(*) AS total_watch_sessions
FROM Watch_History wh
JOIN Content_Genre cg ON wh.content_id = cg.content_id
JOIN Genres g ON cg.genre_id = g.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY total_watch_sessions DESC;

-- QUERY 24: Calculate average user rating for each genre
SELECT g.genre_name, ROUND(AVG(r.rating), 2) AS average_rating
FROM Genres g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
JOIN Ratings r ON cg.content_id = r.content_id
GROUP BY g.genre_id, g.genre_name
ORDER BY average_rating DESC;

-- QUERY 25: Calculate successful revenue for each subscription plan
SELECT sp.plan_name,
       COUNT(p.payment_id) AS successful_transactions,
       SUM(p.amount) AS total_revenue
FROM Subscription_Plans sp
JOIN Subscriptions s ON sp.plan_id = s.plan_id
JOIN Payments p ON s.subscription_id = p.subscription_id
WHERE p.payment_status = 'Successful'
GROUP BY sp.plan_id, sp.plan_name
ORDER BY total_revenue DESC;

-- QUERY 26: Display subscription details for every user with a subscription
SELECT u.full_name, sp.plan_name, s.start_date, s.end_date, s.status
FROM Users u
JOIN Subscriptions s ON u.user_id = s.user_id
JOIN Subscription_Plans sp ON s.plan_id = sp.plan_id
ORDER BY u.full_name;

-- ============================================================
-- END OF 26 QUERIES
-- NOTE: Query 07 includes all payment statuses, while Query 25
-- specifically includes only successful payments.
-- ============================================================
