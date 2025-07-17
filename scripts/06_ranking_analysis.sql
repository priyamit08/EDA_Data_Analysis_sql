Formula : RANK [DIMENSION] BY SUM[Measure]
TOP N | BOTTON N
Example:Top perforing Product  
Ranking countries by total sales
Bottom 3 customer by total sales ...etc

/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
  
SELECT
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5


-- Complex but Flexibly Ranking Using Window Functions

SELECT *
FROM (
		SELECT
			p.product_name,
			 SUM(f.sales_amount) AS total_revenue,
			RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rnk
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
		GROUP BY p.product_name) t
WHERE rnk <= 5

-- What are the 5 worst-performing products in terms of sales?
SELECT
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5

--Using window function
SELECT * 
FROM 
(
		SELECT p.product_name,
			SUM(f.sales_amount) AS total_revenue,
			RANK() OVER(ORDER BY SUM(f.sales_amount)) AS rnk
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
		GROUP BY p.product_name
)t
WHERE rnk <=5


-- Find the top 10 customers who have generated the highest revenue
SELECT c.customer_key,
c.first_name,c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY 1,2,3
ORDER BY total_revenue DESC
LIMIT 10


---Using window function
SELECT * 
FROM 
(
		SELECT c.customer_key,
		c.first_name,c.last_name,
		SUM(f.sales_amount) AS total_revenue,
		RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rnk
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customers c
		ON f.customer_key = c.customer_key
		GROUP BY 1,2,3
)t
WHERE rnk <= 10


-- The 3 customers with the fewest orders placed

SELECT c.customer_key,
		c.first_name,c.last_name,
		COUNT(DISTINCT f.order_number) AS Total_Order_placed
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
		c.first_name,c.last_name
ORDER BY Total_Order_placed
LIMIT 3

