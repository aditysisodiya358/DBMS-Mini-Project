-- ============================================================
-- PROJECT: Netflix Database Management System
-- FILE: 01_schema.sql
-- DBMS: MySQL 8.0+
-- Run this file first in MySQL Workbench.
-- ============================================================

CREATE DATABASE IF NOT EXISTS netflix_streaming_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE netflix_streaming_db;

-- 1. USERS: one row per customer account.
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    country VARCHAR(60) NOT NULL,
    signup_date DATE NOT NULL
) ENGINE=InnoDB;

-- 2. SUBSCRIPTION_PLANS: available subscription options.
CREATE TABLE IF NOT EXISTS Subscription_Plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(30) NOT NULL UNIQUE,
    monthly_price DECIMAL(8,2) NOT NULL,
    max_screens TINYINT UNSIGNED NOT NULL,
    video_quality VARCHAR(20) NOT NULL,
    CONSTRAINT chk_plan_price CHECK (monthly_price >= 0),
    CONSTRAINT chk_plan_screens CHECK (max_screens >= 1)
) ENGINE=InnoDB;

-- 3. SUBSCRIPTIONS: subscription history for each user.
CREATE TABLE IF NOT EXISTS Subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('Active', 'Expired', 'Cancelled', 'Pending') NOT NULL,
    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_subscription_plan
        FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_subscription_dates CHECK (end_date >= start_date)
) ENGINE=InnoDB;

-- 4. PAYMENTS: payment transactions for subscriptions.
CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('UPI', 'Card', 'Net Banking', 'Wallet') NOT NULL,
    payment_status ENUM('Successful', 'Failed', 'Refunded', 'Pending') NOT NULL,
    transaction_reference VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT fk_payment_subscription
        FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_payment_amount CHECK (amount >= 0)
) ENGINE=InnoDB;

-- 5. PROFILES: multiple viewing profiles can belong to one account.
CREATE TABLE IF NOT EXISTS Profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    profile_name VARCHAR(50) NOT NULL,
    is_kids_profile BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATE NOT NULL,
    CONSTRAINT fk_profile_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_user_profile UNIQUE (user_id, profile_name)
) ENGINE=InnoDB;

-- 6. CONTENT: movies and series available on the platform.
CREATE TABLE IF NOT EXISTS Content (
    content_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    content_type ENUM('Movie', 'Series') NOT NULL,
    release_year YEAR NOT NULL,
    duration_minutes SMALLINT UNSIGNED NULL,
    maturity_rating VARCHAR(10) NOT NULL,
    imdb_rating DECIMAL(3,1) NULL,
    description VARCHAR(500),
    CONSTRAINT chk_content_rating CHECK (imdb_rating IS NULL OR (imdb_rating BETWEEN 0 AND 10)),
    CONSTRAINT chk_movie_duration CHECK (
        content_type = 'Series' OR duration_minutes IS NOT NULL
    )
) ENGINE=InnoDB;

-- 7. GENRES: controlled list of content categories.
CREATE TABLE IF NOT EXISTS Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 8. CONTENT_GENRE: resolves the many-to-many Content/Genres relationship.
CREATE TABLE IF NOT EXISTS Content_Genre (
    content_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (content_id, genre_id),
    CONSTRAINT fk_content_genre_content
        FOREIGN KEY (content_id) REFERENCES Content(content_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_content_genre_genre
        FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. WATCH_HISTORY: viewing activity for a profile.
CREATE TABLE IF NOT EXISTS Watch_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    watched_at DATETIME NOT NULL,
    minutes_watched SMALLINT UNSIGNED NOT NULL,
    progress_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_history_profile
        FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_history_content
        FOREIGN KEY (content_id) REFERENCES Content(content_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_progress CHECK (progress_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- 10. RATINGS: one rating per profile for each title.
CREATE TABLE IF NOT EXISTS Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    review_text VARCHAR(500),
    rating_date DATE NOT NULL,
    CONSTRAINT fk_rating_profile
        FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_rating_content
        FOREIGN KEY (content_id) REFERENCES Content(content_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_profile_content_rating UNIQUE (profile_id, content_id),
    CONSTRAINT chk_user_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- 11. WATCHLIST: titles saved by a profile ("My List").
CREATE TABLE IF NOT EXISTS Watchlist (
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    added_date DATE NOT NULL,
    PRIMARY KEY (profile_id, content_id),
    CONSTRAINT fk_watchlist_profile
        FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_watchlist_content
        FOREIGN KEY (content_id) REFERENCES Content(content_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Verify that all 11 tables were created.
SHOW TABLES;
