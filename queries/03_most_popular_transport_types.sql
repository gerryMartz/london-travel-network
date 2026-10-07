SELECT journey_type,
       ROUND(SUM(NULLIF(journeys_millions, '')::NUMERIC), 2) AS total_journeys_millions
FROM journeys_raw
GROUP BY journey_type
ORDER BY total_journeys_millions DESC;
