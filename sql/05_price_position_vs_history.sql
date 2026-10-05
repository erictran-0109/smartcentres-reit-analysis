-- Question: Is the current stock price near a historical high or low?
-- (Risk-timing signal: buying near an all-time high carries more downside risk)
--
-- Insight: Current price sits at 99.29% of its historical range —
-- essentially at an all-time high ($30.06 vs. all-time high $30.21).
-- This is a caution signal for BUY recommendations, balancing the
-- positive yield/growth insights found earlier.

CREATE OR REPLACE VIEW v_price_position AS
SELECT
    (SELECT close FROM price_history ORDER BY date DESC LIMIT 1) AS current_price,
    MIN(close) AS lowest_price,
    MAX(close) AS highest_price,
    ROUND(
        ((SELECT close FROM price_history ORDER BY date DESC LIMIT 1) - MIN(close))
        / (MAX(close) - MIN(close)) * 100
    , 2) AS current_price_level
FROM price_history;