/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
Aggregate the data progressively over time
Help to understand whether business is growing / declining over time
Formula: [Cumulative measure] BY [DATE DIMENSION]
EXAMPLE:Moving AVG sale by month

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
--Default window frame ('BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW')
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t






-----PSQL
SELECT year_month,
	   total_sales,
       SUM(total_sales) OVER(ORDER BY year_month) AS running_total_sales
FROM (
		SELECT 
			TO_CHAR(order_date, 'YYYY-MM') AS year_month,
			SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY TO_CHAR(order_date, 'YYYY-MM')
		ORDER BY TO_CHAR(order_date, 'YYYY-MM')
)t


---TO LIMIT CUMULATIVE SALE PER month and year


SELECT year_month,
	   total_sales,
       SUM(total_sales) OVER(PARTITION BY year_month ORDER BY year_month) AS running_total_sales
FROM (
		SELECT 
			TO_CHAR(order_date, 'YYYY-MM') AS year_month,
			SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY TO_CHAR(order_date, 'YYYY-MM')
		ORDER BY TO_CHAR(order_date, 'YYYY-MM')
)t



---Year wise SELECT years,
	   total_sales,
       SUM(total_sales) OVER(PARTITION BY years ORDER BY years) AS running_total_sales
FROM (
		SELECT 
			EXTRACT(YEAR FROM order_date) AS years,
			SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY EXTRACT(YEAR FROM order_date)
		ORDER BY EXTRACT(YEAR FROM order_date)
)t


---Moving Average		



SELECT years,
	   total_sales,
       SUM(total_sales) OVER(ORDER BY years) AS running_total_sales,
	   AVG(avg_price) OVER(ORDER BY years) AS moving_avg
FROM (
		SELECT 
			EXTRACT(YEAR FROM order_date) AS years,
			SUM(sales_amount) AS total_sales,
			AVG(price) AS avg_price
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY EXTRACT(YEAR FROM order_date)
		ORDER BY EXTRACT(YEAR FROM order_date)
)t
