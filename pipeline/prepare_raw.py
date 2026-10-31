import pandas as pd

RAW_XLS = "data/raw/default of credit card clients.xls"
OUT_CSV = "data/raw/credit_card_clients.csv"

# header=1 skips the extra 'X1, X2, ...' row at the top
df = pd.read_excel(RAW_XLS, header=1)

df = df.rename(columns={
    "PAY_0": "PAY_1",  # UCI skips PAY_1; renaming keeps months 1-6 consistent
    "default payment next month": "default_next_month",
})
df.columns = [c.lower() for c in df.columns]

df.to_csv(OUT_CSV, index=False)
print(f"Saved {OUT_CSV}: {df.shape[0]:,} rows, {df.shape[1]} columns")