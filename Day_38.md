# Day 38 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Airbnb (Hard Level) hashtag#SQL Interview Question — Solution

Estimate the growth of Airbnb each year using the number of hosts registered as the growth metric. The rate of growth is calculated by taking ((number of hosts registered in the current year - number of hosts registered in the previous year) / the number of hosts registered in the previous year) * 100. Output the year, number of hosts in the current year, number of hosts in the previous year, and the rate of growth. Round the rate of growth to the nearest percent and order the result in the ascending order based on the year. 

Assume that the dataset consists only of unique hosts, meaning there are no duplicate hosts listed.

🌀 Definitely you are going to enjoy by solving this, you'll learn how to use multiple CTE and windows functions. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE airbnb_search_details ( id INT PRIMARY KEY, price FLOAT, property_type VARCHAR(100), room_type VARCHAR(100), amenities VARCHAR(MAX), accommodates INT, bathrooms INT, bed_type VARCHAR(50), cancellation_policy VARCHAR(50), cleaning_fee BIT, city VARCHAR(100), host_identity_verified VARCHAR(10), host_response_rate VARCHAR(10), host_since DATETIME, neighbourhood VARCHAR(100), number_of_reviews INT, review_scores_rating FLOAT, zipcode INT, bedrooms INT, beds INT);


INSERT INTO airbnb_search_details (id, price, property_type, room_type, amenities, accommodates, bathrooms, bed_type, cancellation_policy, cleaning_fee, city, host_identity_verified, host_response_rate, host_since, neighbourhood, number_of_reviews, review_scores_rating, zipcode, bedrooms, beds)  VALUES (7, 150, 'House', 'Entire home/apt', 'WiFi, Kitchen', 5, 2, 'Queen Bed', 'Flexible', 1, 'Seattle', 'Yes', '90%', '2019-05-30', 'Capitol Hill', 200, 4.6, 98102, 2, 3),(8, 60, 'Apartment', 'Shared room', 'WiFi', 1, 1, 'Single Bed', 'Moderate', 0, 'Boston', 'Yes', '80%', '2018-04-18', 'Beacon Hill', 50, 4.2, 02108, 1, 1),(9, 90, 'House', 'Private room', 'WiFi, Parking', 3, 2, 'King Bed', 'Strict', 1, 'Denver', 'No', '85%', '2021-02-10', 'Downtown', 75, 4.0, 80202, 1, 2),(10, 250, 'Villa', 'Entire home/apt', 'Pool, WiFi, Kitchen', 8, 4, 'King Bed', 'Flexible', 1, 'Las Vegas', 'Yes', '95%', '2022-06-15', 'The Strip', 400, 4.9, 89109, 4, 5);


## My Thought Process

📌 Problem Context
For this exercise, I wanted to understand how the number of Airbnb hosts has changed year over year. This is a pretty common pattern in analytics — especially in retail — where you compare performance between two time periods to measure growth, decline, or stability. In retail, the same logic shows up when you track things like year‑over‑year sales, customer counts, transactions, or product launches.

The core idea is simple:
take a metric for the current period, compare it to the previous period, and calculate the percentage change.

🧠 What I Did
I grouped hosts by the year they joined, used window functions to pull the previous year’s values, and then calculated the growth rate. The only tricky part was making sure the window functions were applied after aggregation, so I handled that inside a CTE.

## SQL Solution
```sql

with host_count_each_year AS(
    SELECT strftime('%Y', host_since) AS current_Year,
           count(*) AS current_year_hosts
      FROM airbnb_search_detail
     GROUP BY strftime('%Y', host_since)
),
growth_rate AS(
    SELECT current_year, 
           current_year_hosts,
           LAG(current_year_hosts) OVER (ORDER BY current_year) AS previous_year_hosts,
           ((current_year_hosts-LAG(current_year_hosts) OVER (ORDER BY current_year))*100.0/LAG(current_year_hosts) OVER (ORDER BY current_year)) AS growth_rate
      FROM host_count_each_year
)
SELECT current_Year,
       current_year_hosts,
       previous_year_hosts,
       growth_rate
  FROM growth_rate
 ORDER BY current_Year ASC;