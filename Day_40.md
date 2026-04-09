# Day 40 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Walmart (Hard Level) hashtag#SQL Interview Question — Solution

Identify users who started a session and placed an order on the same day. For these users, calculate the total number of orders and the total order value for that day. Your output should include the user, the session date, the total number of orders, and the total order value for that day.

🔍 Definitely you are going to enjoy by solving this, you'll learn how to use join & group by. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE sessions(session_id INT, user_id INT, session_date DATETIME);

INSERT INTO sessions (session_id, user_id, session_date) VALUES (1, 1, '2024-01-01'), (2, 2, '2024-01-02'), (3, 3, '2024-01-05'), (4, 3, '2024-01-05'), (5, 4, '2024-01-03'), (6, 4, '2024-01-03'), (7, 5, '2024-01-04'), (8, 5, '2024-01-04'), (9, 3, '2024-01-05'), (10, 5, '2024-01-04');

CREATE TABLE order_summary (order_id INT, user_id INT, order_value INT, order_date DATETIME);

INSERT INTO order_summary (order_id, user_id, order_value, order_date) VALUES (1, 1, 152, '2024-01-01'), (2, 2, 485, '2024-01-02'), (3, 3, 398, '2024-01-05'), (4, 3, 320, '2024-01-05'), (5, 4, 156, '2024-01-03'), (6, 4, 121, '2024-01-03'), (7, 5, 238, '2024-01-04'), (8, 5, 70, '2024-01-04'), (9, 3, 152, '2024-01-05'), (10, 5, 171, '2024-01-04');

## My Thought Process

The sessions table has multiple rows per user per day, so joining it directly to the orders table would multiply rows. To avoid that, I first reduced the sessions table to one row per user per day.

Once I had a clean user‑date list, I joined it to the orders table on both user and date. From there, it was just grouping and aggregating the order metrics.

The key step is normalizing both timestamps to the date level. Even though the sample data doesn’t include time components, real datasets usually do, and joining on full datetime values would miss valid matches.

## SQL Solution
```sql

WITH session_days AS (
    SELECT DISTINCT user_id,
           DATE(session_date) AS session_date
      FROM sessions
)
SELECT s.user_id,
       s.session_date,
       COUNT(o.order_id) AS total_orders,
       SUM(o.order_value) AS total_order_value
  FROM session_days AS s
  JOIN order_summary1 AS o
    ON s.user_id = o.user_id
   AND s.session_date = DATE(o.order_date)
 GROUP BY s.user_id, s.session_date;