
## Setup

```bash
python -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install yfinance pandas requests beautifulsoup4 pymongo mysql-connector-python python-dotenv
cp .env.example .env           # fill in your own DB credentials
```

`.env` needs: `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`, `MONGO_URI`. This file is gitignored and never committed — see `.gitignore`.

## Running the pipeline

Order matters — each step depends on the one before it:

```bash
# 1. Pull raw data
python acquisition/save_raw_data.py
python acquisition/interest_rate_pull.py
python acquisition/inflation_cpi_pull.py

# 2. Clean and load structured data into MySQL
python acquisition/process_market_data.py
python acquisition/load_mysql.py

# 3. Load semi-structured data into MongoDB
python acquisition/import_market_data.py
python acquisition/smartcentres_documents_pull.py
python acquisition/smartcentres_pdf_to_json.py
python acquisition/import_investor_documents.py
python acquisition/sedar_pdf_to_json.py
python acquisition/import_sedar_documents.py

# 4. Create the SQL Views (run the files in sql/ against the MySQL database)

# 5. Open dashboard/smartcentres_dashboard.pbix in Power BI Desktop
```

## Data sources

| Source | Storage | What |
|---|---|---|
| yfinance | MySQL (`price_history`), MongoDB (`fundamentals`, `news_headlines`) | Daily price history, company fundamentals, news |
| Bank of Canada | MySQL (`interest_rates`, `inflation_cpi`) | Overnight rate, CPI |
| wowa.ca | MySQL (`reit_types`, `peer_metrics`) | Peer REIT categorization and metrics |
| SEDAR+ | MongoDB (`sedar_documents`) | Q1 2026 interim MD&A — AFFO payout ratio, read manually (no public API) |
| smartcentres.com | MongoDB (`investor_documents`) | Investor relations filings |

Date range: January 1, 2020 – July 7, 2026 (fixed, not rolling).

## Known limitations

- Rate and CPI buckets use simple thresholds (not statistical breakpoints); the price patterns shown are correlations, not proven causal effects.
- The AFFO payout ratio (86.4%) was read manually from one quarterly filing, not computed from a standardized field — a single data point, not a trend.
- This analysis covers 2020–2026 only, a period that includes the COVID crash and a full rate-hiking cycle, so historical patterns may not hold going forward.
- For educational portfolio purposes only. Not financial advice.

## AI use disclosure

This project made use of Claude (Anthropic) for SQL instruction, data validation, and dashboard design support.