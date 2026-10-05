-- Question: How does SmartCentres' dividend yield compare to its closest peers?
SELECT
    symbol,
    current_price,
    dividend_yield
FROM peer_metrics
ORDER BY dividend_yield DESC;