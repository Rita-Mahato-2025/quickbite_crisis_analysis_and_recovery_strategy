
-- Monthly Orders: Compare total orders across pre-crisis(Jan–May 2025) vs crisis (Jun–Sep 2025).
-- How severe is the decline? 
SELECT
	CASE
		WHEN date(order_timestamp) BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-Crisis'
        WHEN date(order_timestamp) BETWEEN '2025-06-01' AND '2025-09-30' THEN 'Crisis'
    END AS period,
    COUNT(order_id) AS Total_Orders
FROM fact_orders
GROUP BY period;