-- Q6 (Finance): what should we set aside for losses next month?
-- Run after dbt build. The row with a NULL tier is the portfolio total.
SELECT
  risk_tier,
  COUNT(*) AS customers,
  ROUND(SUM(ead)) AS owed,
  ROUND(SUM(expected_loss)) AS expected_loss
FROM `credit-default-pipeline-512502.credit_dbt_marts.fct_customer_risk`
GROUP BY ROLLUP(risk_tier)
ORDER BY expected_loss DESC;
