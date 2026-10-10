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
--Explore all countries our customer come from 
select distinct 
country
from gold.dim_customers

-- Explore all categories (major divisions)
select distinct 
	category_id, product_subcategory, product_name
from gold.dim_products
