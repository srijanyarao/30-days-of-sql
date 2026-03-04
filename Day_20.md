# Day 20 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Apple, Microsoft, Dell (Easy Level) hashtag#SQL Interview Question — Solution

Write a query that returns the number of unique users per client per month

🔍Easiest one, but it's been asked by multiple top companies. Give it a try and share your output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE fact_events (id INT PRIMARY KEY,time_id DATETIME,user_id VARCHAR(20),customer_id VARCHAR(50),client_id VARCHAR(20),event_type VARCHAR(50),event_id INT);

INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES(1, '2020-02-28', '3668-QPYBK', 'Sendit', 'desktop', 'message sent', 3),(2, '2020-02-28', '7892-POOKP', 'Connectix', 'mobile', 'file received', 2),(3, '2020-04-03', '9763-GRSKD', 'Zoomit', 'desktop', 'video call received', 7),(4, '2020-04-02', '9763-GRSKD', 'Connectix', 'desktop', 'video call received', 7),(5, '2020-02-06', '9237-HQITU', 'Sendit', 'desktop', 'video call received', 7),(6, '2020-02-27', '8191-XWSZG', 'Connectix', 'desktop', 'file received', 2),(7, '2020-04-03', '9237-HQITU', 'Connectix', 'desktop', 'video call received', 7),(8, '2020-03-01', '9237-HQITU', 'Connectix', 'mobile', 'message received', 4),(9, '2020-04-02', '4190-MFLUW', 'Connectix', 'mobile', 'video call received', 7),(10, '2020-04-21', '9763-GRSKD', 'Sendit', 'desktop', 'file received', 2);

## My Thought Process

For this one, the goal is to figure out how many unique users each client had in a given month. Since the timestamps are stored as full datetime values, the first step is to pull out the month component. I used strftime to extract the year‑month from time_id, which makes grouping straightforward. After that, it’s just a matter of grouping by client_id and the extracted month, then counting distinct user_id values.

## SQL Solution
```sql
CREATE TABLE fact_events (
    id INT PRIMARY KEY,
    time_id DATETIME,
    user_id VARCHAR(20),
    customer_id VARCHAR(50),
    client_id VARCHAR(20),
    event_type VARCHAR(50),
    event_id INT
);

INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES(1, '2020-02-28', '3668-QPYBK', 'Sendit', 'desktop', 'message sent', 3),(2, '2020-02-28', '7892-POOKP', 'Connectix', 'mobile', 'file received', 2),(3, '2020-04-03', '9763-GRSKD', 'Zoomit', 'desktop', 'video call received', 7),(4, '2020-04-02', '9763-GRSKD', 'Connectix', 'desktop', 'video call received', 7),(5, '2020-02-06', '9237-HQITU', 'Sendit', 'desktop', 'video call received', 7),(6, '2020-02-27', '8191-XWSZG', 'Connectix', 'desktop', 'file received', 2),(7, '2020-04-03', '9237-HQITU', 'Connectix', 'desktop', 'video call received', 7),(8, '2020-03-01', '9237-HQITU', 'Connectix', 'mobile', 'message received', 4),(9, '2020-04-02', '4190-MFLUW', 'Connectix', 'mobile', 'video call received', 7),(10, '2020-04-21', '9763-GRSKD', 'Sendit', 'desktop', 'file received', 2);

SELECT client_id, time_id, count(DISTINCT user_id) AS unique_users
  FROM fact_events
 GROUP BY client_id, strftime('%m', time_id);
