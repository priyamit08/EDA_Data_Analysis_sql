/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.

Formula 
([MEASURE]/[TOTAL MEASURE]) * 100 BY dimension
sales/total sales *100 by category
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH category_sales AS (
SELECT
	categories,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY categories
)
SELECT categories , total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100,2) ,'%') AS percent_of_total
FROM category_sales
ORDER BY total_sales DESC

OUTPUT:
  
"Bikes"	28316272	29356250	"96.46%"
"Accessories"	700262	29356250	"2.39%"
"Clothing"	339716	29356250	"1.16%"
