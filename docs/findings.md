# Stakeholder findings

One-off questions answered in SQL (`sql/q*.sql`). Figures from my run; check them against your own output.

**Q1. How much is owed, and how much sat with defaulters?** (Head of Credit Risk)
NT$1.54B is owed on September statements; customers who defaulted in October held NT$322M (20.9%), close to their 22.1% share of customers.
Action: defaulters are not concentrated in the biggest balances, so a review list must rank by risk as well as balance.

**Q2. Does last month's lateness predict default?** (Collections)
Default rate: not delayed 13.8%, 1 month late 33.9%, 2 months late 69.1%, 3+ months late 71.9%.
Action: two months late is the clearest cutoff; it defines the High tier.

**Q3. Does a history of lateness matter beyond last month?** (Credit policy)
Default rate rises from 11.7% (never late in 6 months) to 29.8% (late once), 50.9% (3 times) and 70.3% (all 6).
Action: repeated lateness is a second High-tier trigger (3+ late months); 1-2 late months define Watch.

**Q4. Do customers who pay little of their bill default more?** (Credit policy)
Only paying nothing stands out (52.5%). Paying under 10% (21.3%) defaults at about the same rate as paying 10-50% (22.1%).
Action: "paid under 10%" was dropped as a warning rule; it would flag about half of all customers with little extra risk.

**Q5. Who would simple rules flag?** (Head of Credit Risk)
High: 16.4% of customers, 60.7% default rate, 45.1% of all defaulters. Watch: 17.2%, 25.5%. Low: 66.4%, 11.7%.
Action: reviewing the High tier alone catches nearly half of next month's defaulters from one in six customers.

**Q6. What should Finance set aside?** (Finance, from `fct_customer_risk`)
Expected loss NT$334M on NT$1.54B owed (21.7%), an upper bound because loss given default is assumed 100%. The High tier holds 49% of it.
