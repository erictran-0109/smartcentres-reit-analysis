import json
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

# Read the already-cleaned fundamentals JSON
with open('data/processed/smartcentres/fundamentals_clean.json', 'r') as f:
    data = json.load(f)

# The 4 key metrics live inside the nested "fundamentals" object,
# not at the top level of the JSON
fundamentals = data['fundamentals']

payout_ratio = fundamentals.get('payoutRatio')
total_debt = fundamentals.get('totalDebt')
debt_to_equity = fundamentals.get('debtToEquity')
return_on_equity = fundamentals.get('returnOnEquity')

# AFFO-based payout ratios manually read from the Q1 2026 SEDAR+ interim
# MD&A filing (data/processed/sedar/sedar_documents.json). yfinance's
# payoutRatio (net-income based) is misleading for REITs because heavy
# real estate depreciation distorts net income; AFFO is the industry-
# standard cash-flow measure REITs actually report against.
affo_payout_ratio = 86.4
affo_adjusted_payout_ratio = 90.6
operating_cashflow_payout_ratio = 107.9

print(f"Payout Ratio (yfinance, net income basis): {payout_ratio}")
print(f"Total Debt: {total_debt}")
print(f"Debt to Equity: {debt_to_equity}")
print(f"Return on Equity: {return_on_equity}")
print(f"Payout Ratio to AFFO (SEDAR+): {affo_payout_ratio}")
print(f"Payout Ratio to AFFO with adjustments (SEDAR+): {affo_adjusted_payout_ratio}")
print(f"Payout Ratio to operating cash flow (SEDAR+): {operating_cashflow_payout_ratio}")

# Connect to MySQL
conn = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    port=os.getenv("MYSQL_PORT"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE")
)
cursor = conn.cursor()

# Create the table if it doesn't exist yet
cursor.execute("""
    CREATE TABLE IF NOT EXISTS key_fundamentals (
        company_id VARCHAR(50),
        payout_ratio DECIMAL(10,4),
        total_debt BIGINT,
        debt_to_equity DECIMAL(10,4),
        return_on_equity DECIMAL(10,4),
        affo_payout_ratio DECIMAL(10,4),
        affo_adjusted_payout_ratio DECIMAL(10,4),
        operating_cashflow_payout_ratio DECIMAL(10,4)
    )
""")

# Clear old data (safe to re-run) then insert the fresh values
cursor.execute("DELETE FROM key_fundamentals")
cursor.execute("""
    INSERT INTO key_fundamentals (
        company_id, payout_ratio, total_debt, debt_to_equity, return_on_equity,
        affo_payout_ratio, affo_adjusted_payout_ratio, operating_cashflow_payout_ratio
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
""", (
    'smartcentres', payout_ratio, total_debt, debt_to_equity, return_on_equity,
    affo_payout_ratio, affo_adjusted_payout_ratio, operating_cashflow_payout_ratio
))

conn.commit()
print("\nSaved to key_fundamentals table successfully!")

cursor.close()
conn.close()