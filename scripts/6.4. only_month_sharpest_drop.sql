-- only the biggest drop
WITH monthly_avg AS (
  SELECT
      DATE_FORMAT(STR_TO_DATE(review_timestamp, '%d-%m-%Y %H:%i'), '%Y-%m') AS month,
      AVG(rating) AS avg_rating_month
  FROM fact_ratings
  WHERE review_timestamp IS NOT NULL
  GROUP BY DATE_FORMAT(STR_TO_DATE(review_timestamp, '%d-%m-%Y %H:%i'), '%Y-%m')
),
monthly_change AS (
  SELECT
      month,
      avg_rating_month,
      avg_rating_month - LAG(avg_rating_month) OVER (ORDER BY month) AS change_from_prev
  FROM monthly_avg
)
SELECT *
FROM monthly_change
WHERE change_from_prev = (
    SELECT MIN(change_from_prev)
    FROM monthly_change
)
AND change_from_prev IS NOT NULL;
