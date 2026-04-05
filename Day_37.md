# Day 37 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Netflix(Hard Level) hashtag#SQL Interview Question — Solution

Find all the users who were active for 3 consecutive days or more.

😍 Definitely you are going to enjoy by solving this, you'll learn how to use CTE and windows functions. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE sf_events (date DATETIME,account_id VARCHAR(10),user_id VARCHAR(10));

INSERT INTO sf_events (date, account_id, user_id) VALUES('2021-01-01', 'A1', 'U1'),('2021-01-01', 'A1', 'U2'),('2021-01-06', 'A1', 'U3'),('2021-01-02', 'A1', 'U1'),('2020-12-24', 'A1', 'U2'),('2020-12-08', 'A1', 'U1'),('2020-12-09', 'A1', 'U1'),('2021-01-10', 'A2', 'U4'),('2021-01-11', 'A2', 'U4'),('2021-01-12', 'A2', 'U4'),('2021-01-15', 'A2', 'U5'),('2020-12-17', 'A2', 'U4'),('2020-12-25', 'A3', 'U6'),('2020-12-25', 'A3', 'U6'),('2020-12-25', 'A3', 'U6'),('2020-12-06', 'A3', 'U7'),('2020-12-06', 'A3', 'U6'),('2021-01-14', 'A3', 'U6'),('2021-02-07', 'A1', 'U1'),('2021-02-10', 'A1', 'U2'),('2021-02-01', 'A2', 'U4'),('2021-02-01', 'A2', 'U5'),('2020-12-05', 'A1', 'U8');


## My Thought Process

To identify users who were active for 3 consecutive days, I started by pulling the previous and next activity dates for each user using LAG() and LEAD(). Once I had those values, I compared the gaps using julianday() to check whether the activity happened exactly one day apart.

If both conditions were true (previous → current = 1 day) and (current → next = 1 day) then that user was active for at least a 3‑day streak.

This type of problem shows up often in retail analytics when you’re analyzing customer engagement streaks, such as daily app opens, repeat visits, or loyalty behavior over time.

## SQL Solution
```sql
with previous_next_day AS (
    SELECT user_id,
           LAG(date) OVER (PARTITION BY user_id ORDER BY date) AS previous_date,
           date,
           LEAD(date) OVER (PARTITION BY user_id ORDER BY date) AS next_date
      FROM sf_events
),
difference_in_days AS(
    SELECT user_id
      FROM previous_next_day
     WHERE (julianday(date)-julianday(previous_date)) = 1
       AND (julianday(next_date)-julianday(date)) = 1
)
SELECT * FROM difference_in_days;