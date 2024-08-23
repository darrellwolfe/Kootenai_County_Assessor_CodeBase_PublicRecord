-- !preview conn=conn

/*
AsTxDBProd
GRM_Main

*/

WITH 

CTE_ParcelsVisited AS (
SELECT
    e.lrsn,
    -- e.extension,
    e.data_source_code,
    e.data_collector,
    e.collection_date

FROM extensions AS e

WHERE e.extension = 'L00'
AND e.collection_date > '2013-01-01'
--BETWEEN '2022-04-16' AND '2027-04-15'
)

SELECT
YEAR(pv.collection_date) AS YearVisited,
COUNT(pv.collection_date) AS CountOfVisited

FROM CTE_ParcelsVisited AS pv

GROUP BY YEAR(pv.collection_date)