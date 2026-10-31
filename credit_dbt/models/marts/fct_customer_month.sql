-- Fact: one row per customer per statement month. Feeds the late-payment trend.

select
    customer_id,
    statement_month,
    month_num,
    repay_status,
    is_delayed,
    bill_amt,
    paid_amt,
    prev_bill_amt,
    payment_ratio
from {{ ref('stg_customer_month') }}
