-- Business rule: High tier must default more than Watch, and Watch more than Low.
with t as (
    select risk_tier, max(tier_pd) as pd
    from {{ ref('fct_customer_risk') }}
    group by risk_tier
)
select *
from t h, t w, t l
where h.risk_tier = 'High' and w.risk_tier = 'Watch' and l.risk_tier = 'Low'
  and not (h.pd > w.pd and w.pd > l.pd)
