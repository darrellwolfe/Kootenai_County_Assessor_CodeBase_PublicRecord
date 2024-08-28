-- !preview conn=con

SELECT
    e.lrsn,
    -- e.extension,
    e.data_source_code,
    e.data_collector,
    e.collection_date

FROM extensions AS e

WHERE e.extension = 'L00'
AND e.status = 'A'
AND e.collection_date NOT BETWEEN '2022-04-16' AND '2027-04-15'