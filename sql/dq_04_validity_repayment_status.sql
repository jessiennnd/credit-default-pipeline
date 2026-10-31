-- DQ-06 and DQ-13: how do repayment status codes behave in each month?
-- The dictionary lists only -1 and 1-9; -2 and 0 also appear.
SELECT
  month_col,
  status,
  COUNT(*) AS n_rows,
  ROUND(AVG(default_next_month), 3) AS default_rate
FROM `credit-default-pipeline-512502.credit_raw.customers`
UNPIVOT (status FOR month_col IN (pay_1, pay_2, pay_3, pay_4, pay_5, pay_6))
GROUP BY month_col, status
ORDER BY month_col, status;
