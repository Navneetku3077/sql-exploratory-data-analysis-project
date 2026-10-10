/*
==========================================================================
Customer Report
==========================================================================
Purpose:
-This report consolidates key customer metrics and behaviors

Highlights:
1.Gathers essential fields such as names,ages and transaction details.
2.Segments customer into categories (VIP ,Regular, New ) and age groups.
3. Aggregate customer-level matrics:
	-total orders
	-total sales
	-total quantity purchased
	-total products
	-lifespan (in months)
4.Calculate valuable KPIs:
	-recently (month since last order)
	-average order value
	-average monthly spend
=============================================================================
*/
create view gold.report_customer as 
/*---------------------------------------------------------------------------
1. Base query: Retrives core columns from tables
------------------------------------------------------------------------------*/
with cte_base_query as (		--1st Cte
select
fs.order_number,
fs.product_key,
fs.order_date,
fs.sales_amount,
fs.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name, ' ' ,c.last_name) as customer_name,
	datediff(year,c.date_of_birth, getdate()) as age
from gold.fact_sales fs
left join gold.dim_customers as c
on fs.customer_key = c.customer_key
where order_date is not null
)
/*------------------------------------------------------------------------------
2. Customer aggregation : Summarize the customer details 
--------------------------------------------------------------------------------*/
, cte_customer_aggregation as (			-- 2nd Cte
select
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as last_order_date,
datediff(month, Min(order_date), max(order_date)) as lifespan
from cte_base_query
group by customer_key,
	customer_number,
	customer_name,
	age
)
select
customer_key,
customer_number,
customer_name,
age,
case when age>20 then 'Under 20'
when age between 20 and 29 then '20-29'
when age between 29 and 39 then '29-39'
when age between 29 and 49 then '29-39'
else '50 and above'
end as age_group,
lifespan,
Case when lifespan>= 12 and total_sales >5000 then 'VIP'
	when lifespan >= 12 and total_sales<= 5000 then 'Regular'
	else 'New Customer'
end  as customer_segment,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
datediff(month,last_order_date, getdate()) as recency,
--compute average order value
total_sales / total_orders as Avg_order_value,
--compute average monthly spends
case when lifespan= 0 then total_sales
else total_sales / lifespan
end as avg_monthly_span
from cte_customer_aggregation

GO
select * from gold.report_customer

