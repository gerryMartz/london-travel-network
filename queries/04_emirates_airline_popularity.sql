SELECT month,
       year,
       ROUND(SUM(NULLIF(journeys_millions, '')::NUMERIC), 2) AS rounded_journeys_millions
FROM journeys_raw
WHERE journey_type = 'Emirates Airline' AND NULLIF(journeys_millions, '') IS NOT NULL
GROUP BY month, year
ORDER BY rounded_journeys_millions DESC
LIMIT 5;