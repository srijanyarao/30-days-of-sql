# Day 36 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Uber (Hard Level) hashtag#SQL Interview Question — Solution

Find the most profitable location. Write a query that calculates the average signup duration and average transaction amount for each location, and then compare these two measures together by taking the ratio of the average transaction amount and average duration for each location.

Your output should include the location, average duration, average transaction amount, and ratio. Sort your results from highest ratio to lowest.

🔍By solving this, you'll learn how to use CTE, Join, Group By, Having, Case, Avg. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE signups (signup_id INT PRIMARY KEY, signup_start_date DATETIME, signup_stop_date DATETIME, plan_id INT, location VARCHAR(100));

INSERT INTO signups (signup_id, signup_start_date, signup_stop_date, plan_id, location) VALUES (1, '2020-01-01 10:00:00', '2020-01-01 12:00:00', 101, 'New York'), (2, '2020-01-02 11:00:00', '2020-01-02 13:00:00', 102, 'Los Angeles'), (3, '2020-01-03 10:00:00', '2020-01-03 14:00:00', 103, 'Chicago'), (4, '2020-01-04 09:00:00', '2020-01-04 10:30:00', 101, 'San Francisco'), (5, '2020-01-05 08:00:00', '2020-01-05 11:00:00', 102, 'New York');

CREATE TABLE transactions (transaction_id INT PRIMARY KEY,signup_id INT,transaction_start_date DATETIME,amt FLOAT,FOREIGN KEY (signup_id) REFERENCES signups(signup_id));

INSERT INTO transactions (transaction_id, signup_id, transaction_start_date, amt) VALUES (1, 1, '2020-01-01 10:30:00', 50.00), (2, 1, '2020-01-01 11:00:00', 30.00), (3, 2, '2020-01-02 11:30:00', 100.00), (4, 2, '2020-01-02 12:00:00', 75.00), (5, 3, '2020-01-03 10:30:00', 120.00), (6, 4, '2020-01-04 09:15:00', 80.00), (7, 5, '2020-01-05 08:30:00', 90.00);

## My Thought Process

The goal is to compare how long users take to sign up versus how much revenue they generate. To do that, I first calculated each signup’s duration using the start and stop timestamps. Then I averaged those durations by location.

Next, I calculated the average transaction amount per location. After that, I joined both results on location and created a profitability ratio using: avg_amount / avg_duration

Finally, I sorted the locations by this ratio to see which one delivers the most revenue relative to signup time.

This type of problem is common in retail analytics when you’re comparing customer effort vs value. For example, time spent in a funnel vs. revenue, or onboarding friction vs. conversion quality.

## SQL Solution
```sql
with signup_duration AS(
    SELECT signup_id,location, (strftime('%s',signup_stop_date)-strftime('%s',signup_start_date))/60.0 AS signup_duration
      FROM signups
),
avg_signup_duration AS(
    SELECT location, AVG(signup_duration) AS avg_duration_minutes
      FROM signup_duration
     GROUP BY location
),
avg_transaction_amount AS(
    SELECT s.location, Round(AVG(t.amt),2) AS avg_amount
      FROM signups AS s
      JOIN transactions AS t
        ON s.signup_id = t.signup_id
     GROUP BY s.location 
)
SELECT s.location,s.avg_duration_minutes,t.avg_amount, 
       Round((t.avg_amount/s.avg_duration_minutes),2) AS profitability_ratio
  FROM avg_transaction_amount AS t
  JOIN avg_signup_duration AS s
    ON t.location = s.location
 ORDER BY profitability_ratio DESC;