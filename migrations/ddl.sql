alter table staging.user_order_log add column if not exists status varchar(20);
-- drop table mart.f_customer_retention;
create table if not exists mart.f_customer_retention (
	period_name varchar(40),
	period_id int4 not null,
	item_id int4 not null,
	new_customers_count int8,
	returning_customers_count int8,
	refunded_customer_count int8,
	new_customers_revenue numeric,
	returning_customers_revenue numeric,
	customers_refunded numeric,
    constraint d_item_pkey primary key (period_id, item_id)
);