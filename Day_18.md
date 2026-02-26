# Day 18 – SQL Practice

## Problem Statement

𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon, Doordash(Medium Level)hashtag#SQL Interview Question — Solution

You have been asked to find the job titles of the highest-paid employees.
Your output should include the highest-paid title or multiple titles with the same salary.

🔍 By solving this, you'll learn how to use subquery and join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE worker(worker_id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,joining_date DATETIME,department VARCHAR(50));

INSERT INTO worker(worker_id, first_name, last_name, salary, joining_date, department) VALUES(1, 'John', 'Doe', 80000, '2020-01-15', 'Engineering'),(2, 'Jane', 'Smith', 120000, '2019-03-10', 'Marketing'),(3, 'Alice', 'Brown', 120000, '2021-06-21', 'Sales'),(4, 'Bob', 'Davis', 75000, '2018-04-30', 'Engineering'),(5, 'Charlie', 'Miller', 95000, '2021-01-15', 'Sales');

CREATE TABLE title(worker_ref_id INT,worker_title VARCHAR(50),affected_from DATETIME);

INSERT INTO title(worker_ref_id, worker_title, affected_from) VALUES(1, 'Engineer', '2020-01-15'),(2, 'Marketing Manager', '2019-03-10'),(3, 'Sales Manager', '2021-06-21'),(4, 'Junior Engineer', '2018-04-30'),(5, 'Senior Salesperson', '2021-01-15');

## My Thought Process

To get the titles of the highest‑paid employees, I joined the worker and title tables on the worker ID. Then I filtered the rows by comparing each worker’s salary to the maximum salary in the dataset, which I pulled using a subquery. This gives me the title (or titles) of everyone who earns the top salary.

## SQL Solution
```sql
CREATE TABLE worker(
    worker_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary INT,
    joining_date DATETIME,
    department VARCHAR(50)
);

INSERT INTO worker(worker_id, first_name, last_name, salary, joining_date, department) VALUES(1, 'John', 'Doe', 80000, '2020-01-15', 'Engineering'),(2, 'Jane', 'Smith', 120000, '2019-03-10', 'Marketing'),(3, 'Alice', 'Brown', 120000, '2021-06-21', 'Sales'),(4, 'Bob', 'Davis', 75000, '2018-04-30', 'Engineering'),(5, 'Charlie', 'Miller', 95000, '2021-01-15', 'Sales');

CREATE TABLE title(
    worker_ref_id INT,
    worker_title VARCHAR(50),
    affected_from DATETIME
);

INSERT INTO title(worker_ref_id, worker_title, affected_from) VALUES(1, 'Engineer', '2020-01-15'),(2, 'Marketing Manager', '2019-03-10'),(3, 'Sales Manager', '2021-06-21'),(4, 'Junior Engineer', '2018-04-30'),(5, 'Senior Salesperson', '2021-01-15');


SELECT t.worker_title
  FROM worker as w
  JOIN title as t
    ON w.worker_id = t.worker_ref_id
 WHERE w.salary = (SELECT Max(salary) FROM worker);