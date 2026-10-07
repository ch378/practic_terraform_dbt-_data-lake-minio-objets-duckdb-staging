with transactions as (

    select *
    from {{ ref('mart_transactions') }}

),

daily as (

    select

        transaction_date_day,

        currency,

        count(*) as total_transactions,

        sum(amount) as total_amount,

        sum(
            case
                when is_successful then 1
                else 0
            end
        ) as successful_transactions,

        sum(
            case
                when is_failed then 1
                else 0
            end
        ) as failed_transactions,

        sum(
            case
                when is_pending then 1
                else 0
            end
        ) as pending_transactions,

        avg(amount) as average_transaction_amount,

        min(amount) as minimum_transaction_amount,

        max(amount) as maximum_transaction_amount

    from transactions

    group by
        transaction_date_day,
        currency

)

select *
from daily