# Day 14 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon, Salesforce (Basic Level) hashtag#SQL Interview Question — Solution

What is the total sales revenue of Samantha and Lisa?

🔊 Just wanted to point out that even major companies like Amazon ask questions this basic— so it's worth giving it a try! and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE sales_performance (salesperson VARCHAR(50),widget_sales INT,sales_revenue INT,id INT PRIMARY KEY);

INSERT INTO sales_performance (salesperson, widget_sales, sales_revenue, id) VALUES('Jim', 810, 40500, 1),('Bobby', 661, 33050, 2),('Samantha', 1006, 50300, 3),('Taylor', 984, 49200, 4),('Tom', 403, 20150, 5),('Pat', 715, 35750, 6),('Lisa', 1247, 62350, 7);

## My Thought Process
To get the total sales revenue for Samantha and Lisa, I filtered the table using a WHERE condition on their names and used the SUM function to add their revenue values together.

## SQL Solution
```sql
CREATE TABLE sales_performance (
    salesperson VARCHAR(50),
    widget_sales INT,
    sales_revenue INT,
    id INT PRIMARY KEY
);

INSERT INTO sales_performance (salesperson, widget_sales, sales_revenue, id) VALUES('Jim', 810, 40500, 1),('Bobby', 661, 33050, 2),('Samantha', 1006, 50300, 3),('Taylor', 984, 49200, 4),('Tom', 403, 20150, 5),('Pat', 715, 35750, 6),('Lisa', 1247, 62350, 7);

SELECT salesperson, SUM(sales_revenue) as total_sales_revenue
  FROM sales_performance
 WHERE salesperson IN ('Samantha','Lisa'); 