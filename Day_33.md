# Day 33 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Google(Hard Level) hashtag#SQL Interview Question — Solution

Calculate the average session distance traveled by Google Fit users using GPS data for two scenarios:
 Considering Earth's curvature (Haversine formula).
 Assuming a flat surface.
For each session, use the distance between the highest and lowest step IDs, and ignore sessions with only one step. Calculate and output the average distance for both scenarios and the difference between them.

Formulas:
1. Curved Earth: d=6371×arccos(sin(ϕ1​)×sin(ϕ2​)+cos(ϕ1​)×cos(ϕ2​)×cos(λ2​−λ1​))
2. Flat Surface: d=111×(lat2​−lat1​)2+(lon2​−lon1​)2​

🔍By solving this, you'll learn how to use CTE, Group By, Having, Case. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE google_fit_location (user_id VARCHAR(50),session_id INT,step_id INT,day INT,latitude FLOAT,longitude FLOAT,altitude FLOAT);

INSERT INTO google_fit_location (user_id, session_id, step_id, day, latitude, longitude, altitude)VALUES('user_1', 101, 1, 1, 37.7749, -122.4194, 15.0),('user_1', 101, 2, 1, 37.7750, -122.4195, 15.5),('user_1', 101, 3, 1, 37.7751, -122.4196, 16.0),('user_1', 102, 1, 1, 34.0522, -118.2437, 20.0),('user_1', 102, 2, 1, 34.0523, -118.2438, 20.5),('user_2', 201, 1, 1, 40.7128, -74.0060, 5.0),('user_2', 201, 2, 1, 40.7129, -74.0061, 5.5),('user_2', 202, 1, 1, 51.5074, -0.1278, 10.0),('user_2', 202, 2, 1, 51.5075, -0.1279, 10.5),('user_3', 301, 1, 1, 48.8566, 2.3522, 25.0),('user_3', 301, 2, 1, 48.8567, 2.3523, 25.5);


I have provided an explanation and query, but I encourage you to try solving it first. Later, you can check the query for reference

## My Thought Process

The goal is to calculate the average distance traveled in each session using two methods: curved‑earth and flat‑surface. To do that, I first needed the minimum and maximum step IDs per session. Those represent the start and end points.

Once I had those, I joined them back to the original table to pull the coordinates for each point. After that, it was just applying the two formulas and taking the average across all sessions.

The main idea is to build the solution in layers instead of trying to do everything in one query. CTEs make the logic easier to follow and debug.

### Problem Overview
This question looks simple on the surface, but it’s really testing whether you can break a problem into steps, isolate the right rows, and apply the correct formulas. Even though the dataset is about Google Fit, the structure of the problem is something I see often in retail analytics:

identifying the first and last event in a sequence

joining those events back to the base table

calculating a metric based on those two points

aggregating the metric at a higher level

In retail, this shows up in things like:

first‑touch vs last‑touch customer behavior

first and last scan in a store visit

start vs end of a delivery route

earliest vs latest timestamp in a transaction chain

So the logic here is very transferable.

## SQL Solution
```sql
with min_max_steps AS(
    SELECT user_id, session_id, MIN(step_id) AS min_step_id,
           MAX(step_id) AS max_step_id
      FROM google_fit_location
     GROUP BY user_id, session_id
    HAVING count(*) > 1
),
latitude_longitude AS(
    SELECT mn.*,
           g.latitude AS lat1,
           g.longitude AS lon1,
           g2.latitude AS lat2,
           g2.longitude AS lon2
      FROM min_max_steps AS mn
      JOIN google_fit_location AS g
        ON mn.user_id = g.user_id AND
           mn.session_id = g.session_id AND
           mn.min_step_id = g.step_id
      JOIN google_fit_location AS g2
        ON mn.user_id = g2.user_id AND
           mn.session_id = g2.session_id AND
           mn.max_step_id = g2.step_id
),
distance_travelled AS(
    SELECT *, 
           6371 * ACOS(SIN(RADIANS(lat1)) * SIN(RADIANS(lat2)) + COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * COS(RADIANS(lon2 - lon1))) AS Curved_Earth_Distance,
           111 * SQRT(POWER(lat2 - lat1, 2) + POWER(lon2 - lon1, 2)) AS Flat_Surface_Distance
      FROM latitude_longitude
)
SELECT Round(AVG(Curved_Earth_Distance),3) AS Avg_Curved_Earth_Distance,
       Round(AVG(Flat_Surface_Distance),3) AS Avg_Flat_Surface_Distance,
       Round((AVG(Flat_Surface_Distance) - AVG(Curved_Earth_Distance)),3) AS Diff_distance
  FROM distance_travelled;
