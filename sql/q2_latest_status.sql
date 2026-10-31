-- Q2 (Collections): how strongly does last month's lateness predict default?
SELECT
  CASE WHEN pay_1 <= 0 THEN 'a. Not delayed'
       WHEN pay_1 = 1 THEN 'b. 1 month late'
       WHEN pay_1 = 2 THEN 'c. 2 months late'
       ELSE 'd. 3+ months late' END AS sep_status,
  COUNT(*) AS customers,
  ROUND(AVG(default_next_month), 3) AS default_rate
FROM `credit-default-pipeline-512502.credit_raw.customers`
GROUP BY sep_status
ORDER BY sep_status;
