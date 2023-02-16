use sakila;

-- Get number of monthly active customers
create or replace view sakila.monthly_active_customers as
select activity_year, activity_month, count(distinct customer_id) as active_customers
from sakila.customer_activity
group by activity_year, activity_month;

select * from monthly_active_customers;

-- Active users in the previous month
select  activity_month, active_customers, 
   lag(active_customers) over (order by activity_Month) as last_month
from sakila.monthly_active_customers;

-- Percentage change in the number of active customers
create or replace view sakila.diff_monthly_active_customers as
with cte_view as 
(
	select 
	activity_year, 
	activity_month,
	active_customers, 
	lag(active_customers) over (order by activity_year, activity_month) as last_month
	from sakila.monthly_active_customers
)
select 
   activity_year, 
   activity_month, 
   active_customers, 
   last_month, 
   (active_customers - last_month) / last_month * 100 as Difference_percentage 
from cte_view;

select * from sakila.diff_monthly_active_customers;

-- Retained customers every month
create or replace view sakila.distinct_customers as
select
	distinct 
	customer_id as active_id, 
	activity_year, 
	activity_month
from sakila.customer_activity
order by activity_year, activity_month, customer_id;

select * from sakila.distinct_customers;

create or replace view sakila.total_retained_customers as
select activity_year, activity_month, count(active_id) as retained_customers from retained_customers
group by activity_year, activity_month;

select * from sakila.total_retained_customers;