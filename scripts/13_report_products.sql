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


IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL  -- only consider valid sales dates
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations 


After creating view can create a dashboard directly 






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
WITH base_query AS (
SELECT
	p.product_key,
	p.product_name,
	p.categories,
	p.sub_categories,
	p.product_cost,
	f.customer_key,
	f.order_number,
	f.sales_amount,
	f.quantity,
	f.order_date
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key =p.product_key
WHERE order_date IS NOT NULL
),
product_aggregation AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT  product_key,
		product_name,
		categories,
		sub_categories,
		product_cost,
		MAX(order_date) AS last_order_date,
		COUNT(DISTINCT order_number) AS total_order,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity_sold,
		COUNT(DISTINCT customer_key) AS total_customer,
		(DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
   		DATE_PART('month', AGE(MAX(order_date), MIN(order_date)))) AS lifespan,
		 ROUND(AVG(sales_amount/NULLIF(quantity ,0)),1) AS avg_selling_price
FROM base_query
GROUP BY product_key,
		product_name,
		categories,
		sub_categories,
		product_cost
)

SELECT 
		product_key,
		product_name,
		categories,
		sub_categories,
		product_cost,
		last_order_date,
		(DATE_PART('year', AGE(current_date, last_order_date)) * 12 + DATE_PART('month', AGE(current_date, last_order_date))) AS recency,
		CASE 
			 WHEN total_sales > 50000 THEN 'High-Performer'
			 WHEN total_sales >=10000 THEN 'Mid-Range'
			 ELSE 'Low-Performer'
	     END AS product_segment,
		total_order,
		--Avg order Revenue (total sales/total order)
		CASE 
			WHEN total_order = 0 THEN 0
			ELSE total_sales/total_order 
		END AS Avg_order_revenue,
		-- Average Monthly Revenue
		CASE 
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales/lifespan
		END AS avg_monthlu_revenue,
		total_sales,
		total_quantity_sold,
		total_customer,
		lifespan,
		avg_selling_price
FROM product_aggregation


