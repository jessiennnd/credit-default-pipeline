# dbt project: credit_dbt

Turns the raw card data in BigQuery into clean, tested tables for analysis and the dashboard. Every transformation after the raw load happens here, in version-controlled SQL.

## Layers

| Layer | Model | Grain | What it does |
|---|---|---|---|
| Staging | `stg_customers` | Customer | Standardises types; groups undocumented education and marriage codes (DQ-03, DQ-04) |
| Staging | `stg_customer_month` | Customer x month | Reshapes six month columns into rows; treats codes -2, -1, 0 as not delayed (DQ-06); caps payment ratio at 1 (DQ-11) |
| Intermediate | `int_customer_features` | Customer | Months late, worst delay, share of bill paid, utilisation, amount owed |
| Intermediate | `int_customer_risk` | Customer | Rule-based risk tier, the rule that fired, tier PD and expected loss |
| Marts | `dim_customer` | Customer | Descriptive attributes for dashboard filters |
| Marts | `fct_customer_month` | Customer x month | Monthly bills, payments and lateness |
| Marts | `fct_customer_risk` | Customer | Tier, exposure, expected loss and review priority |

Staging models are views; intermediate and marts are tables. BigQuery datasets: `credit_dbt_staging`, `credit_dbt_intermediate`, `credit_dbt_marts`.

## Tests

| Test | Checks |
|---|---|
| `unique`, `not_null` | One row per customer in `dim_customer` and `fct_customer_risk` |
| `relationships` | Every fact row links to a customer in `dim_customer` |
| `accepted_values` | Risk tier is only High, Watch or Low |
| `assert_six_months_per_customer` | Each customer has exactly six statement months |
| `assert_loss_not_above_owed` | Expected loss never exceeds the amount owed |
| `assert_tiers_ranked_by_risk` | High defaults more than Watch, and Watch more than Low |

## Settings

`dbt_project.yml` holds one business assumption as a variable: `lgd: 1.0` (loss given default). Changing it updates expected loss everywhere.

## Commands

```bash
dbt build                          # build all models and run all tests
dbt build --select stg_customers   # one model only
dbt docs generate && dbt docs serve   # browse documentation and the lineage graph
```
