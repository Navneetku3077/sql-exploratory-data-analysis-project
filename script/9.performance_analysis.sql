/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

/* Analyze the yearly performance of product by comparing each products
sales to both its average sales performance and the previous year's sales.*/
with cte_yearly_product_sales as (
select
year(fs.order_date) as order_year,
p.product_name,
sum(fs.sales_amount) as current_sales
from gold.fact_sales as fs
left join gold.dim_products as p
on fs.product_key = p.product_key
where order_date is not null
group by year(fs.order_date),p.product_name
)

select 
	order_year,
	product_name,
	current_sales,
	avg(current_sales) over (partition by product_name) as avg_sales,
	current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
	case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Avg'
		 when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Avg'
		 else 'AVG'
	end as avg_change,
  
	-- Year-over-year Analysis
	lag(current_sales) over (partition by product_name order by order_year) as py_sales,
	current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
	case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
		 when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
		 else 'No change'
	end as py_change
from cte_yearly_product_sales
order by product_name, order_year;

