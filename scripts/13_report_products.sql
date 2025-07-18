/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================


/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend */

CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_customer
---------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.sales_amount,
	f.order_date,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ' , c.last_name) AS customer_name,
	DATE_PART('year', AGE(CURRENT_DATE, c.birthdate)) AS age_in_years
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL


), customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT customer_key,
	   customer_number,
	   customer_name,
	   age_in_years,
	   COUNT(DISTINCT order_number) AS total_order,
	   SUM(sales_amount) AS total_sales,
	   SUM(quantity) AS total_qunatity,
	   COUNT(DISTINCT product_key) AS total_products,
  	    MAX(order_date) AS last_order_date,
  	   (DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
   		DATE_PART('month', AGE(MAX(order_date), MIN(order_date)))) AS lifespan	
FROM base_query
GROUP BY customer_key,
	   customer_number,
	   customer_name,
	   age_in_years
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all customer results into one output
---------------------------------------------------------------------------*/

SELECT customer_key,
	   customer_number,
	   customer_name,
	   age_in_years,
	   CASE WHEN age_in_years < 20 THEN ' Under 20'
	        WHEN age_in_years BETWEEN 20 AND 29 THEN '20 - 29'
			WHEN age_in_years BETWEEN 30 AND 39 THEN '30 - 39'
            WHEN age_in_years BETWEEN 40 AND 49 THEN '40 - 49'
	   ELSE '50 And Above'
	   END age_groups,
	   CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			 ELSE 'New'
			 END AS customer_segment,
			  last_order_date,
			  --DATEDIFF('month', last_order_date,GETDATE())
			  (DATE_PART('year', AGE(current_date, last_order_date)) * 12 +
   			DATE_PART('month', AGE(current_date, last_order_date))) AS recency,
	   total_order,
	   total_sales,
	   total_qunatity,
	   lifespan,
	   --Compute Average order value (AVO)
	   --If total_order is 0
	   CASE WHEN total_order = 0 THEN 0
	   ELSE total_sales/total_order 
	   END AS avg_order_value,
	 ---Compute Avergae monthly spent (Totals sales / Nr of Month)
	 
	   ROUND (CASE WHEN lifespan = 0 THEN total_sales
	   ELSE total_sales/lifespan 
	   END) AS avg_monthly_spent
FROM customer_aggregation




After creating view can create a dashboard directly 
