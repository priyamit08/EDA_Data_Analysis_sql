
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products

SELECT DISTINCT categories FROM gold.dim_products;

SELECT DISTINCT categories, sub_categories FROM gold.dim_products ORDER BY categories;

  
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

---OR

SELECT DISTINCT categories, sub_categories, product_name FROM gold.dim_products ORDER BY 1,2,3

