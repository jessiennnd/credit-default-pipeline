-- Q3 (Credit policy): does a history of lateness matter beyond last month?
SELECT
  (IF(pay_1 >= 1, 1, 0) + IF(pay_2 >= 1, 1, 0) + IF(pay_3 >= 1, 1, 0)
 + IF(pay_4 >= 1, 1, 0) + IF(pay_5 >= 1, 1, 0) + IF(pay_6 >= 1, 1, 0)) AS months_late_6m,
  COUNT(*) AS customers,
  ROUND(AVG(default_next_month), 3) AS default_rate
FROM `credit-default-pipeline-512502.credit_raw.customers`
GROUP BY months_late_6m
ORDER BY months_late_6m;
