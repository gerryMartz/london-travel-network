# Exploring London's Travel Network

SQL analysis of London's public transport journeys (TfL data) using PostgreSQL.

## Task

Answer three questions about Transport for London (TfL) journeys with SQL:

1. What are the most popular transport types by total journeys?
2. Which five months/years were the most popular for the Emirates Airline?
3. Which five years had the lowest volume of `Underground & DLR` journeys?

## Dataset

- **Source:** [Public Transport Journeys by Type of Transport](https://data.london.gov.uk/dataset/public-transport-journeys-type-transport/) (Transport for London, via the London Datastore; Open Government Licence v2). Exported from a DataCamp DataLab workspace (Snowflake table `TFL.JOURNEYS`).
- **Size:** 936 rows, 6 transport types × 156 rows each.
- **Columns:** `index`, `MONTH`, `YEAR`, `DAYS`, `REPORT_DATE`, `JOURNEY_TYPE`, `JOURNEYS_MILLIONS`.
- **Transport types:** Bus, Emirates Airline, Overground, TfL Rail, Tram, Underground & DLR.

## Project structure

```
.
├── data/
│   ├── raw/journeys.csv
│   └── processed/
├── outputs/
├── queries/
│   ├── 01_create_raw_table.sql
│   ├── 02_load_raw_data.sql
│   ├── 03_most_popular_transport_types.sql
│   ├── 04_emirates_airline_popularity.sql
│   └── 05_least_popular_years_tube.sql
└── README.md
```

## How to reproduce

Requirements: PostgreSQL 17 and `psql`. Run everything from the project root, because `\copy` uses a relative path.

```bash
createdb london_travel_network
psql -d london_travel_network -f queries/01_create_raw_table.sql
psql -d london_travel_network -f queries/02_load_raw_data.sql   # expected: COPY 936
psql -d london_travel_network -f queries/03_most_popular_transport_types.sql
psql -d london_travel_network -f queries/04_emirates_airline_popularity.sql
psql -d london_travel_network -f queries/05_least_popular_years_tube.sql
```

The CSV is loaded as-is into `journeys_raw` (all columns `TEXT`) and cleaned in SQL
(`NULLIF(col, '')::NUMERIC`), so the load step never fails on bad values.

## Findings

**Most popular transport types (total journeys, millions)**

| Journey type | Total |
|---|---|
| Bus | 24,905.19 |
| Underground & DLR | 15,020.47 |
| Overground | 1,666.85 |
| TfL Rail | 411.31 |
| Tram | 314.69 |
| Emirates Airline | 14.58 |

**Emirates Airline: top 5 months (millions of journeys)**

| Month | Year | Journeys |
|---|---|---|
| 5 | 2012 | 0.53 |
| 6 | 2012 | 0.38 |
| 4 | 2012 | 0.24 |
| 5 | 2013 | 0.19 |
| 5 | 2015 | 0.19 |

**Years with the fewest `Underground & DLR` journeys (millions, rounded)**

| Year | Total |
|---|---|
| 2020 | 310.18 |
| 2021 | 748.45 |
| 2022 | 1,064.86 |
| 2010 | 1,096.15 |
| 2011 | 1,156.65 |

## Limitations

- `JOURNEYS_MILLIONS` has empty values for Emirates Airline. They are excluded, not treated as zero, because a missing value is not zero journeys. They likely correspond to the period before the service opened (June 2012); this was not verified.
- The source reports by TfL reporting period, so month-level comparisons are approximate.
- The dataset is a snapshot: 156 rows per type suggests 2010–2022, assumed complete years.
- Rankings are computed on unrounded values; rounding is applied only to the displayed output.
- PostgreSQL lowercases unquoted aliases, so output columns appear in lowercase (e.g. `total_journeys_millions`).