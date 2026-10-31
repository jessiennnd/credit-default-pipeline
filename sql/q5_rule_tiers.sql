-- Q5 (Head of Credit Risk): if we flagged customers with simple rules, who would we catch?
-- These rules become the risk tiers in dbt (int_customer_risk).
WITH base AS (
  SELECT
    default_next_month,
    GREATEST(bill_amt1, 0) AS owed,
    GREATEST(pay_1, 0) AS latest_delay,
    (IF(pay_1 >= 1, 1, 0) + IF(pay_2 >= 1, 1, 0) + IF(pay_3 >= 1, 1, 0)
   + IF(pay_4 >= 1, 1, 0) + IF(pay_5 >= 1, 1, 0) + IF(pay_6 >= 1, 1, 0)) AS months_late_6m
  FROM `credit-default-pipeline-512502.credit_raw.customers`
),
tiered AS (
  SELECT *,
    CASE WHEN latest_delay >= 2 OR months_late_6m >= 3 THEN 'High'
         WHEN latest_delay = 1 OR months_late_6m BETWEEN 1 AND 2 THEN 'Watch'
         ELSE 'Low' END AS tier
  FROM base
)
SELECT
  tier,
  COUNT(*) AS customers,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 3) AS share_of_customers,
  ROUND(AVG(default_next_month), 3) AS default_rate,
  ROUND(SUM(default_next_month) / SUM(SUM(default_next_month)) OVER (), 3) AS share_of_defaulters,
  SUM(owed) AS owed
FROM tiered
GROUP BY tier
ORDER BY default_rate DESC;
