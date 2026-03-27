# Day 29 – SQL Practice

## Problem Statement
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Cisco (Hard Level) hashtag#SQL Interview Question — Solution

Convert the first letter of each word found in content_text to uppercase, while keeping the rest of the letters lowercase. Your output should include the original text in one column and the modified text in another column.

🌀 Trust me, this one will seriously twist your brain! Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE user_content (content_id INT PRIMARY KEY,customer_id INT,content_type VARCHAR(50),content_text VARCHAR(255));

INSERT INTO user_content (content_id, customer_id, content_type, content_text) VALUES(1, 2, 'comment', 'hello world! this is a TEST.'),(2, 8, 'comment', 'what a great day'),(3, 4, 'comment', 'WELCOME to the event.'),(4, 2, 'comment', 'e-commerce is booming.'),(5, 6, 'comment', 'Python is fun!!'),(6, 6, 'review', '123 numbers in text.'),(7, 10, 'review', 'special chars: @#$$%^&*()'),(8, 4, 'comment', 'multiple CAPITALS here.'),(9, 6, 'review', 'sentence. and ANOTHER sentence!'),(10, 2, 'post', 'goodBYE!');

## My Thought Process
For this problem, I needed to convert each word in the text so that only the first letter is uppercase and the rest are lowercase. Since SQLite doesn’t have a built‑in string‑split function, I used a recursive CTE to break the text into individual words. The anchor step pulls out the first word and the remaining text, and the recursive step keeps peeling off the next word until nothing is left.

Once I had one word per row, I transformed each word by uppercasing the first character and lowercasing the rest. After that, I used GROUP_CONCAT to stitch the words back together in the original order. Finally, I joined the result back to the base table so I could show the original text next to the modified version.

## SQL Solution
```sql
WITH RECURSIVE split(content_id, word, rest) AS(
    SELECT content_id, substr(content_text,1,instr(content_text || ' ',' ')-1),
           substr(content_text,instr(content_text || ' ',' ')+1)
      FROM user_content

    UNION ALL

    SELECT content_id, substr(rest, 1, instr(rest || ' ', ' ') - 1), 
           substr(rest, instr(rest || ' ', ' ') + 1)
      FROM split
     WHERE rest <> ''
),
Transformed_words AS(
    SELECT content_id, UPPER(substr(word,1,1)) || LOWER(substr(word,2)) as word_transformed
      FROM split
),
modified_text AS(
    SELECT content_id, GROUP_CONCAT(word_transformed, ' ') as modified
      FROM Transformed_words
     GROUP BY content_id
)
SELECT u.content_id, u.content_text AS original_text, m.modified as modified_text
  FROM user_content u
  JOIN modified_text m
    ON u.content_id = m.content_id;