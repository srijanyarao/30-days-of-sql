# Day 01 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon (Hard Level) hashtag#SQL Interview Question — Solution

Given the users' sessions logs on a particular day, calculate how many hours each user was active that day. Note: The session starts when state=1 and ends when state=0.

🌀 Trust me, this one will surely challenge you...! Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE customer_state_log (cust_id VARCHAR(10),state INT,timestamp TIME);

INSERT INTO customer_state_log (cust_id, state, timestamp) VALUES('c001', 1, '07:00:00'),('c001', 0, '09:30:00'),('c001', 1, '12:00:00'),('c001', 0, '14:30:00'),('c002', 1, '08:00:00'),('c002', 0, '09:30:00'),('c002', 1, '11:00:00'),('c002', 0, '12:30:00'),('c002', 1, '15:00:00'),('c002', 0, '16:30:00'),('c003', 1, '09:00:00'),('c003', 0, '10:30:00'),('c004', 1, '10:00:00'),('c004', 0, '10:30:00'),('c004', 1, '14:00:00'),('c004', 0, '15:30:00'),('c005', 1, '10:00:00'),('c005', 0, '14:30:00'),('c005', 1, '15:30:00'),('c005', 0, '18:30:00');

## My Thought Process

I treat each state = 1 as the beginning of a session and the next state = 0 as the end. I sort the logs by user and timestamp, pair each start with its corresponding end, compute the duration of each session, and then sum all session durations for each user. This gives me the total number of hours each user was active that day.

SQLite’s strftime lets me extract date and time components or convert timestamps to Unix seconds. For duration calculations, I use strftime('%s') because SQLite doesn’t support direct time arithmetic.

🔹 How a Data Analyst Should Approach This Problem

This is a classic sessionization problem — the same pattern used in product analytics, web analytics, and customer‑behavior tracking.

Your job is to figure out:

when a user becomes active

when they stop

and how long that active window lasts

Then you sum all active windows for each user.


## SQL Solution
```sql
WITH end_state_session AS(
    SELECT *,
           LEAD(state) OVER (PARTITION BY cust_id ORDER BY timestamp) AS end_state,
           LEAD(timestamp) OVER (PARTITION BY cust_id ORDER BY timestamp) AS next_timestamp
      FROM customer_state_log
)
SELECT cust_id, SUM(strftime('%s',next_timestamp)-strftime('%s',timestamp))/3600.0 AS User_active_time
  FROM end_state_session
 WHERE state = 1 AND end_state = 0
 GROUP BY cust_id;