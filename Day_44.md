# Day 44 – SQL Practice

## Problem Statement

𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon (Hard Level) hashtag#SQL Interview Question — Solution

You are given the table with titles of recipes from a cookbook and their page numbers. You are asked to represent how the recipes will be distributed in the book.

Produce a table consisting of three columns: left_page_number, left_title and right_title. The k-th row (counting from 0), should contain the number and the title of the page with the number 2×k in the first and second columns respectively, and the title of the page with the number 2×k+1 in the third column.

Each page contains at most 1 recipe. If the page does not contain a recipe, the appropriate cell should remain empty (NULL value). Page 0 (the internal side of the front cover) is guaranteed to be empty.

🌀 Trust me, this one will surely challenge you...! You'll learn self join, subquery. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭
CREATE TABLE cookbook_titles (page_number INT PRIMARY KEY,title VARCHAR(255));

INSERT INTO cookbook_titles (page_number, title) VALUES (1, 'Scrambled eggs'), (2, 'Fondue'), (3, 'Sandwich'), (4, 'Tomato soup'), (6, 'Liver'), (11, 'Fried duck'), (12, 'Boiled duck'), (15, 'Baked chicken');
## My Thought Process

This question feels like building a simple layout engine. The left pages follow an even‑number pattern (0, 2, 4, …), and the right pages are always the next number.

To get that structure, I first generated all even page numbers using a recursive CTE. That gives me the full spine of the book, including empty pages. From there, I joined the spine back to the original table twice—once for the left page title and once for the right page title.

This approach keeps the layout consistent even when pages are missing in the source data.

###  What Type of Problem This Is (Retail Analytics Context)

This fits into a broader category of data‑shaping problems—the kind you run into when you need to align sparse data to a fixed structure. In retail analytics, this shows up when mapping:

product slots on a shelf

catalog pages

display positions

layout‑based reporting

The pattern is the same: build the structure first, then attach the data to it. It keeps the output predictable even when the source data has gaps. 

## SQL Solution
```sql
WITH RECURSIVE cte_even_pages(left_page_number) AS (
    SELECT 0
    UNION ALL
    SELECT left_page_number + 2
    FROM cte_even_pages
    WHERE left_page_number + 2 <= (SELECT MAX(page_number) FROM cookbook_titles)
)
SELECT 
    sp.left_page_number,
    lt.title AS left_title,
    rt.title AS right_title
FROM cte_even_pages sp
LEFT JOIN cookbook_titles lt
    ON sp.left_page_number = lt.page_number
LEFT JOIN cookbook_titles rt
    ON sp.left_page_number + 1 = rt.page_number
ORDER BY sp.left_page_number;
