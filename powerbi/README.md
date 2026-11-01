# Power BI dashboard

| File | Contents |
|---|---|
| `credit_risk_monitor.pbix` | The report: two pages built on the dbt marts |
| `credit-risk-monitor-theme.json` | Theme: colours, fonts and transparent visuals |
| `page1_background.png`, `page2_background.png` | Page layouts imported as canvas backgrounds |

## Data model

A star schema from `credit_dbt_marts`: `dim_customer` (Customers) joins one-to-many to `fct_customer_month` (Statements) and one-to-one to `fct_customer_risk` (Risk) on `customer_id`.

Power Query handles presentation only: friendly table names, sort-order columns and tier colours. All risk logic stays in dbt.

## Measures

```text
Customer Count  = COUNTROWS(Customers)
Amount Owed     = SUM(Risk[ead])
Expected Loss   = SUM(Risk[expected_loss])
Loss Rate       = DIVIDE([Expected Loss], [Amount Owed])
Default Rate    = AVERAGE(Risk[default_next_month])
High Tier Share = DIVIDE(CALCULATE([Customer Count], Customers[risk_tier] = "High"), [Customer Count])
Late Share      = DIVIDE(CALCULATE(COUNTROWS(Statements), Statements[is_delayed] = TRUE()),
                         COUNTROWS(Statements))
```

## Pages

| Page | Audience | Visuals |
|---|---|---|
| Portfolio risk | Head of Credit Risk | 5 KPI cards; expected loss by tier; late payers by month; default rate by credit limit |
| Who to review first | Collections | 3 KPI cards; review list ranked by expected loss, filtered to High and Watch |
