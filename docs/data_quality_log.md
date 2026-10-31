# Data quality log

Source: `credit_raw.customers`, UCI default of credit card clients (Taiwan), 30,000 customers, statements April-September 2005, outcome October 2005.
Checks follow DAMA's data quality dimensions. Queries are in `sql/dq_*.sql`.

**No rows were dropped. Every fix is applied in dbt, so it is versioned and tested.**

| ID | Dimension | Check | Finding | Rows | Decision | Fixed in |
|---|---|---|---|---|---|---|
| DQ-01 | Uniqueness | One row per customer | 30,000 rows, 30,000 IDs | 0 | Passed | - |
| DQ-02 | Completeness | Missing values | None in any column | 0 | Passed | - |
| DQ-03 | Validity | Education codes | 0, 5, 6 not in the definition (1-4) | 345 (1.2%) | Group into 4 = other | `stg_customers` |
| DQ-04 | Validity | Marriage codes | 0 not in the definition (1-3) | 54 (0.2%) | Group into 3 = other | `stg_customers` |
| DQ-05 | Validity | Sex codes | Only 1 and 2 | 0 | Passed | - |
| DQ-06 | Validity | Repayment status codes | -2 and 0 not in the definition. In September they default at 13.2% and 12.8%, close to -1 (16.8%) and far below 1 month late (33.9%) | -2: 2,759; 0: 14,737 (Sep) | Treat -2, -1, 0 as not delayed | `stg_customer_month` |
| DQ-07 | Validity | Numeric ranges | Age 21-79; limit 10k-1M; target only 0/1 | 0 | Passed | - |
| DQ-08 | Consistency | Negative bills | Negative in September; 1,930 have one in at least one month | 590 Sep (2.0%) | Keep; count as 0 owed | `int_customer_features` |
| DQ-09 | Consistency | Bill above limit | September bill exceeds the credit limit | 2,115 (7.1%) | Keep; flag `is_over_limit` | `int_customer_features` |
| DQ-11 | Consistency | Paid more than the bill | September payment exceeds the August bill | 2,757 (9.2%) | Cap payment ratio at 1 | `stg_customer_month` |
| DQ-12 | Consistency | No activity for 6 months | All six bills are zero | 866 (2.9%) | Keep; flag `is_inactive` | `int_customer_features` |
| DQ-13 | Consistency | Status code 1 by month | Code 1 (1 month late) is common in September (3,688) but almost absent in other months (28, 4, 2, 0, 0) | - | "Late" is defined as status >= 1, so earlier months still count lateness (recorded as 2+). Don't compare 1-month lateness across months | README limits |

## Assumptions

- The September payment is paired with the August bill it was paying (the data dictionary only says "amount paid in September").
- A customer with no bill to pay counts as having paid in full (payment ratio 1).
- The credit limit includes supplementary (family) cards, so utilisation may cover more than one cardholder.
- Timeliness: 2005 data is fit for demonstrating the method, not for setting today's limits.
