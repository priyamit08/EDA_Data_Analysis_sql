/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.

FORMULA: [MEASURE] BY [MEASURE]
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/


WITH product_cost_range AS (
SELECT product_key,
product_name,
product_cost,
CASE WHEN product_cost < 100 THEN 'Below 100'
	 WHEN product_cost BETWEEN 100 AND 500 THEN '100 -500'
	 WHEN product_cost BETWEEN 500 AND 1000 THEN '500 -1000'
	 ELSE 'Above 100'
	 END cost_range	 
FROM gold.dim_products
)
SELECT COUNT(product_key) AS total_products , cost_range	 
FROM product_cost_range
GROUP BY  cost_range
ORDER BY total_products




/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/


WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


---psql
WITH customer_spending AS (
SELECT 
  c.customer_key,
  MIN(f.order_date) AS min_date,
  MAX(f.order_date) AS max_date,
  (DATE_PART('year', AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
   DATE_PART('month', AGE(MAX(f.order_date), MIN(f.order_date)))) AS lifespan,
  SUM(f.sales_amount) AS total_spending
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
--Subquery
SELECT 
		customer_segment,
		COUNT(customer_key) AS total_customer
FROM 
(
SELECT 
			customer_key,
			total_spending,
			lifespan,
			CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
			 END AS customer_segment
FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customer
