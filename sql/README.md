# SQL: data quality checks and stakeholder questions

Standalone BigQuery queries. The data quality checks ran before any modelling; the stakeholder questions answer one-off requests and set the rules later used in dbt.

## Data quality checks

| File | DAMA dimension | Question |
|---|---|---|
| `dq_01_uniqueness.sql` | Uniqueness | Is each customer recorded once? |
| `dq_02_completeness.sql` | Completeness | Are any values missing? |
| `dq_03_validity_categories.sql` | Validity | Do education, marriage and sex codes match the dictionary? |
| `dq_04_validity_repayment_status.sql` | Validity, consistency | How do repayment codes behave in each month? |
| `dq_05_range_consistency.sql` | Validity, consistency | Are numbers in range, and do related fields agree? |

Findings and decisions: [`../docs/data_quality_log.md`](../docs/data_quality_log.md)

## Stakeholder questions

| File | Asked by | Question |
|---|---|---|
| `q1_exposure.sql` | Head of Credit Risk | How much is owed, and how much sat with defaulters? |
| `q2_latest_status.sql` | Collections | How strongly does last month's lateness predict default? |
| `q3_late_history.sql` | Credit policy | Does a history of lateness matter beyond last month? |
| `q4_payment_ratio.sql` | Credit policy | Do customers who pay little of their bill default more? |
| `q5_rule_tiers.sql` | Head of Credit Risk | If we flagged customers with simple rules, who would we catch? |
| `q6_provision.sql` | Finance | What should we set aside for losses next month? |

Answers and recommended actions: [`../docs/findings.md`](../docs/findings.md)

Queries use the project `credit-default-pipeline-512502`; replace it with your own to rerun them.
