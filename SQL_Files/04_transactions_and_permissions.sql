-- ============================================================
-- FILE: 04_transactions_and_permissions.sql
-- TCL examples can be run in a separate SQL tab.
-- DCL commands may require an administrator account.
-- ============================================================

USE netflix_streaming_db;

-- TCL EXAMPLE 1: COMMIT
-- A transaction groups statements into one unit of work.
START TRANSACTION;

UPDATE Subscription_Plans
SET monthly_price = 159.00
WHERE plan_id = 1;

COMMIT;

-- Verify the committed update.
SELECT plan_name, monthly_price
FROM Subscription_Plans
WHERE plan_id = 1;

-- TCL EXAMPLE 2: ROLLBACK
-- This temporary change is undone by ROLLBACK.
START TRANSACTION;

UPDATE Subscription_Plans
SET monthly_price = 999.00
WHERE plan_id = 1;

SELECT plan_name, monthly_price
FROM Subscription_Plans
WHERE plan_id = 1;

ROLLBACK;

-- Verify that the price returned to the committed value.
SELECT plan_name, monthly_price
FROM Subscription_Plans
WHERE plan_id = 1;

-- TCL EXAMPLE 3: SAVEPOINT
START TRANSACTION;

UPDATE Subscription_Plans
SET monthly_price = 169.00
WHERE plan_id = 1;

SAVEPOINT price_updated;

UPDATE Subscription_Plans
SET monthly_price = 699.00
WHERE plan_id = 3;

ROLLBACK TO SAVEPOINT price_updated;
COMMIT;

-- Verify final prices: Basic = 169.00; Premium remains 649.00.
SELECT plan_name, monthly_price
FROM Subscription_Plans
ORDER BY plan_id;

-- DCL EXAMPLE (OPTIONAL; execute only if you have permission).
-- Change the password before using this on a real system.
-- CREATE USER IF NOT EXISTS 'netflix_readonly'@'localhost'
-- IDENTIFIED BY 'ChangeThisPassword!';

-- GRANT SELECT ON netflix_streaming_db.*
-- TO 'netflix_readonly'@'localhost';

-- REVOKE SELECT ON netflix_streaming_db.*
-- FROM 'netflix_readonly'@'localhost';

-- SHOW GRANTS FOR 'netflix_readonly'@'localhost';
