SELECT LOWER(word) AS keyword, COUNT(*) AS frequency
FROM (
    SELECT TRIM(JSON_UNQUOTE(JSON_EXTRACT(CONCAT('["', 
                   REPLACE(REPLACE(review_text, '.', ''), ' ', '","'), '"]'), 
                   '$[0]'))) AS word
    FROM fact_ratings
    WHERE sentiment_score < 0
      AND STR_TO_DATE(review_timestamp, '%d-%m-%Y %H:%i') 
          BETWEEN '2025-06-01' AND '2025-09-30'
) AS words
WHERE LOWER(word) IN ('not', 'bad', 'stale', 'worst', 'terrible', 'horrible', 'never', 'cold')
GROUP BY keyword
ORDER BY frequency DESC;
