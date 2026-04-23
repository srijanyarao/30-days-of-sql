# Day 51 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon (Hard Level) #SQL Interview Question — Solution

You have been asked to find the fifth highest salary without using TOP or LIMIT. Note: Duplicate salaries should not be removed.

🔍By solving this, you'll learn how to use CTE and Windows function. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE com_worker ( worker_id BIGINT PRIMARY KEY, department VARCHAR(25), first_name VARCHAR(25), last_name VARCHAR(25), joining_date DATETIME, salary BIGINT);

INSERT INTO com_worker (worker_id, department, first_name, last_name, joining_date, salary) VALUES  (1, 'HR', 'John', 'Doe', '2020-01-15', 50000), (2, 'IT', 'Jane', 'Smith', '2019-03-10', 60000), (3, 'Finance', 'Emily', 'Jones', '2021-06-20', 75000), (4, 'Sales', 'Michael', 'Brown', '2018-09-05', 60000), (5, 'Marketing', 'Chris', 'Johnson', '2022-04-12', 70000), (6, 'IT', 'David', 'Wilson', '2020-11-01', 80000), (7, 'Finance', 'Sarah', 'Taylor', '2017-05-25', 45000), (8, 'HR', 'James', 'Anderson', '2023-01-09', 65000), (9, 'Sales', 'Anna', 'Thomas', '2020-02-18', 55000), (10, 'Marketing', 'Robert', 'Jackson', '2021-07-14', 60000);

## My Thought Process

To solve this, I used a window function to assign a rank to each salary in descending order. Since duplicates should keep their own positions, I used DENSE_RANK() to generate the ranking. After that, I filtered for the row where the rank equals five, which gives the fifth highest salary based on the dataset.

This type of problem shows up often in analytics work, especially when ranking metrics like sales, revenue, or customer spend. The pattern is the same: sort the values, assign a rank, and filter for the position you need. It’s a common approach when building leaderboards, top‑N reports, or performance summaries in retail analytics.

## SQL Solution
```sql
WITH salary_rank AS(
    SELECT salary, 
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rank
      FROM com_worker
)
SELECT DISTINCT salary
  FROM salary_rank
 WHERE rank = 5;