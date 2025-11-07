WITH pre_crisis AS (
    SELECT
        r.restaurant_id,
        restaurant_name,
        COUNT(o.order_id) AS pre_order_count
    FROM dim_restaurant r
    JOIN fact_orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE order_timestamp < '2025-06-01'
    GROUP BY r.restaurant_id, restaurant_name
    HAVING COUNT(o.order_id) >= 15
    ORDER BY pre_order_count DESC
    LIMIT 10
),
crisis AS (
    SELECT
        r.restaurant_id,
        COUNT(o.order_id) AS crisis_order_count
    FROM dim_restaurant r
    JOIN fact_orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE order_timestamp BETWEEN '2025-06-01' AND '2025-09-30'
    GROUP BY r.restaurant_id
)
SELECT
    p.restaurant_id,
    p.restaurant_name,
    p.pre_order_count,
    COALESCE(c.crisis_order_count, 0) AS crisis_order_count,
    ROUND( ((p.pre_order_count - COALESCE(c.crisis_order_count, 0)) * 100.0) / p.pre_order_count, 2) AS pct_decline
FROM pre_crisis p
LEFT JOIN crisis c
    ON p.restaurant_id = c.restaurant_id
ORDER BY pre_order_count DESC;
