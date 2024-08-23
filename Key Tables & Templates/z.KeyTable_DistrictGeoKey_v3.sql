-- !preview conn=conn

SELECT
    CASE
        WHEN GEO >= 9000 THEN 'Manufactured_Homes'
        WHEN GEO >= 6003 THEN 'District_6'
        WHEN GEO = 6002 THEN 'Manufactured_Homes'
        WHEN GEO = 6001 THEN 'District_6'
        WHEN GEO = 6000 THEN 'Manufactured_Homes'
        WHEN GEO >= 5003 THEN 'District_5'
        WHEN GEO = 5002 THEN 'Manufactured_Homes'
        WHEN GEO = 5001 THEN 'District_5'
        WHEN GEO = 5000 THEN 'Manufactured_Homes'
        WHEN GEO >= 4000 THEN 'District_4'
        WHEN GEO >= 3000 THEN 'District_3'
        WHEN GEO >= 2000 THEN 'District_2'
        WHEN GEO >= 1021 THEN 'District_1'
        WHEN GEO = 1020 THEN 'Manufactured_Homes'
        WHEN GEO >= 1001 THEN 'District_1'
        WHEN GEO = 1000 THEN 'Manufactured_Homes'
        WHEN GEO >= 451 THEN 'Commercial'
        WHEN GEO = 450 THEN 'Specialized_Cell_Towers'
        WHEN GEO >= 1 THEN 'Commercial'
        WHEN GEO = 0 THEN 'N/A_or_Error'
        ELSE NULL
    END AS District,
    GEO
FROM (
    SELECT DISTINCT
        pm.neighborhood AS GEO
    FROM TSBv_PARCELMASTER AS pm
    WHERE pm.EffStatus = 'A'
    AND pm.neighborhood <> 0
) AS Subquery