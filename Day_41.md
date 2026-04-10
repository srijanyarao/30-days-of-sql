# Day 41 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Meta/Facebook (Easy Level) hashtag#SQL Interview Question — Solution

Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

🔍 Easy one give a try, you'll learn how to use join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE facebook_reactions (poster INT, friend INT, reaction VARCHAR(50), date_day INT, post_id INT);

INSERT INTO facebook_reactions (poster, friend, reaction, date_day, post_id) VALUES  (1, 2, 'heart', 20240101, 101), (2, 3, 'heart', 20240102, 102), (3, 4, 'like', 20240103, 103), (4, 5, 'heart', 20240104, 104), (5, 6, 'laugh', 20240105, 105), (6, 7, 'heart', 20240106, 106);

CREATE TABLE facebook_posts (post_id INT PRIMARY KEY, poster INT, post_text VARCHAR(500), post_keywords VARCHAR(200), post_date DATETIME);

INSERT INTO facebook_posts (post_id, poster, post_text, post_keywords, post_date) VALUES (101, 1, 'Had a great day at the park!', 'park, fun', '2024-01-01 08:00:00'), (102, 2, 'Enjoying the new book I bought.', 'book, reading', '2024-01-02 09:00:00'), (103, 3, 'Looking forward to the weekend!', 'weekend, plans', '2024-01-03 10:00:00'), (104, 4, 'Just finished a workout session!', 'workout, fitness', '2024-01-04 11:00:00'), (105, 5, 'Great movie night with friends!', 'movie, friends', '2024-01-05 12:00:00'), (106, 6, 'Cooking dinner at home tonight.', 'cooking, food', '2024-01-06 13:00:00');

## My Thought Process

We need to join the facebook_posts table (fp) with the facebook_reactions table (fr) using the post_id. And the filter the records with heart reaction

## SQL Solution
```sql
SELECT fp.*
  FROM facebook_reactions AS fr
  JOIN facebook_posts AS fp
    ON fr.post_id = fp.post_id
 WHERE fr.reaction = 'heart';