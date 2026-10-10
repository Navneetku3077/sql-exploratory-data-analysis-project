/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
with cte_product_segments as (
select 
product_key,
product_name,
cost,
		case when cost < 100 then 'Below 100'
			when cost between 100 and 500 then '100-500'
when cost between 500 and 1000 then '500-1000'
else 'above 1000'
end as cost_range
from gold.dim_products
)
select 
cost_range,
count(product_key) as total_products
from cte_product_segments
group by cost_range
order by total_products desc
;

/* Group customers into three segments based on their spending behavior:
- VIP : Customers with at least 12 month of history and spending more than $5000.
- Regular : customers with at least 12 month of history but spending $5000 or less.
- New :Customer with a lifespan less than 12 months.
And find the total number of customer by each group  */
with cte_customer_spending as (		--CTE used
select
c.customer_key,
sum(fs.sales_amount) as total_spending,
min (order_date) as first_order,
max(order_date) as last_order,
datediff(month,min (order_date),max(order_date)) as lifespan
from gold.fact_sales as fs
left join gold.dim_customers as c
on fs.customer_key = c.customer_key
group by c.customer_key
)

select 
customer_segment,
count(customer_key) as total_customer
from (			-- subquery used
	select			
	customer_key,
	total_spending,
	lifespan,
	Case when lifespan>= 12 and total_spending >5000 then 'VIP'
	when lifespan >= 12 and total_spending<= 5000 then 'Regular'
	else 'New Customer'
	end as customer_segment
	from cte_customer_spending) t
group by customer_segment
order  by total_customer desc

