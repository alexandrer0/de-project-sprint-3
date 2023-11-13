delete from mart.f_customer_retention
    where period_id = (select dc.week_of_year from mart.d_calendar as dc where dc.date_actual = '{{ds}}');
insert into mart.f_customer_retention (
    period_name,
    period_id,
    item_id,
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
)
with a as (
select
	'weekly' as period_name,
	week_of_year as period_id,
	item_id,
	customer_id,
	count(case when coalesce(status, 'shipped') = 'shipped' then 1 end) as cnt_ord,
	count(case when status = 'refunded' then 1 end) as cnt_ref,
	sum(payment_amount) as amt
from staging.user_order_log uol
left join mart.d_calendar as dc on uol.date_time::Date = dc.date_actual
where uol.date_time::Date between date_trunc('week', '{{ds}}') and '{{ds}}'
group by 1,2,3,4
)
select
	period_name,
	period_id,
	item_id,
	count(distinct case when cnt_ord = 1 then customer_id end) as new_customers_count,
	count(distinct case when cnt_ord > 1 then customer_id end) as returning_customers_count,
	count(distinct case when cnt_ref > 0 then customer_id end) as refunded_customer_count,
	sum(case when cnt_ord = 1 then amt else 0 end) as new_customers_revenue,
	sum(case when cnt_ord > 1 then amt else 0 end) as returning_customers_revenue,
	sum(cnt_ref) as customers_refunded
from a
group by 1,2,3