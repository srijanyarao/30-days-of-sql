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

-- step 1 : getting total number of users

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
