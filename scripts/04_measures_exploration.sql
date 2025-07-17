----Measure Exploration: Measure is the column where you can measure the data first it should be number and can be aggregated
----Calculate the key metric of the business
---Highest level of Aggregation | Lowest level of details

DROP VIEW gold.fact_sales

CREATE VIEW gold.fact_sales AS
 SELECT    sls_ord_num AS order_number,
		pr.product_key, ---Replaced
		cd.customer_key, ---Replaced to connect fact with dimension
		    sls_order_dt AS order_date,
		    sls_ship_dt AS shipping_date,
		    sls_due_dt AS due_date,
		    sls_sales AS sales_amount,
		    sls_quantity AS price,
		    sls_price AS quantity
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cd
ON sd.sls_cust_id = cd.customer_id

---Find the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS item_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT ROUND(AVG(price)) AS avg_selling_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_no_order FROM gold.fact_sales
---There are possible where a customer has order more than 1 item in a single order so distinct will give unique records
SELECT COUNT(DISTINCT order_number) AS total_no_order FROM gold.fact_sales
SELECT * FROM gold.fact_sales WHERE order_number = 'SO54496'
--Note for COUNT alway check before and after DISTINCT count


-- Find the total number of products
SELECT COUNT(product_key) AS total_no_product FROM gold.dim_products
SELECT COUNT(DISTINCT product_key) AS total_no_product FROM gold.dim_products
SELECT COUNT(product_name) AS total_no_product FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_no_customer FROM gold.dim_customers
SELECT COUNT(DISTINCT customer_key) AS total_no_customer FROM gold.dim_customers


-- Find the total number of customers that has placed an order
SELECT COUNT(customer_key) AS total_no_customer FROM gold.fact_sales



-- Generate a Report that shows all key metrics of the business
SELECT 'Total_Sales' AS measure_name,  SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Item_Quantity' AS measure_value, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average_Selling_Price' AS measure_name,ROUND(AVG(price)) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_no_Order' AS measure_value, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_No_Product' AS measure_value,COUNT(product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total_No_Customer' AS measure_name ,COUNT(DISTINCT customer_key) AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total_Customer_Placed_Order' AS measure_name ,COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales





