with source as (

    select *
    from {{ source('banking', 'raw_transactions') }}

),

cleaned as (

    select
        transaction_id,
        customer_id,
        account_id,
        cast(transaction_date as timestamp) as transaction_date,
        cast(amount as decimal(18, 2)) as amount,
        upper(trim(currency)) as currency,
        upper(trim(transaction_type)) as transaction_type,
        trim(merchant) as merchant,
        upper(trim(country)) as country,
        upper(trim(payment_method)) as payment_method,
        upper(trim(status)) as status

    from source

)

select *
from cleaned