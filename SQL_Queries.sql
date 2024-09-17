set search_path to 'cafe';

-- Select all columns and all rows from one table 
select * from cafe_store


-- Select five columns and all rows from one table 
select order_special_info, order_quantity, order_discount, 
order_prep_time, order_size from order_detail

-- Select all columns from all rows from one view
CREATE VIEW main_order_details AS 
SELECT order_special_info, order_quantity, order_discount, 
order_prep_time, order_size 
FROM order_detail;

SELECT * FROM main_order_details;


-- Using a join on 2 tables, select all columns and all rows
-- from the tables without the use of a Cartesian product 


SELECT *
FROM orders o
JOIN order_detail od ON o.order_id = od.fk_order_pk_order_id;


-- Select and order data retrieved from one table 

select * from orders
ORDER BY order_total DESC



-- Using a join on 3 tables, select 5 columns from the 3 tables.
-- Use syntax that would limit the output to 3 rows 

SELECT od.fk_order_pk_order_id, od.order_size, o.order_tax, o.date_and_time, pd.product_name
FROM order_detail od
JOIN orders o ON  od.fk_order_pk_order_id = o.order_id
JOIN product pd ON od.fk_product_pk_product_id = pd.product_id  
LIMIT 3


-- Select distinct rows using joins on 3 tables 
SELECT DISTINCT od.order_quantity, od.order_size, o.order_tax, o.date_and_time, pd.product_name
FROM order_detail od
JOIN orders o ON  od.fk_order_pk_order_id = o.order_id
JOIN product pd ON od.fk_product_pk_product_id = pd.product_id  

-- Use GROUP BY and HAVING in a select statement using one or more tables 

SELECT o.order_id, Avg(o.order_total), od.order_quantity
FROM orders o
JOIN order_detail od ON o.order_id = od.fk_order_pk_order_id
GROUP BY o.order_id, od.order_quantity
Having Avg(o.order_total) > 25

-- Use IN clause to select data from one or more tables 
SELECT *
FROM orders
WHERE order_id IN (1,4,7)

-- Select length of one column from one table

SELECT LENGTH(product_name) AS name_length
FROM product;

-- Delete one record from one table. Use select statements to
-- demonstrate the table contents before and after the DELETE statement.
-- Make sure you use ROLLBACK afterwards so that the data will not be physically removed 

BEGIN;

select * from order_detail;

DELETE FROM order_detail WHERE order_quantity = 2;

select * from order_detail;

ROLLBACK;

-- Update one record from one table. Use select statements to demonstrate the 
-- table contents before and after the UPDATE statement. Make sure you use 
-- ROLLBACK afterwards so that the data will not be physically removed 

BEGIN;

select * from orders;

UPDATE orders SET order_total = 10 WHERE order_id = 3;

select * from orders;

ROLLBACK;


-- Advance Query 1. Revenue Analysis by Store and Product Category
SELECT
    cs.store_id,
    cs.store_manager,
    p.product_category AS category,
    SUM(od.order_quantity * p.product_price) AS total_revenue
FROM
    cafe_store cs
JOIN
    orders o ON cs.store_id = o.FK_cafe_store_pk_store_id
JOIN
    order_detail od ON o.order_id = od.FK_order_pk_order_id
JOIN
    product p ON od.FK_product_pk_product_id = p.product_id
GROUP BY
    cs.store_id, cs.store_manager, p.product_category
ORDER BY
    cs.store_id, total_revenue DESC;
	

-- Advance Query 2.Store-wise Sales Composition by Product Category
WITH StoreSales AS (
    SELECT
        cs.store_id,
        cs.city,
        SUM(o.order_total) AS total_sales
    FROM
        orders o
    JOIN
        cafe_store cs ON o.FK_cafe_store_pk_store_id = cs.store_id
    GROUP BY
        cs.store_id, cs.city
),
CategorySales AS (
    SELECT
        cs.store_id,
        p.product_category,
        SUM(od.order_quantity * p.product_price) AS category_sales
    FROM
        order_detail od
    JOIN
        orders o ON od.FK_order_pk_order_id = o.order_id
    JOIN
        product p ON od.FK_product_pk_product_id = p.product_id
    JOIN
        cafe_store cs ON o.FK_cafe_store_pk_store_id = cs.store_id
    GROUP BY
        cs.store_id, p.product_category
)
SELECT
    ss.store_id,
    ss.city,
    cs.product_category,
    cs.category_sales,
    (cs.category_sales / ss.total_sales * 100) AS percentage_of_total_sales
FROM
    StoreSales ss
JOIN
    CategorySales cs ON ss.store_id = cs.store_id
ORDER BY
    ss.store_id, cs.category_sales DESC;



