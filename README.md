# Netflix Database Management System (DBMS Course Project)

A Netflix-inspired relational database project built for **MySQL 8.0+** and MySQL Workbench. This is a database coursework demonstration, not a clone of Netflix and not a video-streaming application.

## Project objective
Design and implement a relational database that manages customer accounts, profiles, subscription plans, subscriptions, payments, entertainment content, genres, viewing history, ratings and watchlists.

## Software
- MySQL Server 8.0 or later
- MySQL Workbench 8.0 or later
- Optional: Git and a GitHub account

## Database tables
1. `Users`
2. `Subscription_Plans`
3. `Subscriptions`
4. `Payments`
5. `Profiles`
6. `Content`
7. `Genres`
8. `Content_Genre`
9. `Watch_History`
10. `Ratings`
11. `Watchlist`

## Files
- `SQL_Files/01_schema.sql` — creates the database and all tables.
- `SQL_Files/02_sample_data.sql` — inserts fictional demonstration data.
- `SQL_Files/03_queries.sql` — 25 example queries with comments/explanations.
- `SQL_Files/04_transactions_and_permissions.sql` — TCL examples and optional DCL examples.
- `ER_Diagrams/netflix_er_diagram.mmd` — Mermaid ER diagram source.
- `Output_Screenshots/` — save your own MySQL Workbench screenshots here after running the SQL.

## How to run in MySQL Workbench
1. Install and start MySQL Server, then open MySQL Workbench.
2. Connect to your local MySQL instance.
3. Open `01_schema.sql`, select the full script and click the lightning-bolt **Execute** button.
4. Open and execute `02_sample_data.sql`.
5. Open `03_queries.sql`. Run individual queries using the cursor inside a query and the Execute button, or select a query and execute it.
6. Run `04_transactions_and_permissions.sql` separately. The DCL section is commented out because creating users and granting privileges may require administrator privileges.
7. Refresh the Schemas panel and confirm `netflix_streaming_db` and its 11 tables exist.
8. Save screenshots of the result grid and Action Output in `Output_Screenshots/`.

**Important:** Run the schema and sample-data scripts once on a fresh database. The sample inserts use fixed IDs and are not intended to be repeatedly executed. If you need a completely fresh copy, first back up anything important, then run `DROP DATABASE netflix_streaming_db;` manually and execute the scripts again.

## Design notes
- Primary keys uniquely identify records.
- Foreign keys enforce relationships between tables.
- `Content_Genre` resolves the many-to-many relationship between content and genres.
- `Watchlist` uses a composite primary key to prevent a profile from saving the same title twice.
- `Ratings` has a unique constraint on `(profile_id, content_id)` so a profile has one current rating per title.
- `CHECK`, `NOT NULL`, `UNIQUE`, `ENUM` and foreign-key constraints protect data integrity.
- The tables are designed to support 1NF, 2NF and 3NF: attributes are atomic, repeating many-to-many groups are separated, and descriptive data (such as plan and genre names) is stored in its own table.

## Notes
- All sample customers, payments and activity are fictional.
- Password fields contain placeholder strings only. This project does not implement authentication.
- Payment records are simulated; no real payment gateway is connected.
- The project stores watch activity; it does not stream or store video files.

## GitHub
Create a new public repository named `Netflix-DBMS-Project`, upload the contents of this folder, and keep this README at the repository root.
