SELECT
    CASE
        WHEN o.order_timestamp BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-crisis'
        WHEN o.order_timestamp BETWEEN '2025-06-01' AND '2025-09-30' THEN 'Crisis'
    END AS period,
    ROUND(AVG(dp.actual_delivery_time_mins), 2) AS avg_delivery_time,
    ROUND(AVG(dp.expected_delivery_time_mins), 2) AS avg_expected_time,
    ROUND(AVG(dp.actual_delivery_time_mins - dp.expected_delivery_time_mins), 2) AS avg_delay,
    ROUND(
        100.0 * SUM(CASE WHEN dp.actual_delivery_time_mins <= dp.expected_delivery_time_mins THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS sla_compliance_percent
FROM
    fact_orders o
JOIN
    fact_delivery_performance dp 
    ON o.order_id = dp.order_id
WHERE
    o.order_timestamp >= '2025-01-01'
    AND o.order_timestamp <= '2025-09-30'
    AND (
        o.order_timestamp BETWEEN '2025-01-01' AND '2025-05-31'
        OR o.order_timestamp BETWEEN '2025-06-01' AND '2025-09-30'
    )
GROUP BY
    CASE
        WHEN o.order_timestamp BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-crisis'
        WHEN o.order_timestamp BETWEEN '2025-06-01' AND '2025-09-30' THEN 'Crisis'
    END
ORDER BY
    period;
