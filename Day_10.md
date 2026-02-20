# Day 10 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon(Medium Level)

[**hashtag#SQL**](https://www.linkedin.com/search/results/all/?keywords=%23sql&origin=HASH_TAG_FROM_FEED)

Interview Question — Solution

Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. Output a list of user_ids of these returning active users.

🔍 By solving this, you'll learn how to use self join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:

CREATE TABLE amazon_transactions(id int, user_id int, item varchar(15), created_at datetime, revenue int);

INSERT INTO amazon_transactions VALUES (1,109,'milk','2020-03-03 00:00:00',123),(2,139,'biscuit','2020-03-18 00:00:00', 421), (3,120,'milk','2020-03-18 00:00:00',176), (4,108,'banana','2020-03-18 00:00:00',862), (5,130,'milk','2020-03-28 00:00:00',333), (6,103,'bread','2020-03-29 00:00:00',862), (7,122,'banana','2020-03-07 00:00:00',952), (8,125,'bread','2020-03-13 00:00:00',317), (9,139,'bread','2020-03-30 00:00:00',929), (10,141,'banana','2020-03-17 00:00:00',812), (11,116,'bread','2020-03-31 00:00:00',226), (12,128,'bread','2020-03-04 00:00:00',112), (13,146,'biscuit','2020-03-04 00:00:00',362), (14,119,'banana','2020-03-28 00:00:00',127), (15,142,'bread','2020-03-09 00:00:00',503), (16,122,'bread','2020-03-06 00:00:00',593), (17,128,'biscuit','2020-03-24 00:00:00',160), (18,112,'banana','2020-03-24 00:00:00',262), (19,149,'banana','2020-03-29 00:00:00',382), (20,100,'banana','2020-03-18 00:00:00',599);

## My Thought Process

I solved this by using a self‑join to compare each purchase a user made with their other purchases. The goal was to check whether any second purchase happened within 7 days of a previous one. To do that, I used julianday(), which converts the datetime into a numeric day count. That made it easy to subtract one purchase date from another and see if the difference was 7 days or less.

## SQL Solution
```sql
CREATE TABLE amazon_transactions(id int, user_id int, item varchar(15), created_at datetime, revenue int);

INSERT INTO amazon_transactions VALUES (1,109,'milk','2020-03-03 00:00:00',123),(2,139,'biscuit','2020-03-18 00:00:00', 421), (3,120,'milk','2020-03-18 00:00:00',176), (4,108,'banana','2020-03-18 00:00:00',862), (5,130,'milk','2020-03-28 00:00:00',333), (6,103,'bread','2020-03-29 00:00:00',862), (7,122,'banana','2020-03-07 00:00:00',952), (8,125,'bread','2020-03-13 00:00:00',317), (9,139,'bread','2020-03-30 00:00:00',929), (10,141,'banana','2020-03-17 00:00:00',812), (11,116,'bread','2020-03-31 00:00:00',226), (12,128,'bread','2020-03-04 00:00:00',112), (13,146,'biscuit','2020-03-04 00:00:00',362), (14,119,'banana','2020-03-28 00:00:00',127), (15,142,'bread','2020-03-09 00:00:00',503), (16,122,'bread','2020-03-06 00:00:00',593), (17,128,'biscuit','2020-03-24 00:00:00',160), (18,112,'banana','2020-03-24 00:00:00',262), (19,149,'banana','2020-03-29 00:00:00',382), (20,100,'banana','2020-03-18 00:00:00',599);

SELECT a.user_id
 FROM amazon_transactions as a
 JOIN amazon_transactions as a1
 ON a1.user_id = a.user_id AND a1.created_at > a.created_at AND (julianday(a1.created_at) - julianday(a.created_at) <= 7);

