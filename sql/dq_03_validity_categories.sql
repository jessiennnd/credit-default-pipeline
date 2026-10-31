-- DQ-03 to DQ-05 Validity: do category codes follow the data dictionary?
-- Education should be 1-4, marriage 1-3, sex 1-2.
SELECT 'education' AS column_name, education AS value, COUNT(*) AS n_rows
FROM `credit-default-pipeline-512502.credit_raw.customers` GROUP BY education
UNION ALL
SELECT 'marriage', marriage, COUNT(*) FROM `credit-default-pipeline-512502.credit_raw.customers` GROUP BY marriage
UNION ALL
SELECT 'sex', sex, COUNT(*) FROM `credit-default-pipeline-512502.credit_raw.customers` GROUP BY sex
ORDER BY column_name, value;
