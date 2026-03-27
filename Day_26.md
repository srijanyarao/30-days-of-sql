# Day 26 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Linkedln (Hard Level) hashtag#SQL Interview Question — Solution

Consider all LinkedIn users who, at some point, worked at Microsoft. For how many of them was Google their next employer right after Microsoft (no employers in between)?

🌀 Trust me, this one will seriously twist your brain! Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE linkedin_users (user_id INT,employer VARCHAR(255),position VARCHAR(255),start_date DATETIME,end_date DATETIME);

INSERT INTO linkedin_users (user_id, employer, position, start_date, end_date) VALUES(1, 'Microsoft', 'developer', '2020-04-13', '2021-11-01'),(1, 'Google', 'developer', '2021-11-01', NULL),(2, 'Google', 'manager', '2021-01-01', '2021-01-11'),(2, 'Microsoft', 'manager', '2021-01-11', NULL),(3, 'Microsoft', 'analyst', '2019-03-15', '2020-07-24'),(3, 'Amazon', 'analyst', '2020-08-01', '2020-11-01'),(3, 'Google', 'senior analyst', '2020-11-01', '2021-03-04'),(4, 'Google', 'junior developer', '2018-06-01', '2021-11-01'),(4, 'Google', 'senior developer', '2021-11-01', NULL),(5, 'Microsoft', 'manager', '2017-09-26', NULL),(6, 'Google', 'CEO', '2015-10-02', NULL);


## My Thought Process

Worked on a LinkedIn‑style interview question about tracking a user’s next employer after leaving Microsoft. The goal was to figure out how many people moved directly to Google with no other job in between.

The tricky part was getting the timeline right. I used a window function to look at each user’s next employer based on their start dates. Once the sequence was in place, the logic became much clearer.

This one pushed me to think more carefully about ordering, partitions, and how LEAD() actually behaves when you’re working with career history data. Good practice for real‑world analytics problems where the sequence matters just as much as the values.

## SQL Solution
```sql
CREATE TABLE linkedin_users (
    user_id INT,
    employer VARCHAR(255),
    position VARCHAR(255),
    start_date DATETIME,
    end_date DATETIME
);

INSERT INTO linkedin_users (user_id, employer, position, start_date, end_date) VALUES(1, 'Microsoft', 'developer', '2020-04-13', '2021-11-01'),(1, 'Google', 'developer', '2021-11-01', NULL),(2, 'Google', 'manager', '2021-01-01', '2021-01-11'),(2, 'Microsoft', 'manager', '2021-01-11', NULL),(3, 'Microsoft', 'analyst', '2019-03-15', '2020-07-24'),(3, 'Amazon', 'analyst', '2020-08-01', '2020-11-01'),(3, 'Google', 'senior analyst', '2020-11-01', '2021-03-04'),(4, 'Google', 'junior developer', '2018-06-01', '2021-11-01'),(4, 'Google', 'senior developer', '2021-11-01', NULL),(5, 'Microsoft', 'manager', '2017-09-26', NULL),(6, 'Google', 'CEO', '2015-10-02', NULL);

SELECT * FROM linkedin_users;


WITH next_employer_cte AS(
  SELECT *,LEAD(employer, 1, 'No next job') OVER(PARTITION BY user_id ORDER BY start_date) AS next_employer
    FROM linkedin_users
)
SELECT user_id
  FROM next_employer_cte 
 where employer = 'Microsoft' and next_employer = 'Google';


