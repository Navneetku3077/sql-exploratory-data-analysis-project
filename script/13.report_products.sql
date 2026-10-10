/*
===========================================================
Product report
==============================================================
Purpose:
-This report consolidates key product metrics and behaviors.
Highlights:
1.Gather essential fields such as product name, category ,subcategory and cost.
2.Aggregate product-level metrics:
	-total orders
	-total sales
	-total quantity sold
	-total customers (unique)
	-lifespan (in months)
3.Segments product by revenue to identify high_performance , mid_performance , low performance.
4.caclulate valuable KPIs:
-recency (month since last sales)
-average order revenue 
-average monthly revenue
=================================================================
*/
create view gold.report_product as 
with cte_base_query as (
select
	p.product_key,
	p.product_name,
	p.category_id as category,
	p.subcategory as subcategory,
	p.cost,
	f.order_number,
	f.customer_key,
	f.order_date,
	f.sales_amount,
	f.quantity
from gold.dim_products as p
left join gold.fact_sales as f
	on p.product_key = f.product_key
where order_date is not null
)
/*---------------------------------------------------------
2.product aggregation: summarize key metrics at the product level
------------------------------------------------------------*/
,cte_product_aggregation as (
select 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	max(order_date) as last_sales_date,
	datediff( month ,min(order_date) ,max(order_date)) as lifespan,
	round (avg(cast (sales_amount as float)/ nullif (quantity,0)),1) as avg_selling_price
	from cte_base_query
	group by 
	product_key,
	product_name,
	category,
	subcategory,
	cost
	)
	/*-------------------------------------------------------------------------
	3.Final Query : Combines all product result into one output
	---------------------------------------------------------------------------*/
	select 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sales_date,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	datediff(month,last_sales_date,getdate()) as recency_in_months,
	case when total_sales >50000 then 'High_performance'
	when total_sales >= 10000 then 'Mid_range'
	else 'low_performer'
	end as product_segment,
	--avg_order_revenue
	case when total_orders = 0 then 0
	else total_sales/total_orders 
	end as avg_order_revenue,
	--avg monthly revenue
	case when lifespan =0 then total_sales
	else total_sales/lifespan
	end as avg_monthly_revenue
	from cte_product_aggregation 

	select * 
	 from gold.report_product
