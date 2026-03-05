# Day 21 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Microsoft (Hard Level) hashtag#SQL Interview Question — Solution

Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads. 

Note: In Oracle you should use "date" when referring to date column (reserved keyword).

🔍By solving this, you'll learn how to use join, groupby and having. Give it a try and share the output!👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE ms_user_dimension (user_id INT PRIMARY KEY,acc_id INT);
INSERT INTO ms_user_dimension (user_id, acc_id) VALUES (1, 101),(2, 102),(3, 103),(4, 104),(5, 105);

CREATE TABLE ms_acc_dimension (acc_id INT PRIMARY KEY,paying_customer VARCHAR(10));
INSERT INTO ms_acc_dimension (acc_id, paying_customer) VALUES (101, 'Yes'),(102, 'No'),(103, 'Yes'),(104, 'No'),(105, 'No');

CREATE TABLE ms_download_facts (date DATETIME,user_id INT,downloads INT);
INSERT INTO ms_download_facts (date, user_id, downloads) VALUES ('2024-10-01', 1, 10),('2024-10-01', 2, 15),('2024-10-02', 1, 8),('2024-10-02', 3, 12),('2024-10-02', 4, 20),('2024-10-03', 2, 25),('2024-10-03', 5, 18);

## My Thought Process

To return only the dates where non‑paying users have more downloads than paying users, I first need to connect all three tables. The ms_user_dimension table links each user to an account, and the ms_acc_dimension table tells me whether that account is paying or not. After joining those with the ms_download_facts table, every download record will carry the paying/non‑paying flag.

Once the data is joined, I can group it by date and use conditional aggregation to separate totals for paying and non‑paying users. With those two sums in place, the HAVING clause lets me filter out dates where non‑paying downloads are higher than paying downloads. The final output just needs the date along with the two aggregated download counts, ordered from earliest to latest.

## SQL Solution
```sql
CREATE TABLE ms_user_dimension (
    user_id INT PRIMARY KEY,
    acc_id INT
);

INSERT INTO ms_user_dimension (user_id, acc_id) VALUES (1, 101),(2, 102),(3, 103),(4, 104),(5, 105);

CREATE TABLE ms_acc_dimension (
    acc_id INT PRIMARY KEY,
    paying_customer VARCHAR(10)
);

INSERT INTO ms_acc_dimension (acc_id, paying_customer) VALUES (101, 'Yes'),(102, 'No'),(103, 'Yes'),(104, 'No'),(105, 'No');

CREATE TABLE ms_download_facts (
    date DATETIME,
    user_id INT,
    downloads INT
);

INSERT INTO ms_download_facts (date, user_id, downloads) VALUES ('2024-10-01', 1, 10),('2024-10-01', 2, 15),('2024-10-02', 1, 8),('2024-10-02', 3, 12),('2024-10-02', 4, 20),('2024-10-03', 2, 25),('2024-10-03', 5, 18);


SELECT * FROM ms_user_dimension;

SELECT * FROM ms_acc_dimension;

SELECT * FROM ms_download_facts;

SELECT d.date AS date,
       sum(CASE WHEN paying_customer= 'No' THEN downloads ELSE 0 END) AS non_paying_downloads,
       sum(CASE WHEN paying_customer= 'Yes' THEN downloads ELSE 0 END) AS paying_downloads
  FROM ms_user_dimension AS us
  JOIN ms_acc_dimension  AS acc
    ON us.acc_id = acc.acc_id
  JOIN ms_download_facts AS d
    ON us.user_id = d.user_id
 GROUP BY date
HAVING sum(CASE WHEN paying_customer= 'No' THEN d.downloads ELSE 0 END) > sum(CASE WHEN paying_customer= 'Yes' THEN d.downloads ELSE 0 END);

