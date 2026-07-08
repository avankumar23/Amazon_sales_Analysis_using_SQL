 -----MS SQL Server 

IF OBJECT_ID('shippings', 'U') IS NOT NULL
    DROP TABLE shippings;
GO

CREATE TABLE shippings (
							id int primary key,
							provider_name VARCHAR(25),
							email_id VARCHAR(25)
						);
GO

SELECT * FROM shipping;

INSERT INTO shippings(email_id)
VALUES
(101, 'dhl')
;	-- NOTE: 2 values supplied for 1 column, same mismatch as in original script - fix column list if this was unintentional




INSERT INTO shippings (id)
VALUES
(102),
(103)
;

UPDATE shippings
SET provider_name = 'Bluedart', email_id = '123@gmail.com'
-- WHERE id = 102;



UPDATE shippings
SET email_id = NULL
WHERE id = 102;



-- DELETE 

DELETE FROM shippings
WHERE id = 103


SELECT * FROM shippings
WHERE id = 103


ALTER TABLE shippings
DROP COLUMN email_id;

ALTER TABLE shippings
ADD email_id varchar(15);


DELETE FROM shippings;


DROP TABLE shippings;


-- RENAME table name
EXEC sp_rename 'shippings', 'shipping';


EXEC sp_rename 'shipping.email_id', 'emails', 'COLUMN';


SELECT * FROM shipping
-- 

-- UPDATE datatypes of an existing column

ALTER TABLE shipping
ALTER COLUMN emails VARCHAR(15);

-- ------------------------------
-- Subquery 
-- -----------------------------


/*

Q.1 Find Top 5 states by total orders where each state sale is greater than average orders across orders.

Q.2 Find the details of the top 5 products with the highest total sales, where the total sale for each product is greater than the average sale across all products.

*/

-- product_id, sum(sales) group by product_id
-- order by sum of sales and limit 5
-- each pro sale ---- product_id, sum(sales) group by product_id
-- sum(sale) / count(product_id)
-- average sale across all products.


-- ;WITH CTE2	
-- AS
-- 	(	
-- 	SELECT * FROM sellers
-- 	-- WHERE seller_id = '1'
-- 	)
	
-- SELECT COUNT(*) FROM CTE2

SELECT TOP 5
		product_id,
		SUM(sale) as total_sale_by_p
FROM orders
GROUP BY product_id
HAVING SUM(sale) > (SELECT 
					AVG(total_sale_by_p) as avg_sale -- 1241.82
				FROM 
					(
					SELECT TOP 100 PERCENT
						product_id,
						SUM(sale) as total_sale_by_p
					FROM orders
					GROUP BY product_id
					ORDER BY 2 DESC
					) as avg_sale_table)		
ORDER BY 2 DESC


SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)


	
SELECT AVG(salary) FROM employees; -- 69000
	
CREATE TABLE employees (id INT, salary int);

INSERT INTO employees 
VALUES
(1, 55000),
(2, 95000),
(3, 65000),
(4, 85000),	
(5, 45000)




	
	
SELECT 
	ROUND(CAST(AVG(total_sale_by_p) AS NUMERIC), 2) as avg_sale -- 1241.82
FROM 
	(
	SELECT TOP 100 PERCENT
		product_id,
		SUM(sale) as total_sale_by_p
	FROM orders
	GROUP BY product_id
	ORDER BY 2 DESC
	) as avg_sale_table
;




-- BREAK TILL 12:30 PM IST






	

-- ;WITH CTE1
-- AS	
-- (
-- SELECT 
-- 	product_id,
-- 	SUM(sale) as total_sale_by_p
-- FROM orders
-- GROUP BY product_id
-- ORDER BY 2 DESC
-- )
-- SELECT AVG(total_sale_by_p) as avg_sale FROM CTE1



-- Q.3 Identify the top 3 seller based on total sale return seller_name, seller_id, total_sale

SELECT * FROM sellers
SELECT * FROM orders

-- seller_id, seller_name, sum(total sale), order by desc sale, limit 3

