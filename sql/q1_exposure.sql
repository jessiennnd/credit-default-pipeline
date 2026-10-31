-- Q1 (Head of Credit Risk): how much is owed, and how much sat with customers who defaulted?
SELECT
  SUM(GREATEST(bill_amt1, 0)) AS total_owed_sep,
  SUM(IF(default_next_month = 1, GREATEST(bill_amt1, 0), 0)) AS owed_by_defaulters,
  ROUND(SAFE_DIVIDE(
    SUM(IF(default_next_month = 1, GREATEST(bill_amt1, 0), 0)),
    SUM(GREATEST(bill_amt1, 0))), 3) AS share_owed_by_defaulters
FROM `credit-default-pipeline-512502.credit_raw.customers`;
