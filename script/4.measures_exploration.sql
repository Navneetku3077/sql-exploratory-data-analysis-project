/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
--Find the total sales
select 
sum(sales_amount) as total_sales
from gold.fact_sales;
--Find how many items are sold
select 
count(quantity) as total_quantity
from gold.fact_sales; 
--Find the average selling price 
select
avg(price) as avg_selling_price
from gold.fact_sales
--Find the total number of orders
select 
count(order_number) as total_orders
from gold.fact_sales
--Find the total number of customers
select 
count(customer_key) as number_of_customers
from gold.dim_customers
--Find the total nmber of customers that has placed an order
select
	count(distinct customer_key) as number_of_customers_with_orders
from gold.fact_sales

--Generate a report that shows all key metrics of the business
select
'Total sales' as measure_name,sum(sales_amount) as measure_value from gold.fact_sales
union all
select 
'Total quantity',sum(quantity)from gold.fact_sales
union all
select 'Average_price', avg(price) from gold.fact_sales
union all
select 'Total Nr. order' ,count(distinct order_number) from gold.fact_sales
union all
select 'total Nr. products' ,count(product_name) from gold.dim_products
union all 
select 'total Nr.customers' ,count(customer_key ) from gold.dim_customers
;

