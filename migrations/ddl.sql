alter table staging.user_order_log add column if not exists status varchar(100);
-- drop table mart.f_customer_retention;
create table if not exists mart.f_customer_retention (
	period_name text,
	period_id int4,
	item_id int4,
	new_customers_count int8,
	returning_customers_count int8,
	refunded_customer_count int8,
	new_customers_revenue numeric,
	returning_customers_revenue numeric,
	customers_refunded numeric
);