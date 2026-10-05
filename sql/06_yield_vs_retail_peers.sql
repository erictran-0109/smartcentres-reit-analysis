-- Question: Among REITs in the SAME sector (Retail), how does
-- SmartCentres' dividend yield compare to its direct competitors?
--
-- Note: symbol formats differ between tables (reit_types uses "REI.UN",
-- peer_metrics uses "REI-UN.TO"), so REPLACE() normalizes the format
-- before joining.
--
-- Insight: Within the Retail sector specifically (apples-to-apples
-- comparison), SmartCentres still leads on yield (6.76% vs 5.78% and
-- 5.54%) — a stronger claim than comparing against REITs in different
-- sectors with different business models/risk profiles.

CREATE OR REPLACE VIEW v_yield_retail_peers AS
SELECT
    p.symbol,
    p.dividend_yield,
    r.reit_type
FROM peer_metrics p
JOIN reit_types r ON r.symbol = REPLACE(p.symbol, '-UN.TO', '.UN')
WHERE r.reit_type = 'Retail'
ORDER BY p.dividend_yield DESC;