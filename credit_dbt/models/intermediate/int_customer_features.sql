-- One row per customer with the behaviour features used by the risk rules and dashboard.
-- Only April-September data is used; October is only the outcome.

with c as (
    select * from {{ ref('stg_customers') }}
),

history as (
    select
        customer_id,
        countif(is_delayed)            as months_late_6m,
        greatest(max(repay_status), 0) as max_delay_months,
        avg(payment_ratio)             as avg_payment_ratio_6m
    from {{ ref('stg_customer_month') }}
    group by customer_id
)

select
    c.customer_id,
    greatest(c.pay_1, 0) as latest_delay_months,
    h.months_late_6m,
    h.max_delay_months,
    -- Assumption (logged): no bill to pay counts as fully paid
    case when c.bill_amt2 > 0
         then least(c.pay_amt1 / c.bill_amt2, 1) else 1 end as payment_ratio_sep,
    coalesce(h.avg_payment_ratio_6m, 1) as avg_payment_ratio_6m,
    safe_divide(greatest(c.bill_amt1, 0), c.limit_bal) as utilisation,
    c.bill_amt1 > c.limit_bal as is_over_limit,                                   -- DQ-09
    (c.bill_amt1 = 0 and c.bill_amt2 = 0 and c.bill_amt3 = 0
     and c.bill_amt4 = 0 and c.bill_amt5 = 0 and c.bill_amt6 = 0) as is_inactive, -- DQ-12
    c.limit_bal,
    greatest(c.bill_amt1, 0) as ead,  -- DQ-08: exposure (amount owed); negative bill counts as 0
    c.default_next_month
from c
join history h using (customer_id)
