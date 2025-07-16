/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;







--Identify the ealiest and latest date (boundaries)
--understand the scope of data and the timespam
--Most dates infor is stored in fact table

--Find teh date of first and last order
--How many years of sale are available

SELECT 
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date,
  DATE_PART('year', MAX(order_date)) - DATE_PART('year', MIN(order_date)) AS year_diff
  --DATEDIFF(year,MIN(order_date),MAX(order_date))
FROM gold.fact_sales;


--Calculate how many Month


SELECT 
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date,
  (DATE_PART('year', MAX(order_date)) - DATE_PART('year', MIN(order_date))) * 12 +
  (DATE_PART('month', MAX(order_date)) - DATE_PART('month', MIN(order_date))) AS month_diff
FROM gold.fact_sales;


---Find the Oldest and Younest
---sql server
SELECT 
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(year,MIN(birthdate),GETDATE()) AS old_age,
	MAX(birthdate) AS youngest_birthdate
FROM gold.dim_customers

--postgresql
SELECT 
  MIN(birthdate) AS oldest_birthdate,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate))) AS old_age,
  MAX(birthdate) AS youngest_birthdate,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE,MAX(birthdate))) AS young_age
FROM gold.dim_customers;

