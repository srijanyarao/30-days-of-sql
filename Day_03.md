# Day 03 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Google (Medium Level) hashtag#SQL Interview Question — Solution

You are analyzing a social network dataset at Google. Your task is to find mutual friends between two users, Karl and Hans. There is only one user named Karl and one named Hans in the dataset.

The output should contain 'user_id' and 'user_name' columns.

🔗 Understanding how to join tables in SQL is essential for effective data analysis; mastering this concept allows you to combine related data seamlessly. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE users(user_id INT, user_name varchar(30));
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE friends(user_id INT, friend_id INT);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);

## My Thought Process

To approach this problem, I focused on using inner joins, since the goal was to connect information across the users and friends tables.

My first step was to build CTEs that join users and friends on u.user_id = f.user_id so I could isolate the friend lists for Karl and Hans. Once I had those two sets, I compared them to identify the friend_ids that appear in both lists — essentially finding the overlap between Karl’s friends and Hans’s friends.

After identifying the common friend_ids, I joined that result back to the users table to retrieve the required output columns: user_id and user_name, which represent the mutual friends.

## SQL Solution
```sql
-- SQLite
CREATE TABLE users(
    user_id INT, 
    user_name varchar(30)
);
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE friends(
    user_id INT, 
    friend_id INT
);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);

with Karl_friends AS(
    SELECT  u.user_id, u.user_name, f.friend_id
      FROM  users as u
      JOIN friends as f
      ON    u.user_id = f.user_id
      WHERE u.user_name = 'Karl'
),
Hans_friends AS(
    SELECT  u.user_id, u.user_name, f.friend_id
      FROM  users as u
      JOIN friends as f
      ON    u.user_id = f.user_id
      WHERE u.user_name = 'Hans'
)
SELECT u.user_id, u.user_name
FROM  karl_friends AS K
JOIN  Hans_friends as H
 ON   K.friend_id = H.friend_id
JOIN  users as u
 ON   K.friend_id = u.user_id;

