SELECT year,
       journey_type,
       SUM(journeys_millions::NUMERIC) AS total_journeys_millions
FROM journeys_raw
WHERE journey_type = 'Underground & DLR'
GROUP BY year, journey_type
ORDER BY total_journeys_millions ASC
LIMIT 5;