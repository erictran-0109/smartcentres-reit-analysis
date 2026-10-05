-- Question: How does SmartCentres' average stock price differ across
-- different inflation (CPI) levels?
--
-- Approach: Join price_history with inflation_cpi by MONTH (not exact
-- date) since CPI is only reported monthly while price is daily.
-- Thresholds chosen by splitting the observed CPI range (135.7-169.9)
-- into 3 equal parts (~11.4 each), since there's no obvious industry
-- convention for CPI levels like there is for interest rates.
--
-- Insight: Price rises steadily across all 3 CPI levels ($17.85 ->
-- $21.05 -> $22.55) — unlike interest rates, there's no reversal.
-- CAUTION: this may just reflect that both CPI and price trended
-- upward over 2020-2026, not a direct causal relationship.

CREATE OR REPLACE VIEW v_price_by_cpi_level AS
SELECT
    CASE
        WHEN i.cpi_value < 147 THEN '1. Low Level'
        WHEN i.cpi_value < 158 THEN '2. Rising Level'
        ELSE '3. High Level'
    END AS cpi_level,
    ROUND(AVG(p.close), 2) AS avg_stock_price,
    COUNT(*) AS num_days
FROM price_history p
JOIN inflation_cpi i ON DATE_FORMAT(p.date, '%Y-%m') = DATE_FORMAT(i.date, '%Y-%m')
GROUP BY cpi_level
ORDER BY cpi_level;