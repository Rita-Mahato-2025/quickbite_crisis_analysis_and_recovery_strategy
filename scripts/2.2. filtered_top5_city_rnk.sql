WITH city_orders AS (
    SELECT
        c.city,
        SUM(CASE 
                WHEN DATE(order_timestamp) BETWEEN '2025-01-01' AND '2025-05-31' THEN 1 
                ELSE 0 
            END) AS precrisis_count,
        SUM(CASE 
                WHEN DATE(order_timestamp) BETWEEN '2025-06-01' AND '2025-09-30' THEN 1 
                ELSE 0 
            END) AS crisis_count
    FROM fact_orders o
    LEFT JOIN dim_customer c
        ON o.customer_id = c.customer_id
    WHERE city IS NOT NULL
    GROUP BY c.city
)
, ranked AS (
    SELECT
        city,
        precrisis_count,
        crisis_count,
        ROUND(((precrisis_count - crisis_count) * 100.0 / precrisis_count), 2) AS decline_pct,
        DENSE_RANK() OVER (ORDER BY ROUND(((precrisis_count - crisis_count) * 100.0 / precrisis_count), 2) DESC) AS decline_pct_rnk
    FROM city_orders
)
SELECT *
FROM ranked
WHERE decline_pct_rnk <= 5
ORDER BY decline_pct DESC;
