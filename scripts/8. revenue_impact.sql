WITH revenue_by_period AS (
    SELECT 
        CASE 
            WHEN DATE(order_timestamp) BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-Crisis'
            WHEN DATE(order_timestamp) BETWEEN '2025-06-01' AND '2025-09-30' THEN 'Crisis'
        END AS period,
        SUM(subtotal_amount) AS total_subtotal,
        SUM(discount_amount) AS total_discount,
        SUM(delivery_fee) AS total_delivery_fee,
        SUM(subtotal_amount - discount_amount + delivery_fee) AS total_revenue
    FROM fact_orders
    WHERE DATE(order_timestamp) BETWEEN '2025-01-01' AND '2025-09-30'
    GROUP BY 
        CASE 
            WHEN DATE(order_timestamp) BETWEEN '2025-01-01' AND '2025-05-31' THEN 'Pre-Crisis'
            WHEN DATE(order_timestamp) BETWEEN '2025-06-01' AND '2025-09-30' THEN 'Crisis'
        END
)
SELECT 
    ROUND(pre.total_revenue / 1000000, 2) AS pre_crisis_revenue_million,
    ROUND(cri.total_revenue / 1000000, 2) AS crisis_revenue_million,
    ROUND((pre.total_revenue - cri.total_revenue) / 1000000, 2) AS revenue_loss_million,
    ROUND((pre.total_revenue - cri.total_revenue) / pre.total_revenue * 100, 2) AS revenue_loss_percent
FROM 
    (SELECT total_revenue FROM revenue_by_period WHERE period = 'Pre-Crisis') pre,
    (SELECT total_revenue FROM revenue_by_period WHERE period = 'Crisis') cri;
