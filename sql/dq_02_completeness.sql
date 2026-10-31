-- DQ-02 Completeness: any missing values in the key fields?
SELECT
  COUNTIF(limit_bal IS NULL)          AS missing_limit,
  COUNTIF(age IS NULL)                AS missing_age,
  COUNTIF(education IS NULL)          AS missing_education,
  COUNTIF(pay_1 IS NULL)              AS missing_status_sep,
  COUNTIF(bill_amt1 IS NULL)          AS missing_bill_sep,
  COUNTIF(default_next_month IS NULL) AS missing_target
FROM `credit-default-pipeline-512502.credit_raw.customers`;
