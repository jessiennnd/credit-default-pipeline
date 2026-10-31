-- One row per customer per statement month (30,000 x 6 = 180,000 rows).
-- Each row pairs the payment made that month with the bill it was paying.

with c as (
    select * from {{ ref('stg_customers') }}
),

months as (
    select c.customer_id, m.*
    from c,
    unnest([
        struct(1 as month_num, date '2005-09-01' as statement_month,
               c.pay_1 as repay_status, c.bill_amt1 as bill_amt,
               c.pay_amt1 as paid_amt, c.bill_amt2 as prev_bill_amt),
        struct(2, date '2005-08-01', c.pay_2, c.bill_amt2, c.pay_amt2, c.bill_amt3),
        struct(3, date '2005-07-01', c.pay_3, c.bill_amt3, c.pay_amt3, c.bill_amt4),
        struct(4, date '2005-06-01', c.pay_4, c.bill_amt4, c.pay_amt4, c.bill_amt5),
        struct(5, date '2005-05-01', c.pay_5, c.bill_amt5, c.pay_amt5, c.bill_amt6),
        struct(6, date '2005-04-01', c.pay_6, c.bill_amt6, c.pay_amt6, cast(null as float64))
    ]) as m
)

select
    *,
    -- DQ-06: -2, -1 and 0 all count as not delayed
    repay_status >= 1 as is_delayed,
    -- DQ-11: cap at 1 so overpaying doesn't distort the ratio.
    -- April has no earlier bill, so its ratio is null.
    case when prev_bill_amt > 0
         then least(paid_amt / prev_bill_amt, 1) end as payment_ratio
from months
