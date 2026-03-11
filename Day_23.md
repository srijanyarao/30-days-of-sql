# Day 23 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Oracle(Hard Level) hashtag#SQL Interview Question — Solution

Write a query that compares each employee's salary to their manager's and the average department salary (excluding the manager's salary). Display the department, employee ID, employee's salary, manager's salary, and department average salary. Order by department, then by employee salary (highest to lowest).

🔍By solving this, you'll learn how to use cte, mutiple join, groupby. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE employee_o (id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),age INT,gender VARCHAR(10),employee_title VARCHAR(50),department VARCHAR(50),salary INT,manager_id INT);

INSERT INTO employee_o (id, first_name, last_name, age, gender, employee_title, department, salary, manager_id) VALUES(1, 'Alice', 'Smith', 45, 'F', 'Manager', 'HR', 9000, 1),(2, 'Bob', 'Johnson', 34, 'M', 'Assistant', 'HR', 4500, 1),(3, 'Charlie', 'Williams', 28, 'M', 'Coordinator', 'HR', 4800, 1),(4, 'Diana', 'Brown', 32, 'F', 'Manager', 'IT', 12000, 4),(5, 'Eve', 'Jones', 27, 'F', 'Analyst', 'IT', 7000, 4),(6, 'Frank', 'Garcia', 29, 'M', 'Developer', 'IT', 7500, 4),(7, 'Grace', 'Miller', 30, 'F', 'Manager', 'Finance', 10000, 7),(8, 'Hank', 'Davis', 26, 'M', 'Analyst', 'Finance', 6200, 7),(9, 'Ivy', 'Martinez', 31, 'F', 'Clerk', 'Finance', 5900, 7),(10, 'John', 'Lopez', 36, 'M', 'Manager', 'Marketing', 11000, 10),(11, 'Kim', 'Gonzales', 29, 'F', 'Specialist', 'Marketing', 6800, 10),(12, 'Leo', 'Wilson', 27, 'M', 'Coordinator', 'Marketing', 6600, 10);

## My Thought Process
To solve this, I broke the problem into two pieces: getting the department average without managers, and getting each manager’s salary. I created two CTEs — one for the department averages and one for manager salaries — so the main query stays readable.

For the department average, I filtered out managers since the requirement says their salaries shouldn’t be included. For the manager salary lookup, I pulled only the rows where the employee is a manager. In the final select, I added a CASE expression to handle self‑reporting managers so their own salary doesn’t show up as their manager’s salary. After joining everything together, I ordered the results by department and then by salary in descending order.

## SQL Solution
```sql
CREATE TABLE employee_o (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    employee_title VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    manager_id INT
);

INSERT INTO employee_o (id, first_name, last_name, age, gender, employee_title, department, salary, manager_id) VALUES(1, 'Alice', 'Smith', 45, 'F', 'Manager', 'HR', 9000, 1),(2, 'Bob', 'Johnson', 34, 'M', 'Assistant', 'HR', 4500, 1),(3, 'Charlie', 'Williams', 28, 'M', 'Coordinator', 'HR', 4800, 1),(4, 'Diana', 'Brown', 32, 'F', 'Manager', 'IT', 12000, 4),(5, 'Eve', 'Jones', 27, 'F', 'Analyst', 'IT', 7000, 4),(6, 'Frank', 'Garcia', 29, 'M', 'Developer', 'IT', 7500, 4),(7, 'Grace', 'Miller', 30, 'F', 'Manager', 'Finance', 10000, 7),(8, 'Hank', 'Davis', 26, 'M', 'Analyst', 'Finance', 6200, 7),(9, 'Ivy', 'Martinez', 31, 'F', 'Clerk', 'Finance', 5900, 7),(10, 'John', 'Lopez', 36, 'M', 'Manager', 'Marketing', 11000, 10),(11, 'Kim', 'Gonzales', 29, 'F', 'Specialist', 'Marketing', 6800, 10),(12, 'Leo', 'Wilson', 27, 'M', 'Coordinator', 'Marketing', 6600, 10);

SELECT * FROM employee_o;

with dept_avg_salary AS(
    SELECT department,AVG(salary) as department_avg_salary
      FROM employee_o
     WHERE employee_title <> 'Manager'
     GROUP BY department
),
manager_salary AS(
    SELECT manager_id,department,salary
      FROM employee_o
     where employee_title = 'Manager'
)
SELECT e.department, e.id, e.salary,
       (CASE WHEN e.id = M.manager_id THEN NULL ELSE m.salary END) as manager_salary , d.department_avg_salary
  FROM employee_o as e
  JOIN manager_salary as M
    ON e.manager_id = M.manager_id 
  JOIN dept_avg_salary as d
    ON e.department = d.department
 ORDER BY e.department, e.salary DESC; 