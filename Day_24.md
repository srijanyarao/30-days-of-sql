# Day 24 – SQL Practice

## Problem Statement
Find products which are exclusive to only Amazon and therefore not sold at Top Shop and Macy's. Your output should include the product name, brand name, price, and rating.

Two products are considered equal if they have the same product name and same maximum retail price (mrp column).

🔍By solving this, you'll learn how to use mutiple join. Give it a try and share the output! 👇


## My Thought Process
To find products that are exclusive to Amazon, I treated Amazon as the base table and checked whether each item also appeared in Macy’s or Topshop. Since two products are considered the same only when both the product_name and mrp match, I joined on those two fields.

A LEFT JOIN lets me keep all Amazon rows while pulling in matching rows from the other two retailers. If a product doesn’t exist in Macy’s or Topshop, the joined columns from those tables will be NULL. Filtering on those NULL values gives me the Amazon‑only items.

## SQL Solution
```sql
CREATE TABLE innerwear_amazon_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count INT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));

CREATE TABLE innerwear_macys_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count FLOAT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));

CREATE TABLE innerwear_topshop_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count FLOAT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));


INSERT INTO innerwear_amazon_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES ('ProductA', '100', '80', 'url1', 'BrandA', 'Category1', 'Amazon', 'DescriptionA', 4.5, 100, 'StyleA', 'M,L', 'M', 'Red'),('ProductB', '200', '180', 'url2', 'BrandB', 'Category1', 'Amazon', 'DescriptionB', 4.2, 150, 'StyleB', 'S,M,L', 'S', 'Blue'),('ProductC', '300', '250', 'url3', 'BrandC', 'Category2', 'Amazon', 'DescriptionC', 4.8, 200, 'StyleC', 'L,XL', 'L', 'Green');

INSERT INTO innerwear_macys_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES ('ProductA', '100', '85', 'url4', 'BrandA', 'Category1', 'Macys', 'DescriptionA', 4.5, 90, 'StyleA', 'M,L', 'M', 'Red'),('ProductD', '150', '130', 'url5', 'BrandD', 'Category3', 'Macys', 'DescriptionD', 4.0, 80, 'StyleD', 'S,M', 'S', 'Yellow'),('ProductE', '250', '210', 'url6', 'BrandE', 'Category4', 'Macys', 'DescriptionE', 3.9, 60, 'StyleE', 'M,L', 'L', 'Black');


INSERT INTO innerwear_topshop_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES ('ProductB', '200', '190', 'url7', 'BrandB', 'Category1', 'TopShop', 'DescriptionB', 4.1, 95, 'StyleB', 'S,M,L', 'M', 'Blue'),('ProductF', '100', '90', 'url8', 'BrandF', 'Category3', 'TopShop', 'DescriptionF', 3.5, 50, 'StyleF', 'XS,S', 'S', 'Pink'),('ProductG', '300', '270', 'url9', 'BrandG', 'Category5', 'TopShop', 'DescriptionG', 4.3, 70, 'StyleG', 'M,L,XL', 'M', 'Purple');

SELECT * FROM innerwear_amazon_com;

SELECT * FROM innerwear_macys_com;

SELECT * FROM innerwear_topshop_com;

SELECT a.product_name, a.brand_name, a.price,a.rating
  FROM innerwear_amazon_com AS a
  LEFT JOIN innerwear_macys_com AS M
    ON a.product_name = M.product_name AND a.mrp = M.mrp
  LEFT JOIN innerwear_topshop_com AS T
    ON a.product_name = T.product_name AND a.mrp = T.mrp
 WHERE T.product_name  IS NULL 
   AND M.product_name IS NULL;