SELECT TOP 3
	o.seller_id,
	s.seller_name,
	SUM(o.sale) as total_sales
FROM orders as o
JOIN sellers as s
ON o.seller_id = s.seller_id	
GROUP BY o.seller_id, s.seller_name
ORDER BY total_sales DESC


SELECT CONCAT('Sam', ' ', 'Altman');

SELECT * FROM customers
WHERE customer_id = 'C10001';

ALTER TABLE customers
ADD last_name VARCHAR(25);

INSERT INTO customers(customer_id, customer_name, last_name)
VALUES
('C10001',  'sam', 'altman'),
('C10002', 'Najir', 'HSN'),
('CS 10003', 'Rahul', 'Sharma')

SELECT 
	CONCAT(customer_name, ' ', last_name)
FROM customers
WHERE customer_id = 'C10002';


SELECT 
	TRIM( '     Hello Welcome to SQL W2     ');


SELECT	
	ROUND(1250.887765562344, 3) as total_sale

SELECT 
	ABS(250) as loss

SELECT 
	SUM(-5 +2 + 5) as qty
	 from orders;


-- 

SELECT RAND();

-- Handling Null values


SELECT COUNT(*) FROM shipping
WHERE provider_name IS NULL; 

SELECT COUNT(*) FROM shipping
WHERE provider_name IS NULL OR emails IS NULL

	
SELECT * FROM orders
	
SELECT COUNT(*) FROM orders
WHERE order_id IS NOT NULL 


/*

-- Q.4 Categorize products by price range: 
Classify products as "Low," "Medium," or "High" based on their price.

price > 1000 'High Price'	
price between 68 and 1000 'Medium Price'	
price > 68 'Low Price'
	
*/

SELECT *,
	CASE
		WHEN price > 1000 THEN 'High Price Product'
		WHEN price BETWEEN 68 AND 1000 THEN 'Medium Price Product'
		ELSE 'Low Price Product'
	END as product_category
FROM products;



SELECT *,
	CASE
		WHEN price > 1000 THEN 'High Price Product'
		WHEN price BETWEEN (SELECT AVG(price) FROM products) AND 1000 THEN 'Medium Price Product'
		ELSE 'Low Price Product'
	END as product_category
FROM products;




-- Q.6

-- Identify returning customers: Label customers as "Returning" if they have placed more than one return; otherwise, mark them as "New."


SELECT * FROM orders;

SELECT * FROM returns;

SELECT * FROM customers;

-- if return > 1 then 'returning' else new_cs
-- how many orders cx has placed 
-- how many orders cx has returned join return table 
-- cx join with cx table 


SELECT 
    o.customer_id,
    c.customer_name,
    -- COUNT(o.order_id) as total_orders,
    COUNT(r.return_id) as total_return,
    CASE
        WHEN COUNT(r.return_id) > 1 THEN 'returning_cs'
        ELSE 'new_cs'
    END   
FROM orders as o
LEFT JOIN  
returns as r
ON o.order_id = r.order_id  
JOIN customers as c 
ON o.customer_id = c.customer_id    
GROUP BY o.customer_id, c.customer_name
;




SELECT 
    o.order_id,
    o.customer_id,
    r.return_id
FROM orders as o
LEFT JOIN  
returns as r
ON o.order_id = r.order_id    
-- GROUP BY o.customer_id;






    
-- WHERE r.return_id IS NOT NULL	
	



SELECT
	o.order_id as orderid,
	COUNT(*)
	-- CASE 
	-- 	WHEN r.return_id IS NOT NULL 
FROM orders as o
LEFT JOIN returns as r	
ON o.order_id = r.order_id
WHERE r.return_id IS NOT NULL	
	



	

-- avg 68
-- max 3700
-- 0.36

SELECT AVG(price) FROM products;  


--  Q.8 Ranking Top 5 Products by Sales: 

SELECT * 
FROM
(	
	SELECT 
		product_id,
		SUM(sale) as total_sale,
		RANK() OVER( ORDER BY SUM(sale) DESC) as rn
	FROM orders
	GROUP BY product_id
) as subquery
WHERE rn <= 5



