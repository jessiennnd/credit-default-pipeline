-- Rule-based risk tiers, the rule that fired, and expected loss per customer.
-- Rules come from the stakeholder SQL analysis (sql/q5_rule_tiers.sql).
-- Paying under 10% of the bill was tested and dropped: it defaults at about the
-- same rate as paying 10-50%, so it is not a useful warning sign.

with f as (
    select * from {{ ref('int_customer_features') }}
),

tiered as (
    select
        *,
        case when latest_delay_months >= 2 or months_late_6m >= 3 then 'High'
             when latest_delay_months = 1 or months_late_6m between 1 and 2 then 'Watch'
             else 'Low' end as risk_tier,
        case when latest_delay_months >= 2 then '2+ months late now'
             when months_late_6m >= 3     then 'Late in 3+ of last 6 months'
             when latest_delay_months = 1 then '1 month late now'
             when months_late_6m between 1 and 2 then 'Late in 1-2 of last 6 months'
             else 'No warning sign' end as flag_reason
    from f
)

select
    *,
    -- PD = the tier's historical default rate (measured on this same data)
    avg(default_next_month) over (partition by risk_tier) as tier_pd,
    -- Expected loss = PD x exposure x loss given default
    avg(default_next_month) over (partition by risk_tier) * ead * {{ var('lgd') }} as expected_loss
from tiered
