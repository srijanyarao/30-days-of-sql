# Day 08 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Tesla(Medium Level) hashtag#SQL Interview Question — Solution

You are given a table of product launches by company by year. Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year. Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

🔍 By solving this, you'll learn how to handle aggregation function. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE car_launches(year int, company_name varchar(15), product_name varchar(30));

INSERT INTO car_launches VALUES(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler')

## My Thought Process

In the first CTE, I calculated the number of products for each company and year by grouping the data.

Then I used the LAG window function with a default value of 0, since a few companies only had one entry. With the partition logic, each company got its own previous value, ordered by year.

In the final query, I calculated the net difference between the number of products launched in 2020 and the previous year, 2019, to get the year‑over‑year change.

## SQL Solution
```sql
CREATE TABLE car_launches(
    year int, 
    company_name varchar(15), 
    product_name varchar(30)
);

INSERT INTO car_launches VALUES(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler');

SELECT * FROM car_launches;

with num_of_prodcuts AS(
    SELECT year,company_name,count(*) as num_of_products
     FROM  car_launches
     GROUP BY company_name, year
),
net_difference AS(
    SELECT *,LAG(num_of_products, 1,0) OVER (PARTITION BY company_name ORDER BY year) AS pre_year_num_of_products
    FROM num_of_prodcuts
)
SELECT company_name, (num_of_products -  pre_year_num_of_products) as net_difference_products
  FROM net_difference
  WHERE year = 2020;




