# Day 43 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Apple (Hard Level) hashtag#SQL Interview Question — Solution

Find the number of Apple product users and the number of total users with a device and group the counts by language. Assume Apple products are only MacBook-Pro, iPhone 5s, and iPad-air. Output the language along with the total number of Apple users and users with any device. Order your results based on the number of total users in descending order.

🔍 Definitely you are going to enjoy by solving this, you'll learn how to multiple ctes, join, group by. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE playbook_users (user_id INT PRIMARY KEY,created_at DATETIME,company_id INT,language VARCHAR(50),activated_at DATETIME,state VARCHAR(50));

INSERT INTO playbook_users (user_id, created_at, company_id, language, activated_at, state) VALUES
(1, '2024-01-01 08:00:00', 101, 'English', '2024-01-05 10:00:00', 'Active'),
(2, '2024-01-02 09:00:00', 102, 'Spanish', '2024-01-06 11:00:00', 'Inactive'),
(3, '2024-01-03 10:00:00', 103, 'French', '2024-01-07 12:00:00', 'Active'),
(4, '2024-01-04 11:00:00', 104, 'English', '2024-01-08 13:00:00', 'Active'),
(5, '2024-01-05 12:00:00', 105, 'Spanish', '2024-01-09 14:00:00', 'Inactive');

CREATE TABLE playbook_events ( user_id INT, occurred_at DATETIME, event_type VARCHAR(50), event_name VARCHAR(50), location VARCHAR(100), device VARCHAR(50));

INSERT INTO playbook_events (user_id, occurred_at, event_type, event_name, location, device) VALUES
(1, '2024-01-05 14:00:00', 'Click', 'Login', 'USA', 'MacBook-Pro'),
(2, '2024-01-06 15:00:00', 'View', 'Dashboard', 'Spain', 'iPhone 5s'),
(3, '2024-01-07 16:00:00', 'Click', 'Logout', 'France', 'iPad-air'),
(4, '2024-01-08 17:00:00', 'Purchase', 'Subscription', 'USA', 'Windows-Laptop'), (5, '2024-01-09 18:00:00', 'Click', 'Login', 'Spain', 'Android-Phone');

## My Thought Process

I treated this as a two‑layer problem.

1. Build the user segments from event data
    - The events table tells me which device each user interacted with. So the first step is to isolate:
    - users who used an Apple device
    - users who used any device
    - Both need to be deduped at the user level because a single user can generate multiple events.

2. Join the segments back to the users table

    - Language lives in the playbook_users table, so the next step is to bring the user attributes together with the device‑based segments.

3. Aggregate at the language level

    - Once the segments are clean, I can count:
    - how many users per language used any device
    - how many users per language used an Apple device
    - This gives a clear comparison across languages.

## SQL Solution
```sql

WITH cte_apple_users AS(
    SELECT DISTINCT user_id
      FROM playbook_events
     WHERE device IN ('MacBook-Pro', 'iPhone 5s', 'iPad-air')
),
cte_users_with_device AS(
    SELECT DISTINCT user_id
      FROM playbook_events
     WHERE device IS NOT NULL
)
SELECT u.language,
       count(DISTINCT d.user_id) AS total_users_per_language,
       count(DISTINCT a.user_id) AS apple_users
  FROM playbook_users AS u
  LEFT JOIN cte_apple_users AS a
    ON u.user_id = a.user_id
  LEFT JOIN cte_users_with_device AS d
    ON u.user_id = d.user_id
 GROUP BY u.language
 ORDER BY total_users_per_language DESC;

