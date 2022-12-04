-- CREATE TABLE `program-data-fellowship-8.Session_3.clean_data` 
-- AS
-- SELECT DISTINCT *
-- FROM `data-to-insights.ecommerce.rev_transactions`;

WITH transactByDate AS (
SELECT 
  channelGrouping,
  PARSE_DATE("%Y%m%d", date) AS date_formatted, 
  SUM(totals_transactions) AS totalTrxByDate
FROM 
  `program-data-fellowship-8.Session_3.clean_data`
GROUP BY channelGrouping, date
),transactByCountry AS (
SELECT
  channelGrouping, 
  geoNetwork_country, 
  SUM(totals_transactions) AS totaltrxByCountry
FROM 
  `program-data-fellowship-8.Session_3.clean_data`
GROUP BY channelGrouping, geoNetwork_country
)
SELECT 
  tbd.channelGrouping,
  date_formatted,
  totalTrxByDate,
  ARRAY_AGG(
    STRUCT(geoNetwork_country, totalTrxByCountry)
  ) AS aggregated_country
FROM transactByDate tbd
INNER JOIN transactByCountry tbc
ON tbd.channelGrouping = tbc.channelGrouping
GROUP BY channelGrouping, date_formatted, totalTrxByDate
ORDER BY totalTrxByDate DESC