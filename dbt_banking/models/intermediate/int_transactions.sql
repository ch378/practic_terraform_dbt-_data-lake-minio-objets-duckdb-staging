with transactions as (

    select *
    from {{ ref('stg_transactions') }}

),

business_logic as (

    select
        transaction_id,
        customer_id,
        account_id,
        transaction_date,
        amount,
        currency,
        transaction_type,
        merchant,
        country,
        payment_method,
        status,

        case
            when status = 'SUCCESS' then true
            else false
        end as is_successful,

        case
            when status = 'FAILED' then true
            else false
        end as is_failed,

        case
            when status = 'PENDING' then true
            else false
        end as is_pending,

        case
            when amount < 100 then 'LOW'
            when amount < 1000 then 'MEDIUM'
            else 'HIGH'
        end as amount_category

    from transactions

)

select *
from business_logic