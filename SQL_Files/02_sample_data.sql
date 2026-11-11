-- ============================================================
-- FILE: 02_sample_data.sql
-- Run after 01_schema.sql.
-- Sample names, transactions and titles are demonstration data.
-- Password values are placeholders, not usable login credentials.
-- ============================================================

USE netflix_streaming_db;

INSERT INTO Users (user_id, full_name, email, password_hash, country, signup_date) VALUES
(1, 'Aarav Sharma', 'aarav@example.com', 'demo_hash_aarav', 'India', '2025-01-12'),
(2, 'Meera Patel', 'meera@example.com', 'demo_hash_meera', 'India', '2025-02-20'),
(3, 'Rohan Verma', 'rohan@example.com', 'demo_hash_rohan', 'India', '2025-04-05'),
(4, 'Ananya Singh', 'ananya@example.com', 'demo_hash_ananya', 'India', '2025-06-18'),
(5, 'Kabir Khan', 'kabir@example.com', 'demo_hash_kabir', 'India', '2025-08-09'),
(6, 'Isha Gupta', 'isha@example.com', 'demo_hash_isha', 'India', '2025-10-22'),
(7, 'Dev Malhotra', 'dev@example.com', 'demo_hash_dev', 'India', '2026-01-15'),
(8, 'Sara Thomas', 'sara@example.com', 'demo_hash_sara', 'India', '2026-03-11');

INSERT INTO Subscription_Plans
(plan_id, plan_name, monthly_price, max_screens, video_quality) VALUES
(1, 'Basic', 149.00, 1, 'HD'),
(2, 'Standard', 499.00, 2, 'Full HD'),
(3, 'Premium', 649.00, 4, '4K+HDR');

INSERT INTO Subscriptions
(subscription_id, user_id, plan_id, start_date, end_date, status) VALUES
(1, 1, 3, '2026-10-01', '2026-10-31', 'Expired'),
(2, 1, 3, '2026-11-01', '2026-11-30', 'Active'),
(3, 2, 2, '2026-10-15', '2026-11-14', 'Active'),
(4, 3, 1, '2026-08-01', '2026-08-31', 'Expired'),
(5, 4, 3, '2026-11-05', '2026-12-04', 'Active'),
(6, 5, 2, '2026-09-01', '2026-09-30', 'Cancelled'),
(7, 6, 1, '2026-11-02', '2026-12-01', 'Active'),
(8, 7, 2, '2026-10-01', '2026-10-31', 'Expired'),
(9, 8, 3, '2026-11-08', '2026-12-07', 'Active');

INSERT INTO Payments
(payment_id, subscription_id, amount, payment_date, payment_method, payment_status, transaction_reference) VALUES
(1, 1, 649.00, '2026-10-01', 'UPI', 'Successful', 'TXN-NET-1001'),
(2, 2, 649.00, '2026-11-01', 'Card', 'Successful', 'TXN-NET-1002'),
(3, 3, 499.00, '2026-10-15', 'UPI', 'Successful', 'TXN-NET-1003'),
(4, 4, 149.00, '2026-08-01', 'Wallet', 'Successful', 'TXN-NET-1004'),
(5, 5, 649.00, '2026-11-05', 'Net Banking', 'Successful', 'TXN-NET-1005'),
(6, 6, 499.00, '2026-09-01', 'Card', 'Refunded', 'TXN-NET-1006'),
(7, 7, 149.00, '2026-11-02', 'UPI', 'Successful', 'TXN-NET-1007'),
(8, 8, 499.00, '2026-10-01', 'UPI', 'Failed', 'TXN-NET-1008'),
(9, 9, 649.00, '2026-11-08', 'Card', 'Successful', 'TXN-NET-1009');

INSERT INTO Profiles (profile_id, user_id, profile_name, is_kids_profile, created_at) VALUES
(1, 1, 'Aarav', FALSE, '2025-01-12'),
(2, 1, 'Kids', TRUE, '2025-01-12'),
(3, 2, 'Meera', FALSE, '2025-02-20'),
(4, 3, 'Rohan', FALSE, '2025-04-05'),
(5, 4, 'Ananya', FALSE, '2025-06-18'),
(6, 5, 'Kabir', FALSE, '2025-08-09'),
(7, 6, 'Isha', FALSE, '2025-10-22'),
(8, 7, 'Dev', FALSE, '2026-01-15'),
(9, 8, 'Sara', FALSE, '2026-03-11');

