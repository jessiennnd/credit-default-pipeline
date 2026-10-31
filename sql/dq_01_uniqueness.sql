-- DQ-01 Uniqueness: is each customer recorded once? Expect 30,000 and 30,000.
SELECT COUNT(*) AS n_rows, COUNT(DISTINCT id) AS n_unique_customers
FROM `credit-default-pipeline-512502.credit_raw.customers`;
