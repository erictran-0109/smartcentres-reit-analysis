-- Question: How much has SmartCentres' stock price changed from 2020 to today?
-- Saved as a VIEW (v_price_summary) so Power BI can query it directly.

CREATE VIEW v_price_summary AS
SELECT
    (SELECT close FROM price_history ORDER BY date ASC LIMIT 1) AS starting_price,
    (SELECT close FROM price_history ORDER BY date DESC LIMIT 1) AS ending_price,
    ROUND(
        ((SELECT close FROM price_history ORDER BY date DESC LIMIT 1) - (SELECT close FROM price_history ORDER BY date ASC LIMIT 1))
        / (SELECT close FROM price_history ORDER BY date ASC LIMIT 1) * 100
    , 2) AS pct_change;