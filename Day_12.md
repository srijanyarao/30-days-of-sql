# Day 12 – SQL Practice

## Problem Statement
𝐇𝐚𝐩𝐩𝐲 𝐃𝐢𝐰𝐚𝐥𝐢🪔 𝐓𝐫𝐲 𝐋𝐚𝐭𝐞𝐫: LinkedIn, Dropbox (Basic Level) hashtag#SQL Interview Question — Solution

Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the absolute difference in salaries.

🔍 By solving this, you'll learn how to use case and join. Give it a try later and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE db_employee (id INT,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,department_id INT);

INSERT INTO db_employee (id, first_name, last_name, salary, department_id) VALUES(10306, 'Ashley', 'Li', 28516, 4),(10307, 'Joseph', 'Solomon', 19945, 1),(10311, 'Melissa', 'Holmes', 33575, 1),(10316, 'Beth', 'Torres', 34902, 1),(10317, 'Pamela', 'Rodriguez', 48187, 4),(10320, 'Gregory', 'Cook', 22681, 4),(10324, 'William', 'Brewer', 15947, 1),(10329, 'Christopher', 'Ramos', 37710, 4),(10333, 'Jennifer', 'Blankenship', 13433, 4),(10339, 'Robert', 'Mills', 13188, 1);

CREATE TABLE db_dept (id INT,department VARCHAR(50));

INSERT INTO db_dept (id, department) VALUES(1, 'engineering'),(2, 'human resource'),(3, 'operation'),(4, 'marketing');

## My Thought Process
To find the difference between the highest salaries in the engineering and marketing departments, I first joined the tables using department_id. Then I used a CASE expression to pull the top salary from each department and calculated the difference between them.

## SQL Solution
```sql
SELECT ABS(Max(CASE  WHEN d.department = 'marketing' THEN e.salary ELSE 0 END) - MAX(CASE  WHEN d.department = 'engineering' THEN e.salary ELSE 0 END)) as net_diff_highest_salaries
  FROM db_employee as e
  JOIN db_dept as d
    on e.department_id = d.id;
```

## Output

| net_diff_highest_salaries |
|---------------------------|
| 13285                     |

## Pattern
JOIN + Conditional Aggregation (CASE inside MAX)

🔹 Why this pattern fits:

This problem requires comparing two values from two different groups (highest salary in engineering vs. highest salary in marketing) in a single row.

To do that, you need:

JOIN → to bring department names into the employee table

CASE inside an aggregate → to selectively pick values for each department

ABS() → to compute the absolute difference

This pattern is extremely common in analytics when you need to compare:

revenue of two categories

counts of two user types

metrics of two regions

performance of two teams

Instead of writing two separate queries, conditional aggregation lets you compute both values in one pass
