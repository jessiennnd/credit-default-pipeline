# Credit Card Risk Pipeline

An end-to-end analytics project that turns six months of card statements into early-warning answers for a credit risk team.

**Stack:** BigQuery · SQL · dbt Core · Power Query · Power BI · Git

![Portfolio risk dashboard](docs/dashboard_page1.png)

## The client ask

A Taiwanese card issuer (2005, illustrative scenario) is losing money to defaults it only notices after customers stop paying. The Head of Credit Risk asked three questions:

1. How much could we lose next month?
2. Is late payment getting worse?
3. Who should we review first?

## What I built

| Request | Answered with | Where |
|---|---|---|
| One-off questions from Credit, Collections and Finance | SQL queries | [`sql/`](sql/), results in [`docs/findings.md`](docs/findings.md) |
| Data quality checks before anything is built | SQL profiling against DAMA dimensions | [`docs/data_quality_log.md`](docs/data_quality_log.md) |
| Expected loss, risk tiers and a review list | dbt models and tests in BigQuery | [`credit_dbt/`](credit_dbt/) |
| Monthly monitoring for the credit team | Two-page Power BI dashboard | [`powerbi/`](powerbi/) |

## Headline findings

- **Expected loss next month: NT$334M** on NT$1.54B owed (21.7%), an upper bound since no recovery is assumed.
- **The High tier is 16% of customers but 49% of expected loss**, and holds 45% of next month's defaulters.
- **Late payers more than doubled**, from 10% of customers in April to 23% in September 2005.
- **Small credit limits default most:** 36% under NT$50k against 14% at NT$300k and above.

## Dashboard

| Page | Audience | Answers |
|---|---|---|
| Portfolio risk | Head of Credit Risk | How much could we lose, and is it getting worse? |
| Who to review first | Collections team | Which customers to call, ranked by expected loss, with the reason each was flagged |

Both pages filter by risk tier, credit limit and education. Sex is deliberately not a filter.

![Review list](docs/dashboard_page2.png)

## How it works

```
CSV -> BigQuery (credit_raw) -> dbt: staging -> intermediate -> marts (star schema)
                                                              -> Power Query -> Power BI
```

![dbt lineage graph](docs/lineage.jpg)

| Layer | Models | Job |
|---|---|---|
| Staging | `stg_customers`, `stg_customer_month` | Apply data quality fixes; reshape six month columns into rows |
| Intermediate | `int_customer_features`, `int_customer_risk` | Behaviour features; rule-based risk tiers; expected loss |
| Marts | `dim_customer`, `fct_customer_month`, `fct_customer_risk` | Kimball star schema for the dashboard |

`dbt build` rebuilds all 7 models and runs 11 tests in under a minute.

## Key decisions

- **Fix in dbt, never delete.** Data quality issues are fixed in versioned, tested SQL rather than by dropping rows, so every decision is traceable.
- **Business logic lives in dbt; Power Query only shapes data for presentation.** Every report shares one definition of "High risk" and "expected loss".
- **Rules before models.** Tiers are transparent rules the credit team can explain to a customer. A predictive model is the next step, not the starting point.
- **Evidence over assumptions.** "Paid under 10% of the bill" looked like a warning sign, but those customers default at about the same rate as people paying 10-50% (21% vs 22%). It was tested and dropped.
- **A star schema for the dashboard.** Months became rows, so a new month is new rows rather than a new column, and any measure can be filtered by any customer attribute.
- **Fairness.** Sex is excluded from the tiers and the dashboard filters.

## Data quality

Profiled against DAMA's dimensions: uniqueness, completeness, validity, consistency, accuracy and timeliness. 13 checks are logged with a finding and a decision in [`docs/data_quality_log.md`](docs/data_quality_log.md). One example: repayment code 1 ("one month late") is common in September but almost absent in earlier months, so one-month lateness can't be compared across months.

## Risk method

- **Tiers:** High = 2+ months late now, or late in 3+ of the last 6 months. Watch = 1 month late now, or late in 1-2 of the last 6 months. Otherwise Low.
- **Probability of default (PD)** is each tier's historical default rate: High 60.7%, Watch 25.5%, Low 11.7%.
- **Expected loss = PD x amount owed x loss given default (100%).**

## Assumptions and limits

- PD is measured on the same data the tiers describe, so it is an in-sample estimate.
- Within a tier every customer has the same PD, so the review list ranks by balance within a tier.
- Loss given default is 100% (no recovery data), so expected loss is an upper bound.
- 2005 data: this demonstrates the method, not today's limits.

## Project structure

```
credit-default-pipeline/
├── credit_dbt/        dbt project: models, tests, configuration
├── docs/              data quality log, findings, screenshots
├── pipeline/          raw data preparation and load
├── powerbi/           Power BI report, theme and page backgrounds
├── sql/               data quality checks and stakeholder questions
└── requirements.txt   Python packages (dbt-bigquery)
```

## Run it

```bash
python -m venv .venv && source .venv/Scripts/activate   # Windows Git Bash
pip install -r requirements.txt
gcloud auth application-default login
cd credit_dbt && dbt build
```

Then open `powerbi/credit_risk_monitor.pbix` and refresh.

## Next steps

- A predictive model (logistic regression in BigQuery ML), tested against the rules on held-out customers, to rank customers within each tier.
- Schedule `dbt build` monthly, and ask the bank for recovery data to replace the 100% loss assumption.

## Data source

Yeh, I-C. (2009). *Default of credit card clients* [Dataset]. UCI Machine Learning Repository.
