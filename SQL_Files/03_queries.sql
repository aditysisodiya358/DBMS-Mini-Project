-- ============================================================
-- FILE: 03_queries.sql
-- Run after 01_schema.sql and 02_sample_data.sql.
-- Each query is followed by its purpose.
-- ============================================================

USE netflix_streaming_db;

-- Q1. Display all registered users.
SELECT user_id, full_name, email, country, signup_date
FROM Users
ORDER BY user_id;

-- Q2. Display all movies only.
SELECT content_id, title, release_year, duration_minutes, imdb_rating
FROM Content
WHERE content_type = 'Movie'
ORDER BY release_year DESC;

-- Q3. Find all active subscriptions.
SELECT s.subscription_id, u.full_name, p.plan_name, s.start_date, s.end_date
FROM Subscriptions s
JOIN Users u ON s.user_id = u.user_id
JOIN Subscription_Plans p ON s.plan_id = p.plan_id
WHERE s.status = 'Active';

-- Q4. Show each user and their profiles (INNER JOIN).
SELECT u.full_name, pr.profile_name, pr.is_kids_profile
FROM Users u
INNER JOIN Profiles pr ON u.user_id = pr.user_id
ORDER BY u.full_name, pr.profile_name;

-- Q5. List content with its genres (many-to-many JOIN).
SELECT c.title, g.genre_name
FROM Content c
JOIN Content_Genre cg ON c.content_id = cg.content_id
JOIN Genres g ON cg.genre_id = g.genre_id
ORDER BY c.title, g.genre_name;

-- Q6. Find the five most-watched titles by number of watch sessions.
SELECT c.title, COUNT(wh.history_id) AS total_views
FROM Content c
JOIN Watch_History wh ON c.content_id = wh.content_id
GROUP BY c.content_id, c.title
ORDER BY total_views DESC, c.title
LIMIT 5;

-- Q7. Calculate successful payment revenue for each plan.
SELECT sp.plan_name, SUM(pay.amount) AS total_revenue
FROM Subscription_Plans sp
JOIN Subscriptions s ON sp.plan_id = s.plan_id
JOIN Payments pay ON s.subscription_id = pay.subscription_id
WHERE pay.payment_status = 'Successful'
GROUP BY sp.plan_id, sp.plan_name
ORDER BY total_revenue DESC;

-- Q8. Find subscriptions that have expired based on their end date.
SELECT u.full_name, sp.plan_name, s.start_date, s.end_date
FROM Subscriptions s
JOIN Users u ON s.user_id = u.user_id
JOIN Subscription_Plans sp ON s.plan_id = sp.plan_id
WHERE s.end_date < CURDATE();

-- Q9. Display average user rating for each title.
SELECT c.title, ROUND(AVG(r.rating), 2) AS average_user_rating,
       COUNT(r.rating_id) AS number_of_ratings
FROM Content c
LEFT JOIN Ratings r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title
ORDER BY average_user_rating DESC;

-- Q10. Find the average rating for each genre.
SELECT g.genre_name, ROUND(AVG(r.rating), 2) AS average_genre_rating
FROM Genres g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
JOIN Ratings r ON cg.content_id = r.content_id
GROUP BY g.genre_id, g.genre_name
ORDER BY average_genre_rating DESC;

-- Q11. Find users who have never watched any content (NOT EXISTS).
SELECT u.user_id, u.full_name
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Profiles p
    JOIN Watch_History wh ON p.profile_id = wh.profile_id
    WHERE p.user_id = u.user_id
);

-- Q12. Find content whose IMDb rating is above the overall average (subquery).
SELECT title, imdb_rating
FROM Content
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM Content)
ORDER BY imdb_rating DESC;

-- Q13. Count the number of titles in each content type.
SELECT content_type, COUNT(*) AS title_count
FROM Content
GROUP BY content_type;

-- Q14. Find genres containing more than two titles (HAVING).
SELECT g.genre_name, COUNT(cg.content_id) AS title_count
FROM Genres g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(cg.content_id) > 2;

-- Q15. Show each profile's total watch time in hours.
SELECT p.profile_name, u.full_name,
       ROUND(SUM(wh.minutes_watched) / 60, 2) AS watch_hours
FROM Profiles p
JOIN Users u ON p.user_id = u.user_id
JOIN Watch_History wh ON p.profile_id = wh.profile_id
GROUP BY p.profile_id, p.profile_name, u.full_name
ORDER BY watch_hours DESC;

-- Q16. Show titles saved in each profile's watchlist.
SELECT u.full_name, p.profile_name, c.title, wl.added_date
FROM Watchlist wl
JOIN Profiles p ON wl.profile_id = p.profile_id
JOIN Users u ON p.user_id = u.user_id
JOIN Content c ON wl.content_id = c.content_id
ORDER BY u.full_name, p.profile_name;

-- Q17. Find titles that have never been added to any watchlist.
SELECT c.content_id, c.title
FROM Content c
LEFT JOIN Watchlist wl ON c.content_id = wl.content_id
WHERE wl.content_id IS NULL;

-- Q18. Find users who have made at least one successful payment.
SELECT DISTINCT u.user_id, u.full_name
FROM Users u
JOIN Subscriptions s ON u.user_id = s.user_id
JOIN Payments p ON s.subscription_id = p.subscription_id
WHERE p.payment_status = 'Successful';

-- Q19. Count successful payments by payment method.
SELECT payment_method, COUNT(*) AS successful_transactions,
       SUM(amount) AS total_amount
FROM Payments
WHERE payment_status = 'Successful'
GROUP BY payment_method
ORDER BY total_amount DESC;

-- Q20. Find content watched for 100% completion.
SELECT DISTINCT c.title, wh.progress_percent
FROM Content c
JOIN Watch_History wh ON c.content_id = wh.content_id
WHERE wh.progress_percent = 100;

-- Q21. Show users with their latest subscription start date.
SELECT u.full_name, MAX(s.start_date) AS latest_subscription_date
FROM Users u
LEFT JOIN Subscriptions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.full_name
ORDER BY latest_subscription_date DESC;

-- Q22. Find titles with an IMDb rating of at least 8.0 AND at least one rating.
SELECT c.title, c.imdb_rating
FROM Content c
WHERE c.imdb_rating >= 8.0
  AND EXISTS (
      SELECT 1 FROM Ratings r WHERE r.content_id = c.content_id
  )
ORDER BY c.imdb_rating DESC;

-- Q23. Display watch activity from the last 30 days.
SELECT p.profile_name, c.title, wh.watched_at, wh.minutes_watched
FROM Watch_History wh
JOIN Profiles p ON wh.profile_id = p.profile_id
JOIN Content c ON wh.content_id = c.content_id
WHERE wh.watched_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY wh.watched_at DESC;

-- Q24. Find the most popular genre by number of watch sessions.
SELECT g.genre_name, COUNT(wh.history_id) AS total_watch_sessions
FROM Genres g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
JOIN Watch_History wh ON cg.content_id = wh.content_id
GROUP BY g.genre_id, g.genre_name
ORDER BY total_watch_sessions DESC
LIMIT 1;

-- Q25. Display a complete payment report with user and plan details.
SELECT pay.payment_id, u.full_name, sp.plan_name, pay.amount,
       pay.payment_date, pay.payment_method, pay.payment_status
FROM Payments pay
JOIN Subscriptions s ON pay.subscription_id = s.subscription_id
JOIN Users u ON s.user_id = u.user_id
JOIN Subscription_Plans sp ON s.plan_id = sp.plan_id
ORDER BY pay.payment_date DESC;
