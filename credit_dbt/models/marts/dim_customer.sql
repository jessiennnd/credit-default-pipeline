-- Customer dimension: descriptive attributes used to filter the dashboard.
-- Sex is deliberately excluded: it is not a fair basis for credit decisions.

select
    c.customer_id,
    case c.education when 1 then 'Graduate school' when 2 then 'University'
                     when 3 then 'High school' else 'Other' end as education,
    case c.marriage when 1 then 'Married' when 2 then 'Single' else 'Other' end as marriage,
    c.age,
    case when c.age < 30 then 'Under 30' when c.age < 40 then '30-39'
         when c.age < 50 then '40-49' else '50+' end as age_band,
    c.limit_bal,
    case when c.limit_bal < 50000 then 'Under 50k' when c.limit_bal < 150000 then '50k-150k'
         when c.limit_bal < 300000 then '150k-300k' else '300k+' end as limit_band,
    r.risk_tier,
    r.flag_reason
from {{ ref('stg_customers') }} c
join {{ ref('int_customer_risk') }} r using (customer_id)
