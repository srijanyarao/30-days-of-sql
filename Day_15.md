# Day 15 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Google (Medium Level) hashtag#SQL Interview Question — Solution

Find all records from days when the number of distinct users receiving emails was greater than the number of distinct users sending emails.

🔍 By solving this, you'll learn how to use agg function and join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE google_gmail_emails (id INT PRIMARY KEY,from_user VARCHAR(50),to_user VARCHAR(50),day INT);

INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),(9, '6edf0be4b2267df1fa', 'd63386c884aeb9f71d', 3),(10, '6edf0be4b2267df1fa', '5b8754928306a18b68', 2),(11, '6edf0be4b2267df1fa', '6edf0be4b2267df1fa', 8),(12, '6edf0be4b2267df1fa', '406539987dd9b679c0', 9),(13, '6edf0be4b2267df1fa', '114bafadff2d882864', 5),(14, '6edf0be4b2267df1fa', '157e3e9278e32aba3e', 2),(15, '75d295377a46f83236', '75d295377a46f83236', 6),(16, '75d295377a46f83236', 'd63386c884aeb9f71d', 8),(17, '75d295377a46f83236', '55e60cfcc9dc49c17e', 3),(18, '75d295377a46f83236', '47be2887786891367e', 10),(19, '75d295377a46f83236', '5b8754928306a18b68', 10),(20, '75d295377a46f83236', '850badf89ed8f06854', 7);

## My Thought Process
To figure out which days had more unique receivers than senders, I first grouped the data by day and used COUNT(DISTINCT ...) to get the number of unique users in each role. After that, I joined these results back to the main table on the day column so I could return all the rows from the days that met the condition. Finally, I filtered using d.distant_receivers > d.distant_senders and ordered the output by day.

## SQL Solution
```sql
CREATE TABLE google_gmail_emails (
    id INT PRIMARY KEY,
    from_user VARCHAR(50),
    to_user VARCHAR(50),
    day INT
);

INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),(9, '6edf0be4b2267df1fa', 'd63386c884aeb9f71d', 3),(10, '6edf0be4b2267df1fa', '5b8754928306a18b68', 2),(11, '6edf0be4b2267df1fa', '6edf0be4b2267df1fa', 8),(12, '6edf0be4b2267df1fa', '406539987dd9b679c0', 9),(13, '6edf0be4b2267df1fa', '114bafadff2d882864', 5),(14, '6edf0be4b2267df1fa', '157e3e9278e32aba3e', 2),(15, '75d295377a46f83236', '75d295377a46f83236', 6),(16, '75d295377a46f83236', 'd63386c884aeb9f71d', 8),(17, '75d295377a46f83236', '55e60cfcc9dc49c17e', 3),(18, '75d295377a46f83236', '47be2887786891367e', 10),(19, '75d295377a46f83236', '5b8754928306a18b68', 10),(20, '75d295377a46f83236', '850badf89ed8f06854', 7);

SELECT * FROM google_gmail_emails;

with distant_user_counts AS(
    SELECT day, count(DISTINCT to_user) AS distant_receivers,  
           count(DISTINCT from_user) AS distant_senders
      FROM google_gmail_emails
     GROUP BY day
)
SELECT g.id, g.from_user, g.to_user, g.day
  FROM google_gmail_emails AS g
  JOIN distant_user_counts AS d
    ON g.day = d.day
 WHERE d.distant_receivers > d.distant_senders
 ORDER BY g.day;
