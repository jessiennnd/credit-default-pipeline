-- One row per customer: types standardised and undocumented category codes grouped.
-- No rows are dropped.

with source as (
    select * from {{ source('credit_raw', 'customers') }}
)

select
    id as customer_id,
    cast(limit_bal as float64) as limit_bal,
    sex,
    -- DQ-03: education 0, 5, 6 are undocumented -> 4 = other
    case when education in (1, 2, 3, 4) then education else 4 end as education,
    -- DQ-04: marriage 0 is undocumented -> 3 = other
    case when marriage in (1, 2, 3) then marriage else 3 end as marriage,
    age,
    pay_1, pay_2, pay_3, pay_4, pay_5, pay_6,
    cast(bill_amt1 as float64) as bill_amt1, cast(bill_amt2 as float64) as bill_amt2,
    cast(bill_amt3 as float64) as bill_amt3, cast(bill_amt4 as float64) as bill_amt4,
    cast(bill_amt5 as float64) as bill_amt5, cast(bill_amt6 as float64) as bill_amt6,
    cast(pay_amt1 as float64) as pay_amt1, cast(pay_amt2 as float64) as pay_amt2,
    cast(pay_amt3 as float64) as pay_amt3, cast(pay_amt4 as float64) as pay_amt4,
    cast(pay_amt5 as float64) as pay_amt5, cast(pay_amt6 as float64) as pay_amt6,
    default_next_month
from source
