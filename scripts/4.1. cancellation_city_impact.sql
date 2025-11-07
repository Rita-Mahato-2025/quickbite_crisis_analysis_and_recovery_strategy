WITH pre_crisis AS (
    SELECT 
        r.city,
        COUNT(*) AS total_orders_pre,
        SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_pre
    FROM fact_orders o
    JOIN dim_restaurant r
        ON o.restaurant_id = r.restaurant_id
    WHERE DATE(o.order_timestamp) < '2025-06-01'
    GROUP BY r.city
),
crisis AS (
    SELECT 
        r.city,
        COUNT(*) AS total_orders_crisis,
        SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_crisis
    FROM fact_orders o
    JOIN dim_restaurant r
        ON o.restaurant_id = r.restaurant_id
    WHERE DATE(o.order_timestamp) BETWEEN '2025-06-01' AND '2025-09-30'
    GROUP BY r.city
)
SELECT
    pre.city,
    ROUND((pre.cancelled_pre * 100.0 / pre.total_orders_pre), 2) AS pre_crisis_cancellation_rate,
    ROUND((cri.cancelled_crisis * 100.0 / cri.total_orders_crisis), 2) AS crisis_cancellation_rate,
    (ROUND((cri.cancelled_crisis * 100.0 / cri.total_orders_crisis), 2) - ROUND((pre.cancelled_pre * 100.0 / pre.total_orders_pre), 2)) AS change_in_rate
FROM pre_crisis pre
LEFT JOIN crisis cri
    ON pre.city = cri.city
ORDER BY change_in_rate DESC;
