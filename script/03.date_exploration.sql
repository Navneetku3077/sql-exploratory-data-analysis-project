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

-- Find the date of the first and last order
select 
min(order_date) as first_date,
max(order_date) as last_date,
datediff(year,min(order_date),max(order_date)) as order_range
from gold.fact_sales

-- Find the youngest and oldest customer
-- Find the youngest and oldest customer
select 
	min(date_of_birth) as oldest_birthdate,
	datediff(year, min(date_of_birth), getdate()) as oldest_age,
	datediff(year, max(date_of_birth), getdate()) as youngest_age,
	max(date_of_birth) as youngest_birthdate
from gold.dim_customers;
