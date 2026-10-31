-- Fact: one row per customer with tier, exposure and expected loss. Feeds KPIs and the review list.

select
    customer_id,
    risk_tier,
    flag_reason,
    round(tier_pd, 4)       as tier_pd,
    ead,
    round(expected_loss, 0) as expected_loss,
    utilisation,
    latest_delay_months,
    months_late_6m,
    is_over_limit,
    default_next_month,
    row_number() over (order by expected_loss desc) as review_priority
from {{ ref('int_customer_risk') }}
