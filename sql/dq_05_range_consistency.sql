-- DQ-07 to DQ-12: numeric ranges and consistency between related fields.
SELECT
  MIN(age) AS min_age, MAX(age) AS max_age,
  MIN(limit_bal) AS min_limit, MAX(limit_bal) AS max_limit,
  MIN(bill_amt1) AS min_bill, MAX(bill_amt1) AS max_bill,
  COUNTIF(default_next_month NOT IN (0, 1)) AS invalid_target,
  COUNTIF(bill_amt1 < 0) AS negative_bills_sep,
  COUNTIF(LEAST(bill_amt1, bill_amt2, bill_amt3,
                bill_amt4, bill_amt5, bill_amt6) < 0) AS negative_bills_any_month,
  COUNTIF(bill_amt1 > limit_bal) AS over_limit_bills,
  COUNTIF(bill_amt1 = 0 AND bill_amt2 = 0 AND bill_amt3 = 0
      AND bill_amt4 = 0 AND bill_amt5 = 0 AND bill_amt6 = 0) AS inactive_6m,
  COUNTIF(pay_amt1 > bill_amt2 AND bill_amt2 > 0) AS overpaid_aug_bill
FROM `credit-default-pipeline-512502.credit_raw.customers`;
