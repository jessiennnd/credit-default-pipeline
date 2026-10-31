# Credit Card Risk Pipeline

An end-to-end analytics pipeline that turns six months of card statements into early-warning answers for a credit risk team: **SQL, dbt and BigQuery**, served to a **Power BI** dashboard through **Power Query**.

## The client ask

A Taiwanese card issuer (2005, illustrative scenario) is losing money to defaults it only notices after customers stop paying. The Head of Credit Risk asked:

1. How much could we lose next month?
2. Is late payment getting worse?
3. Who should we review first?

## What I built

|Request|Answered with|
|-|-|
|One-off questions from Credit, Collections and Finance|SQL in [`sql/`](sql/), results in [`docs/findings.md`](docs/findings.md)|
|Expected loss, risk tiers, review list|dbt models in BigQuery ([`credit\_dbt/`](credit_dbt/))|
|Monthly monitoring|Power BI dashboard, two pages|

## Headline findings

* **Expected loss next month: NT$334M** on NT$1.54B owed (21.7%), an upper bound since no recovery is assumed.
* **The High tier is 16% of customers but 49% of expected loss**, and holds 45% of next month's defaulters.
* **Late payers more than doubled**, from 10% of customers in April to 23% in September 2005.

## How it works

```
CSV -> BigQuery (credit\_raw) -> dbt: staging -> intermediate -> marts (star schema)
                                                              -> Power Query -> Power BI
```

|Layer|Models|Job|
|-|-|-|
|Staging|`stg\_customers`, `stg\_customer\_month`|Apply data quality fixes; reshape six month columns into rows|
|Intermediate|`int\_customer\_features`, `int\_customer\_risk`|Behaviour features; rule-based tiers; expected loss|
|Marts|`dim\_customer`, `fct\_customer\_month`, `fct\_customer\_risk`|Kimball star schema for the dashboard|

**Business logic lives in dbt so every report shares one definition; Power Query only shapes the data for presentation.**

&#x20;  !\[dbt lineage graph](docs/lineage.jpg)

## Data quality

Profiled against DAMA's quality dimensions (uniqueness, completeness, validity, consistency, accuracy, timeliness). Every issue is logged with a decision in [`docs/data\_quality\_log.md`](docs/data_quality_log.md) and fixed in dbt. 11 dbt tests check keys, relationships, valid tiers, six months per customer, and that High risk defaults more than Watch and Watch more than Low.

## Risk method

* **Tiers** come from transparent rules: High = 2+ months late now, or late in 3+ of the last 6 months; Watch = 1 month late now, or late in 1-2 of the last 6 months; otherwise Low.
* **Probability of default (PD)** is each tier's historical default rate.
* **Expected loss = PD x amount owed x loss given default (100%).**

## Assumptions and limits

* PD is measured on the same data the tiers describe, so it is an in-sample estimate.
* Within a tier every customer has the same PD, so the review list ranks by balance within a tier.
* Loss given default is 100% (no recovery data), so expected loss is an upper bound.
* 2005 data: this demonstrates the method, not today's limits.
* Sex is excluded from tiers and dashboard filters.

## Next steps

* A predictive model (logistic regression in BigQuery ML), tested against the rules on held-out customers, to rank customers within each tier.
* Schedule `dbt build` monthly and ask the bank for recovery data to replace the 100% loss assumption.

## Run it

```bash
python -m venv .venv \&\& source .venv/Scripts/activate   # Windows Git Bash
pip install -r requirements.txt
gcloud auth application-default login
cd credit\_dbt \&\& dbt build
```

Then open the Power BI file and refresh.

## Data source

Yeh, I-C. (2009). *Default of credit card clients* \[Dataset]. UCI Machine Learning Repository.

