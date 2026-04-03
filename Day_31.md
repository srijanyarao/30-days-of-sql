# Day 31 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Spotify(Hard Level) hashtag#SQL Interview Question — Solution

Find the number of days a US track has stayed in the 1st position for both the US and worldwide rankings on the same day. Output the track name and the number of days in the 1st position. Order your output alphabetically by track name. If the region 'US' appears in dataset, it should be included in the worldwide ranking

🔍By solving this, you'll learn how to use group by. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE spotify_daily_rankings_2017_us (position INT,trackname VARCHAR(255),artist VARCHAR(255),streams INT,url VARCHAR(255),date DATETIME);

INSERT INTO spotify_daily_rankings_2017_us (position, trackname, artist, streams, url, date)VALUES(1, 'Track A', 'Artist 1', 500000, 'https://url1.com', '2017-01-01'),(2, 'Track B', 'Artist 2', 400000, 'https://url2.com', '2017-01-01'),(1, 'Track A', 'Artist 1', 520000, 'https://url1.com', '2017-01-02'),(3, 'Track C', 'Artist 3', 300000, 'https://url3.com', '2017-01-02'),(1, 'Track D', 'Artist 4', 600000, 'https://url4.com', '2017-01-03');

CREATE TABLE spotify_worldwide_daily_song_ranking (id INT,position INT,trackname VARCHAR(255),artist VARCHAR(255),streams INT,url VARCHAR(255),date DATETIME,region VARCHAR(50));

INSERT INTO spotify_worldwide_daily_song_ranking (id, position, trackname, artist, streams, url, date, region)VALUES(1, 1, 'Track A', 'Artist 1', 550000, 'https://url1.com', '2017-01-01', 'US'),(2, 2, 'Track B', 'Artist 2', 450000, 'https://url2.com', '2017-01-01', 'US'),(3, 1, 'Track A', 'Artist 1', 530000, 'https://url1.com', '2017-01-02', 'US'),(4, 1, 'Track D', 'Artist 4', 610000, 'https://url4.com', '2017-01-03', 'US'),(5, 3, 'Track C', 'Artist 3', 320000, 'https://url3.com', '2017-01-03', 'US');

## My Thought Process

To figure out how many days a US track held the #1 spot in both tables on the same date, I joined the US rankings with the worldwide rankings using the track name and date. From there, I filtered for US region records and kept only the rows where both rankings were in the first position. After that, I grouped by track name and counted the number of qualifying days.

## SQL Solution
```sql
SELECT us.trackname, count(*) AS num_of_days
  FROM spotify_daily_rankings_2017_us AS us
  JOIN spotify_worldwide_daily_song_ranking AS w
    ON us.trackname = w.trackname AND us.date = w.date
 WHERE region = 'US' AND us.position = 1 AND w.position = 1
 GROUP BY us.trackname;
