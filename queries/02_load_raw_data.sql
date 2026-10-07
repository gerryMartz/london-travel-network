TRUNCATE journeys_raw;

\copy journeys_raw FROM 'data/raw/journeys.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')