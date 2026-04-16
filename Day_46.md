# Day 46 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: EY, TCS, Deloitte, (Medium Level) hashtag#SQL Interview Question — Solution

In a marathon, gun time is counted from the moment of the formal start of the race while net time is counted from the moment a runner crosses a starting line. Both variables are in seconds.

You are asked to check if the interval between the two times is different for male and female runners. First, calculate the average absolute difference between the gun time and net time. Group the results by available genders (male and female). Output the absolute difference between those two values.

🔍By solving this, you'll learn how to use CTE, UNIONALL, CASE. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE marathon_male (age BIGINT, div_tot TEXT, gun_time BIGINT, hometown TEXT, net_time BIGINT, num BIGINT, pace BIGINT, person_name TEXT, place BIGINT);

INSERT INTO marathon_male (age, div_tot, gun_time, hometown, net_time, num, pace, person_name, place) VALUES (25, '1/100', 3600, 'New York', 3400, 101, 500, 'John Doe', 1), (30, '2/100', 4000, 'Boston', 3850, 102, 550, 'Michael Smith', 2), (22, '3/100', 4200, 'Chicago', 4150, 103, 600, 'David Johnson', 3);

CREATE TABLE marathon_female (age BIGINT, div_tot TEXT, gun_time BIGINT, hometown TEXT, net_time BIGINT, num BIGINT, pace BIGINT, person_name TEXT, place BIGINT);

INSERT INTO marathon_female (age, div_tot, gun_time, hometown, net_time, num, pace, person_name, place) VALUES (28, '1/100', 3650, 'San Francisco', 3600, 201, 510, 'Jane Doe', 1), (26, '2/100', 3900, 'Los Angeles', 3850, 202, 530, 'Emily Davis', 2), (24, '3/100', 4100, 'Seattle', 4050, 203, 590, 'Anna Brown', 3);

## My Thought Process
I started by calculating the average absolute difference for each gender separately. Using two CTEs kept the logic clean and made the next step easier. After that, I combined both results with a UNION ALL and computed the absolute difference between the male and female averages. This gives a single value that shows how far apart the two groups are.

## SQL Solution
```sql
with cte_female_net_difference AS(
    SELECT 'female' AS gender,
           AVG(ABS(gun_time - net_time)) AS net_difference
      FROM marathon_female
),
cte_male_net_difference AS(
    SELECT 'male' AS gender,
           AVG(ABS(gun_time - net_time)) AS net_difference
      FROM marathon_male
),
combined_table AS(
    SELECT *
      FROM cte_female_net_difference

    UNION ALL

    SELECT *
      FROM cte_male_net_difference
)
SELECT  ABS(MAX(CASE WHEN gender = 'female' THEN net_difference END) - 
        MAX(CASE WHEN gender = 'male' THEN net_difference END)) AS absolute_difference
  FROM combined_table;