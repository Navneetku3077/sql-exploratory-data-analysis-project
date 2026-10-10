/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
--Which 5 product generate the highest revenue?
select top 5
pr.product_name,
sum(fs.sales_amount) as total_revenue
from gold.fact_sales as fs
left join gold.dim_products as pr
on fs.product_key = pr.product_key
group by pr.product_name
order by total_revenue desc;

--What are the 5 worst-performing products in terms of sales?
select top 5
pr.product_name,
sum(fs.sales_amount) as total_revenue
from gold.fact_sales as fs
left join gold.dim_products as pr
on fs.product_key = pr.product_key
group by pr.product_name
order by total_revenue;

--FInd top 10 customers who have generated the highest revenue 
select top 10
c.customer_number,
c.first_name,
c.last_name,
sum(fs.sales_amount) as total_revenue
from gold.dim_customers as c
left join gold.fact_sales as fs
on c.customer_key = fs.customer_key
group by c.customer_number,
c.first_name,
c.last_name
order by total_revenue desc

