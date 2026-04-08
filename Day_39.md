# Day 39 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon (Hard Level) hashtag#SQL Interview Question — Solution

Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid. The best selling item is calculated using the formula (unitprice * quantity). Output the month, the description of the item along with the amount paid.

🌀 Definitely you are going to enjoy by solving this, you'll learn how to use multiple CTE and windows functions. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE online_retail (invoiceno VARCHAR(50),stockcode VARCHAR(50),description VARCHAR(255),quantity INT,invoicedate DATETIME,unitprice FLOAT,customerid FLOAT,country VARCHAR(100));

INSERT INTO online_retail (invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country)VALUES('536365', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 10, '2021-01-15 10:00:00', 2.55, 17850, 'United Kingdom'),('536366', '71053', 'WHITE METAL LANTERN', 5, '2021-02-10 12:00:00', 3.39, 13047, 'United Kingdom'),('536367', '84406B', 'CREAM CUPID HEARTS COAT HANGER', 8, '2021-03-05 15:00:00', 2.75, 17850, 'United Kingdom'),('536368', '22423', 'REGENCY CAKESTAND 3 TIER', 2, '2021-04-12 16:30:00', 12.75, 13047, 'United Kingdom'),('536369', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 15, '2021-05-18 11:00:00', 2.55, 13047, 'United Kingdom'),('536370', '21730', 'GLASS STAR FROSTED T-LIGHT HOLDER', 12, '2021-06-25 14:00:00', 4.25, 17850, 'United Kingdom');


## My Thought Process

The goal is to find the top‑selling product for each month.
In the first CTE, I calculated monthly sales for each product by grouping on the month and summing quantity × unitprice.
In the second CTE, I ranked the products within each month based on total sales.
In the final step, I filtered for the rows where the rank equals 1.

This is a classic retail analytics pattern — identifying the “top performer” in a given time period. The same structure shows up when you look for the best‑selling product of the month, the highest‑revenue category, or the top‑performing store. It’s all about aggregating, ranking, and filtering.

## SQL Solution
```sql
with Monthly_Sales AS(
    SELECT strftime('%m',invoicedate) AS Month,
           description,
           SUM(quantity * unitprice) AS sales
      FROM online_retail
     GROUP BY strftime('%m',invoicedate)
),
sales_Ranking AS (
    SELECT *, 
           RANK() OVER (PARTITION BY Month ORDER BY sales DESC) AS rank
      FROM Monthly_Sales
)
SELECT Month,
       description,
       sales
  FROM sales_Ranking
 WHERE rank = 1;