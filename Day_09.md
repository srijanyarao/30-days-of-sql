# Day 09 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Netflix (Hard Level) hashtag#SQL Interview Question — Solution

Find the genre of the person with the most number of oscar winnings.
If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. Use the names as keys when joining the tables.

🔍 By solving this, you'll learn how to use join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE nominee_information(name varchar(20), amg_person_id varchar(10), top_genre varchar(10), birthday datetime, id int);

INSERT INTO nominee_information VALUES('Jennifer Lawrence','P562566','Drama','1990-08-15',755),('Jonah Hill','P418718','Comedy','1983-12-20',747),('Anne Hathaway', 'P292630','Drama', '1982-11-12',744),('Jennifer Hudson','P454405','Drama', '1981-09-12',742),('Rinko Kikuchi', 'P475244','Drama', '1981-01-06', 739);

CREATE TABLE oscar_nominees(year int, category varchar(30), nominee varchar(20), movie varchar(30), winner int, id int);

INSERT INTO oscar_nominees VALUES(2008,'actress in a leading role','Anne Hathaway','Rachel Getting Married',0,77),(2012,'actress in a supporting role','Anne HathawayLes','Mis_rables',1,78),(2006,'actress in a supporting role','Jennifer Hudson','Dreamgirls',1,711),(2010,'actress in a leading role','Jennifer Lawrence','Winters Bone',1,717),(2012,'actress in a leading role','Jennifer Lawrence','Silver Linings Playbook',1,718),(2011,'actor in a supporting role','Jonah Hill','Moneyball',0,799),(2006,'actress in a supporting role','Rinko Kikuchi','Babel',0,1253);

## My Thought Process

To find the genre of the person with the most Oscar wins, I first filtered the oscar_nominees table to keep only the rows where winner = 1. Then I ordered those results by the number of wins in descending order, and used the name as the alphabetical tie‑breaker.

After that, I joined the filtered results with the nominee_information table using the name column, as the question required. From the joined data, I selected the top row and pulled the genre of that person.

## SQL Solution
```sql
CREATE TABLE nominee_information(
    name varchar(20), 
    amg_person_id varchar(10), 
    top_genre varchar(10), 
    birthday datetime, 
    id int
);

INSERT INTO nominee_information VALUES('Jennifer Lawrence','P562566','Drama','1990-08-15',755),('Jonah Hill','P418718','Comedy','1983-12-20',747),('Anne Hathaway', 'P292630','Drama', '1982-11-12',744),('Jennifer Hudson','P454405','Drama', '1981-09-12',742),('Rinko Kikuchi', 'P475244','Drama', '1981-01-06', 739);

CREATE TABLE oscar_nominees(
    year int, 
    category varchar(30), 
    nominee varchar(20), 
    movie varchar(30), 
    winner int, 
    id int
);

INSERT INTO oscar_nominees VALUES(2008,'actress in a leading role','Anne Hathaway','Rachel Getting Married',0,77),(2012,'actress in a supporting role','Anne HathawayLes','Mis_rables',1,78),(2006,'actress in a supporting role','Jennifer Hudson','Dreamgirls',1,711),(2010,'actress in a leading role','Jennifer Lawrence','Winters Bone',1,717),(2012,'actress in a leading role','Jennifer Lawrence','Silver Linings Playbook',1,718),(2011,'actor in a supporting role','Jonah Hill','Moneyball',0,799),(2006,'actress in a supporting role','Rinko Kikuchi','Babel',0,1253);


WITH num_oscar_wins AS(
    SELECT nominee, count(winner) as num_of_wins
      FROM oscar_nominees
     WHERE winner = 1
     GROUP BY nominee
     ORDER BY num_of_wins DESC, nominee ASC
)
SELECT n.top_genre
  FROM nominee_information as n
  JOIN num_oscar_wins as o
   ON  n.name = o.nominee
 limit 1;

