Analyze how a measure evolve over time
Help to track trnds and identify the seasonality in your data
Formula : [Measure] by [Date Dimension]
for example total sale by year
Avg cost by month
Dates and Measure information is mostly consist in the table FACT 
/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
---SQL Server
  SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


---Postgresql
SELECT 	EXTRACT (YEAR FROM order_date) AS year,
		SUM(sales_amount) AS total_sales,
		COUNT( DISTINCT customer_key) AS total_customer,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT (YEAR FROM order_date)
ORDER BY EXTRACT (YEAR FROM order_date)


--Month Wise Information
SELECT 	
	EXTRACT (YEAR FROM order_date) AS year,
	EXTRACT (MONTH FROM order_date) AS month,
		SUM(sales_amount) AS total_sales,
		COUNT( DISTINCT customer_key) AS total_customer,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT (YEAR FROM order_date),EXTRACT (MONTH FROM order_date)
ORDER BY 1,EXTRACT (MONTH FROM order_date)


  
-- DATETRUNC()

-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);


---postgresql

SELECT 	
	TO_CHAR(order_date, 'YYYY-MM') AS month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customer,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY TO_CHAR(order_date, 'YYYY-MM');

-- FORMAT()
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');


--PSQL
SELECT 	
	TO_CHAR(order_date, 'YYYY-Mon') AS date,
		SUM(sales_amount) AS total_sales,
		COUNT( DISTINCT customer_key) AS total_customer,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY TO_CHAR(order_date, 'YYYY-Mon')
