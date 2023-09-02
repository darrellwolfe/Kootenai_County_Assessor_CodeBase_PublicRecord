

SELECT 
    neighborhood AS [GEO],
    COUNT(DISTINCT lrsn) AS [Parcel_Count]
FROM 
    TSBv_PARCELMASTER

GROUP BY
    neighborhood

ORDER BY
    Geo ASC;


