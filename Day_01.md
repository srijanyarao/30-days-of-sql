# Day 01 – SQL Practice

## Problem Statement
A table named “famous” has two columns called user id and follower id. It represents each user ID has a particular follower ID. These follower IDs are also users of hashtag#Facebook / hashtag#Meta. Then, find the famous percentage of each user. 
Famous Percentage = number of followers a user has / total number of users on the platform.

🔍 At first glance, this might seem tedious, but it's straightforward once you break it down. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE famous (user_id INT, follower_id INT);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);

## My Thought Process
As a beginner, this was my first time writing multiple CTE blocks, so I approached the problem step by step.

I started by combining user_id and follower_id using a UNION. Since set operators remove duplicates, this gave me the total unique users on the platform.

In the follower_count CTE, I calculated how many followers each user has.

Finally, I computed the famous percentage by dividing each user’s follower count by the total number of users. I used a scalar subquery to reference the total user count inside the final calculation.

## SQL Solution
```sql
-- SQLite
-- SQLite
Create Table famous1 (
    user_id INT, 
    follower_id INT
);

INSERT INTO famous1 ( user_id, follower_id) VALUES 
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3),

(11, 7), (12, 8), (13, 5), (13, 10),

(14, 12), (14, 3), (15, 14), (15, 13);


with num_of_users AS(
    SELECT user_id 
      FROM famous1
    UNION 
    SELECT follower_id
     FROM  famous1
),
follwer_count AS(
    SELECT user_id, count(follower_id) as follwers_count
     FROM  famous1
     GROUP BY user_id
)
SELECT user_id, Round((follwers_count * 100.0/(SELECT count(*) as total_distinct_users FROM num_of_users)), 2) as famous_percentage 
 FROM  follwer_count;

