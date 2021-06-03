{{ config(
    materialized="table"
)}}

with customer as (
 select 
  id as customer_id,
  first_name,
  last_name
  from raw.jaffle_shop.customers

),
orders as (
 select  ID	as order_id,
USER_ID	as customer_id,
ORDER_DATE,
STATUS
 from RAW.JAFFLE_SHOP.orders 

),
customer_orders as (
 select customer_id,
  min(ORDER_DATE) as first_order_date,
  max(ORDER_DATE) as most_recent_order_date,
  avg(ORDER_id) as number_of_orders

 from orders 
  group by 1

),
final as (
 select 
  customer.customer_id,
  customer.first_name,
  customer.last_name,
  customer_orders.first_order_date,
  customer_orders.most_recent_order_date,
  coalesce(customer_orders.number_of_orders,0) as number_of_orders
 from customer
  left join customer_orders using(customer_id)

)
select * from final