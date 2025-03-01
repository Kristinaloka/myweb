
with customers as (

     select * from  {{ref ('stg_jaffle_shops__customers')}}

),

orders as ( 

    select * from {{ ref ('stg_jaffle_shops__orders')}}

),

customer_orders as (

    select
        USER_ID,

        min(ORDER_DATE) as first_order_date,
        max(ORDER_DATE) as most_recent_order_date,
        count(ID) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.ID,
        customers.FIRST_NAME,
        customers.LAST_NAME,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) 
        as number_of_orders

    from customers

    left join customer_orders ON customer_orders.USER_ID = customers.ID

)

select * from final