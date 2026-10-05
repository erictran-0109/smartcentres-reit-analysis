-- Question: How does SmartCentres' average stock price differ across
-- different interest rate levels (Low / Rising / High)?
--
-- Approach: Join price_history with interest_rates on matching date,
-- then bucket each day by the ACTUAL interest rate value (not by a
-- guessed date cutoff), then average stock price per bucket.
--
-- Insight: Price is NOT simply "higher rate = lower price."
-- It peaked during the Rising Rate period ($23.80), then dropped
-- during the High Rate period ($20.46) — suggesting the market reacts
-- more to the SPEED of rate change than to the absolute rate level.

CREATE OR REPLACE VIEW v_price_by_interest_rate AS
SELECT
    CASE
        WHEN i.overnight_rate_pct < 1 THEN '1. Low Rate'
        WHEN i.overnight_rate_pct < 3 THEN '2. Rising Rate'
        ELSE '3. High Rate'
    END AS rate_period,
    ROUND(AVG(p.close), 2) AS avg_stock_price,
    COUNT(*) AS num_days
FROM price_history p
JOIN interest_rates i ON p.date = i.date
GROUP BY rate_period
ORDER BY rate_period;