# Pipeline: raw data preparation

Prepares the raw UCI file and loads it into BigQuery as `credit_raw.customers`, the single source every dbt model reads from.

| File | What it does |
|---|---|
| `prepare_raw.py` | Reads the raw CSV, standardises column names to lowercase snake_case, and writes the table to BigQuery |

The raw CSV is not stored in this repository. Download it from the UCI Machine Learning Repository ("Default of credit card clients") into `data/` before running.
