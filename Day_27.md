# Day 27 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: GoldmanSachs, Deloitte(Hard Level) hashtag#SQL Interview Question — Solution

You are given a day worth of scheduled departure and arrival times of trains at one train station. One platform can only accommodate one train from the beginning of the minute it's scheduled to arrive until the end of the minute it's scheduled to depart. Find the minimum number of platforms necessary to accommodate the entire scheduled traffic.

🌀 Trust me, this one will seriously twist your brain! Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE train_arrivals (train_id INT, arrival_time DATETIME);

INSERT INTO train_arrivals (train_id, arrival_time) VALUES(1, '2024-11-17 08:00'),(2, '2024-11-17 08:05'),(3, '2024-11-17 08:05'),(4, '2024-11-17 08:10'),(5, '2024-11-17 08:10'),(6, '2024-11-17 12:15'),(7, '2024-11-17 12:20'),(8, '2024-11-17 12:25'),(9, '2024-11-17 15:00'),(10, '2024-11-17 15:00'),(11, '2024-11-17 15:00'),(12, '2024-11-17 15:06'),(13, '2024-11-17 20:00'),(14, '2024-11-17 20:10');

CREATE TABLE train_departures (train_id INT, departure_time DATETIME);

INSERT INTO train_departures (train_id, departure_time) VALUES(1, '2024-11-17 08:15'),(2, '2024-11-17 08:10'),(3, '2024-11-17 08:20'),(4, '2024-11-17 08:25'),(5, '2024-11-17 08:20'),(6, '2024-11-17 13:00'),(7, '2024-11-17 12:25'),(8, '2024-11-17 12:30'),(9, '2024-11-17 15:05'),(10, '2024-11-17 15:10'),(11, '2024-11-17 15:15'),(12, '2024-11-17 15:15'),(13, '2024-11-17 20:15'),(14, '2024-11-17 20:15');

## My Thought Process

The core idea behind this problem is simple: how many trains are at the station at the same time?  
Once that’s clear, the rest becomes a matter of tracking how the load changes over time.

I converted each interval into two events — one arrival and one departure. Arrivals add to the platform count, departures reduce it. After combining everything into a single timeline, I sorted the events and calculated how many trains were present at each moment. That running count shows how many platforms are being used at any given time.

The highest value in that running total is the minimum number of platforms the station needs to handle the full schedule.


🎯 Why this structure works
Because you’re not comparing intervals to each other.
You’re tracking state changes over time.

This is the same approach used in:

- concurrency analysis

- call‑center staffing

- hospital bed occupancy

- website traffic peaks


## SQL Solution
```sql

WITH unified_table AS(
    SELECT train_id, arrival_time AS time_stamp, +1 AS event_type FROM train_arrivals

    UNION 

    SELECT train_id,departure_time AS time_stamp, -1 AS event_type FROM train_departures
),
Running_platform AS(
    SELECT SUM(event_type) OVER (ORDER BY time_stamp) as running_platforms
      FROM unified_table
)
SELECT MAX(running_platforms) AS min_num_of_paltforms FROM Running_platform;


