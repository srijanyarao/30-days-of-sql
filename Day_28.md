# Day 28 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Meta, Salesforce (Hard Level) hashtag#SQL Interview Question — Solution

Find the highest salary among salaries that appears only once.

🔍By solving this, you'll learn how to use group by. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE employee(id INT,first_name VARCHAR(50),last_name VARCHAR(50),age INT,sex VARCHAR(1),employee_title VARCHAR(50),department VARCHAR(50),salary INT,target INT,bonus INT,email VARCHAR(100),city VARCHAR(50),address VARCHAR(100),manager_id INT);

INSERT INTO employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)VALUES(5, 'Max', 'George', 26, 'M', 'Sales', 'Sales', 1300, 200, 150, 'Max@company.com', 'California', '2638 Richards Avenue', 1),(13, 'Katty', 'Bond', 56, 'F', 'Manager', 'Management', 150000, 0, 300, 'Katty@company.com', 'Arizona', NULL, 1),(11, 'Richerd', 'Gear', 57, 'M', 'Manager', 'Management', 250000, 0, 300, 'Richerd@company.com', 'Alabama', NULL, 1),(10, 'Jennifer', 'Dion', 34, 'F', 'Sales', 'Sales', 1000, 200, 150, 'Jennifer@company.com', 'Alabama', NULL, 13),(19, 'George', 'Joe', 50, 'M', 'Manager', 'Management', 250000, 0, 300, 'George@company.com', 'Florida', '1003 Wyatt Street', 1),(18, 'Laila', 'Mark', 26, 'F', 'Sales', 'Sales', 1000, 200, 150, 'Laila@company.com', 'Florida', '3655 Spirit Drive', 11),(20, 'Sarrah', 'Bicky', 31, 'F', 'Senior Sales', 'Sales', 2000, 200, 150, 'Sarrah@company.com', 'Florida', '1176 Tyler Avenue', 19);

## My Thought Process

For this problem, the goal was to find the highest salary that appears only once in the dataset. I approached it by grouping the rows by salary and checking how many times each salary shows up. From there, I filtered out everything except the salaries that occur exactly once. After isolating those unique values, I selected the highest one.

This pattern is simple but useful — it’s a clean example of how grouping and the HAVING clause help identify unique values before applying a final aggregation.

## SQL Solution
```sql

with unique_salary AS(
    SELECT salary
      FROM employee
     GROUP BY salary
    HAVING count(*) = 1
)
SELECT Max(salary) AS highest_salary
  FROM unique_salary; 