INSERT INTO Content
(content_id, title, content_type, release_year, duration_minutes, maturity_rating, imdb_rating, description) VALUES
(1, 'The Last Kingdom', 'Series', 2015, NULL, 'TV-MA', 8.5, 'A historical drama about kingdoms and conflict.'),
(2, 'City of Stars', 'Movie', 2023, 128, 'U/A 13+', 7.8, 'A fictional romantic drama set in a modern city.'),
(3, 'The Silent Code', 'Movie', 2024, 116, 'U/A 16+', 8.2, 'A programmer uncovers a dangerous digital secret.'),
(4, 'Ocean Rescue', 'Movie', 2022, 104, 'U/A 7+', 7.1, 'A family adventure involving a marine rescue.'),
(5, 'Laugh Out Loud', 'Series', 2021, NULL, 'U/A 13+', 7.6, 'A comedy series about friends and everyday life.'),
(6, 'Shadow Protocol', 'Movie', 2025, 135, 'U/A 16+', 8.7, 'An intelligence agent faces a global conspiracy.'),
(7, 'Planet Earth: Next', 'Series', 2024, NULL, 'U', 9.0, 'A documentary series exploring the natural world.'),
(8, 'Midnight Mystery', 'Movie', 2023, 121, 'U/A 13+', 7.9, 'A detective investigates a mysterious disappearance.'),
(9, 'Little Explorers', 'Series', 2022, NULL, 'U', 8.1, 'An educational adventure for young viewers.'),
(10, 'Beyond the Stars', 'Movie', 2025, 142, 'U/A 13+', 8.4, 'A science-fiction journey beyond Earth.'),
(11, 'Kitchen Stories', 'Series', 2020, NULL, 'U', 7.4, 'A warm series about food and family.'),
(12, 'Final Match', 'Movie', 2024, 110, 'U/A 7+', 7.7, 'A sports drama about teamwork and determination.');

INSERT INTO Genres (genre_id, genre_name) VALUES
(1, 'Action'),
(2, 'Drama'),
(3, 'Comedy'),
(4, 'Science Fiction'),
(5, 'Documentary'),
(6, 'Family'),
(7, 'Thriller'),
(8, 'Romance'),
(9, 'Sports');

INSERT INTO Content_Genre (content_id, genre_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 8),
(3, 4), (3, 7),
(4, 6), (4, 1),
(5, 3), (5, 2),
(6, 1), (6, 7),
(7, 5), (7, 6),
(8, 7), (8, 2),
(9, 6), (9, 5),
(10, 4), (10, 2),
(11, 3), (11, 6),
(12, 9), (12, 2);

INSERT INTO Watch_History
(history_id, profile_id, content_id, watched_at, minutes_watched, progress_percent) VALUES
(1, 1, 6, '2026-11-01 20:00:00', 135, 100.00),
(2, 1, 10, '2026-11-02 21:00:00', 90, 63.38),
(3, 3, 6, '2026-11-03 19:30:00', 135, 100.00),
(4, 3, 2, '2026-11-04 20:15:00', 128, 100.00),
(5, 4, 3, '2026-10-25 18:00:00', 116, 100.00),
(6, 5, 1, '2026-11-05 21:00:00', 48, 35.00),
(7, 5, 8, '2026-11-06 20:00:00', 121, 100.00),
(8, 6, 12, '2026-10-12 17:00:00', 110, 100.00),
(9, 7, 7, '2026-11-07 16:00:00', 42, 50.00),
(10, 8, 6, '2026-10-20 22:00:00', 135, 100.00),
(11, 9, 10, '2026-11-09 20:00:00', 142, 100.00),
(12, 2, 9, '2026-11-09 15:00:00', 25, 20.00),
(13, 1, 3, '2026-11-10 19:00:00', 60, 51.72),
(14, 3, 6, '2026-11-10 21:00:00', 70, 52.00),
(15, 5, 10, '2026-11-10 22:00:00', 142, 100.00),
(16, 7, 4, '2026-11-10 17:30:00', 104, 100.00);

INSERT INTO Ratings
(rating_id, profile_id, content_id, rating, review_text, rating_date) VALUES
(1, 1, 6, 5.0, 'Excellent action and suspense.', '2026-11-02'),
(2, 3, 6, 4.5, 'Very engaging story.', '2026-11-04'),
(3, 3, 2, 4.0, 'Enjoyable romantic drama.', '2026-11-05'),
(4, 4, 3, 4.5, 'Interesting technology theme.', '2026-10-26'),
(5, 5, 8, 4.0, 'A good mystery.', '2026-11-07'),
(6, 6, 12, 4.0, 'Motivating sports film.', '2026-10-13'),
(7, 7, 7, 5.0, 'Beautiful documentary.', '2026-11-08'),
(8, 9, 10, 4.5, 'Great science-fiction movie.', '2026-11-10');

INSERT INTO Watchlist (profile_id, content_id, added_date) VALUES
(1, 8, '2026-11-01'),
(1, 10, '2026-11-02'),
(2, 9, '2026-11-03'),
(3, 3, '2026-11-04'),
(3, 7, '2026-11-05'),
(5, 6, '2026-11-06'),
(7, 4, '2026-11-07'),
(9, 1, '2026-11-09');

-- Quick checks: row counts should be non-zero.
SELECT 'Users' AS table_name, COUNT(*) AS total_records FROM Users
UNION ALL SELECT 'Content', COUNT(*) FROM Content
UNION ALL SELECT 'Watch_History', COUNT(*) FROM Watch_History
UNION ALL SELECT 'Payments', COUNT(*) FROM Payments;
