# Day 02 – SQL Practice

## Problem Statement

𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon (Hard Level) hashtag#SQL Interview Question — Solution

Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year. The percentage change column will be populated from the 2nd month forward and calculated as ((this month’s revenue — last month’s revenue) / last month’s revenue)*100.

⏳ Dealing with dates in SQL is really important; mastering this skill gives you valuable exposure.Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE sf_transactions(id INT, created_at datetime, value INT, purchase_id INT);

INSERT INTO sf_transactions VALUES
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),(4, '2019-01-13 00:00:00',  164911, 30),(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),(9, '2019-02-02 00:00:00',  140032, 25), (10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), (13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), (16, '2019-03-02 00:00:00', 157548, 19), (17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), (19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), (21, '2019-03-22 00:00:00', 151688, 47), (22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);


## My Thought Process

To work with dates in SQLite, I used the `strftime` function to extract the year and month from the `created_at` column. This allowed me to calculate the total revenue for each month.

For the previous‑month CTE, I took each `YYYY‑MM` value and added `'-01'` to turn it into a complete date. Once it became a valid date, I could subtract one month to get the correct previous‑month value, which I needed for the comparison.

After that, I joined the current month with its previous month using the condition where the previous‑month key matches the earlier month’s `year_month`. With both months aligned in the same row, I calculated the revenue change between them in the main query.


## SQL Solution
```sql
-- SQLite
CREATE TABLE sf_transactions(id INT, 
    created_at datetime, 
    value INT, 
    purchase_id INT
);

INSERT INTO sf_transactions(id, created_at, value, purchase_id) VALUES
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),(4, '2019-01-13 00:00:00',  164911, 30),(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),(9, '2019-02-02 00:00:00',  140032, 25), (10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), (13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), (16, '2019-03-02 00:00:00', 157548, 19), (17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), (19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), (21, '2019-03-22 00:00:00', 151688, 47), (22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);



with monthly_revenue AS(
    SELECT strftime('%Y-%m', created_at) as 'YYYY_MM',SUM(value) as total_monthly_revenue
     FROM  sf_transactions 
     GROUP BY strftime('%Y-%m', created_at)
),
previous_months AS(
    SELECT *,strftime('%Y-%m',date((YYYY_MM || '-01'), '-1 month')) as previous_month
     FROM  monthly_revenue
),
Join_months AS(
    SELECT m1.YYYY_MM, M1.total_monthly_revenue,
           m2.YYYY_MM, m2.total_monthly_revenue as last_month_revenue
     FROM previous_months as m1
     left JOIN previous_months as m2
     on m1.previous_month = m2.YYYY_MM
)
SELECT YYYY_MM,total_monthly_revenue,ROUND((((total_monthly_revenue- last_month_revenue) * 1.0/last_month_revenue)*100),2) as percentage_change from Join_months;
    




