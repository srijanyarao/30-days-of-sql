# Day 52 – SQL Practice

## Problem Statement

𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Tesla (Hard Level) #SQL Interview Question — Solution

The company you are working for wants to anticipate their staffing needs by identifying their top two busiest times of the week. To find this, each day should be segmented into differents parts using following criteria:

Morning: Before 12 p.m. (not inclusive)
Early afternoon: 12 -15 p.m.
Late afternoon: after 15 p.m. (not inclusive)

Your output should include the day and time of day combination for the two busiest times, i.e. the combinations with the most orders, along with the number of orders (e.g. top two results could be Friday Late afternoon with 12 orders and Sunday Morning with 10 orders). The company has also requested that the day be displayed in text format (i.e. Monday).

Note: In the event of a tie in ranking, all results should be displayed.

🔍By solving this, you'll learn how to use Group by, CTE and Windows function. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE sales_log (order_id BIGINT PRIMARY KEY,product_id BIGINT,timestamp DATETIME);

INSERT INTO sales_log (order_id, product_id, timestamp) VALUES  (1, 101, '2024-12-15 09:30:00'), (2, 102, '2024-12-15 11:45:00'), (3, 103, '2024-12-15 12:10:00'), (4, 104, '2024-12-15 13:15:00'), (5, 105, '2024-12-15 14:20:00'), (6, 106, '2024-12-15 15:30:00'), (7, 107, '2024-12-15 16:40:00'), (8, 108, '2024-12-16 09:50:00'), (9, 109, '2024-12-16 10:30:00'), (10, 110, '2024-12-16 12:05:00'), (11, 111, '2024-12-16 13:50:00'), (12, 112, '2024-12-16 14:15:00'), (13, 113, '2024-12-16 15:30:00'), (14, 114, '2024-12-17 09:45:00'), (15, 115, '2024-12-17 11:20:00'), (16, 116, '2024-12-17 12:25:00'), (17, 117, '2024-12-17 13:30:00'), (18, 118, '2024-12-17 14:55:00'), (19, 119, '2024-12-17 15:10:00'), (20, 120, '2024-12-18 10:40:00');

## My Thought Process

I first extracted the weekday and time‑of‑day segment for every order using strftime() and a CASE expression.

Once each record had a clean label, I grouped by weekday and time period to get the order counts. From there, I used DENSE_RANK() to identify the top two busiest combinations.

The final output returns the weekday, time period, and total orders for those ranked segments.

## SQL Solution
```sql
WITH cte_time_periods AS(
    SELECT *,
           CASE 
               WHEN CAST(strftime('%w',timestamp) AS INT) = 0  THEN 'Sunday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 1  THEN 'Monday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 2  THEN 'Tuesday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 3  THEN 'Wednesday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 4  THEN 'Thrusday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 5  THEN 'Friday'
               WHEN CAST(strftime('%w',timestamp) AS INT)  = 6  THEN 'Saturday'
            END AS week_day,
           CASE 
               WHEN CAST(strftime('%H',timestamp) AS INT) < 12 THEN 'Morning'
               WHEN CAST(strftime('%H',timestamp) AS INT) >= 12  AND CAST(strftime('%H',timestamp) AS INT) < 15 THEN 'Early afternoon'
               ELSE 'Late afternoon'
            END AS time_of_day
      FROM sales_log
),
cte_Number_of_orders AS(
    SELECT week_day,
           time_of_day,
           count(order_id) AS Number_of_orders
      FROM cte_time_periods
     GROUP BY week_day, time_of_day
),
cte_Ranking AS(
    SELECT *,
           DENSE_RANK() OVER(ORDER BY Number_of_orders DESC) AS rank
      FROM cte_Number_of_orders
)
SELECT week_day || ' ' || time_of_day || ' with ' || Number_of_orders || ' orders' AS busiest_times
  FROM cte_Ranking
 WHERE rank IN (1,2);