# Day 42 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Microsoft (Medium Level) hashtag#SQL Interview Question — Solution

Write a query that returns the company (customer id column) with highest number of users that use desktop only.

🔍 Definitely you are going to enjoy by solving this, you'll learn how to use cte, subquery. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE fact_events (id INT PRIMARY KEY, time_id DATETIME, user_id VARCHAR(50), customer_id VARCHAR(50), client_id VARCHAR(50), event_type VARCHAR(50), event_id INT);

INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES  (1, '2024-12-01 10:00:00', 'U1', 'C1', 'desktop', 'click', 101), (2, '2024-12-01 11:00:00', 'U2', 'C1', 'mobile', 'view', 102), (3, '2024-12-01 12:00:00', 'U3', 'C2', 'desktop', 'click', 103), (4, '2024-12-01 13:00:00', 'U1', 'C1', 'desktop', 'click', 104), (5, '2024-12-01 14:00:00', 'U2', 'C1', 'tablet', 'view', 105), (6, '2024-12-01 15:00:00', 'U4', 'C3', 'desktop', 'click', 106), (7, '2024-12-01 16:00:00', 'U3', 'C2', 'desktop', 'click', 107), (8, '2024-12-01 17:00:00', 'U5', 'C4', 'desktop', 'click', 108), (9, '2024-12-01 18:00:00', 'U6', 'C4', 'mobile', 'view', 109), (10, '2024-12-01 19:00:00', 'U7', 'C5', 'desktop', 'click', 110);

## My Thought Process

### 🎯 Problem Summary
You’re given an event‑level table where each row represents a user performing an action on a device (desktop, mobile, tablet) for a company (customer_id).
Your task is to identify:

Which company has the highest number of users who use ONLY desktop (and no other device)?

This is a two‑level aggregation problem:

User‑level logic → Determine which users are desktop‑only

Company‑level logic → Count those users per company

### 1. User‑level logic
Figure out which users qualify as “desktop‑only.”
A user qualifies only if every event tied to them comes from desktop.
This means checking their entire device history, not just filtering rows.

### 2. Company‑level logic
Once the user segment is clean, count how many of those users belong to each company.
This is where the aggregation shifts from user → company.

This two‑step structure is common in retail analytics whenever you’re building segments or cohorts and then evaluating them at a higher business level.

## SQL Solution
```sql

WITH desktop_users_only AS(
    SELECT user_id,
           customer_id
      FROM fact_events1
     GROUP BY user_id
    HAVING COUNT(DISTINCT client_id) = 1 
       AND client_id = 'desktop'
)
SELECT customer_id, COUNT( DISTINCT user_id) AS desktop_users
  FROM fact_events1
 WHERE user_id IN (SELECT user_id 
                      FROM desktop_users_only)
 GROUP BY customer_id;
