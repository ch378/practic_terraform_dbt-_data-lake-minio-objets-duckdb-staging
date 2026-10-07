with transactions as (

    select *
    from {{ ref('int_transactions') }}

)

select

    transaction_id,
    customer_id,
    account_id,

    transaction_date,
    cast(transaction_date as date) as transaction_date_day,

    amount,
    currency,

    transaction_type,
    merchant,
    country,
    payment_method,

    status,

    is_successful,
    is_failed,
    is_pending,

    amount_category

from transactions