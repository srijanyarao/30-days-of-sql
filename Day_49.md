# Day 49 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Goldman Sachs (Medium Level) hashtag#SQL Interview Question — Solution

You work for a multinational company that wants to calculate total sales across all their countries they do business in.
You have 2 tables, one is a record of sales for all countries and currencies the company deals with, and the other holds currency exchange rate information. Calculate the total sales, per quarter, for the first 2 quarters in 2020, and report the sales in USD currency.

🔍By solving this, you'll learn how to use Group By and Agg function. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE sf_exchange_rate ( date DATE, exchange_rate FLOAT, source_currency VARCHAR(10), target_currency VARCHAR(10));

INSERT INTO sf_exchange_rate (date, exchange_rate, source_currency, target_currency) VALUES ('2020-01-15', 1.1, 'EUR', 'USD'), ('2020-01-15', 1.3, 'GBP', 'USD'), ('2020-02-05', 1.2, 'EUR', 'USD'), ('2020-02-05', 1.35, 'GBP', 'USD'), ('2020-03-25', 1.15, 'EUR', 'USD'), ('2020-03-25', 1.4, 'GBP', 'USD'), ('2020-04-15', 1.2, 'EUR', 'USD'), ('2020-04-15', 1.45, 'GBP', 'USD'), ('2020-05-10', 1.1, 'EUR', 'USD'), ('2020-05-10', 1.3, 'GBP', 'USD'), ('2020-06-05', 1.05, 'EUR', 'USD'), ('2020-06-05', 1.25, 'GBP', 'USD');

CREATE TABLE sf_sales_amount ( currency VARCHAR(10), sales_amount BIGINT, sales_date DATE);

INSERT INTO sf_sales_amount (currency, sales_amount, sales_date) VALUES ('USD', 1000, '2020-01-15'), ('EUR', 2000, '2020-01-20'), ('GBP', 1500, '2020-02-05'), ('USD', 2500, '2020-02-10'), ('EUR', 1800, '2020-03-25'), ('GBP', 2200, '2020-03-30'), ('USD', 3000, '2020-04-15'), ('EUR', 1700, '2020-04-20'), ('GBP', 2000, '2020-05-10'), ('USD', 3500, '2020-05-25'), ('EUR', 1900, '2020-06-05'), ('GBP', 2100, '2020-06-10');

## My Thought Process

I joined the sales table with the exchange rate table on the matching date and currency, since the question specifically asks for sales converted into USD. After that, I filtered the data to only keep months 1 through 6 because we only need Q1 and Q2. Once the records were filtered, I calculated the quarter for each row and then grouped the results by quarter to get the final totals.

This type of problem shows up a lot in retail analytics. Anytime you’re dealing with multi‑currency transactions, you need to normalize values before you can compare or aggregate them. The workflow usually looks like: join → convert → assign time period → aggregate. It’s a common pattern when building KPI dashboards or quarterly business reviews.

## SQL Solution
```sql
WITH currency_exchnage AS(
    SELECT sa.sales_date,
           (CASE WHEN currency IN ('EUR','GBP') THEN sales_amount * exchange_rate 
            ELSE sales_amount
            END) AS amount,
            ((CAST(strftime('%m', sales_date) AS INT) - 1)/3)+ 1 AS quarter
      FROM sf_sales_amount sa
      JOIN sf_exchange_rate er
        ON sa.sales_date = er.date
       AND sa.currency = er.source_currency
       AND er.target_currency = 'USD'
     WHERE CAST(strftime('%m',sa.sales_date) AS INT) BETWEEN 1 AND 6
)
SELECT quarter, SUM(amount) AS sales_amount
  FROM currency_exchnage
 GROUP BY quarter;
