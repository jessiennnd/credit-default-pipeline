-- Q4 (Credit policy): do customers who pay little of their bill default more?
-- September payment divided by the August bill it was paying.
WITH r AS (
  SELECT default_next_month, SAFE_DIVIDE(pay_amt1, bill_amt2) AS pay_ratio
  FROM `credit-default-pipeline-512502.credit_raw.customers`
  WHERE bill_amt2 > 0
)
SELECT
  CASE WHEN pay_ratio = 0 THEN 'a. Paid nothing'
       WHEN pay_ratio < 0.1 THEN 'b. Under 10%'
       WHEN pay_ratio < 0.5 THEN 'c. 10-50%'
       WHEN pay_ratio < 1 THEN 'd. 50-100%'
       ELSE 'e. Paid in full' END AS ratio_band,
  COUNT(*) AS customers,
  ROUND(AVG(default_next_month), 3) AS default_rate
FROM r
GROUP BY ratio_band
ORDER BY ratio_band;
