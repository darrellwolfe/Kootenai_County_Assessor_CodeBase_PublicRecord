WITH CTE_ParcelMaster AS (
SELECT DISTINCT
    CASE
        WHEN p.neighborhood >= 9000 THEN 'Manufactured_Homes'
        WHEN p.neighborhood >= 6003 THEN 'District_6'
        WHEN p.neighborhood = 6002 THEN 'Manufactured_Homes'
        WHEN p.neighborhood = 6001 THEN 'District_6'
        WHEN p.neighborhood = 6000 THEN 'Manufactured_Homes'
        WHEN p.neighborhood >= 5003 THEN 'District_5'
        WHEN p.neighborhood = 5002 THEN 'Manufactured_Homes'
        WHEN p.neighborhood = 5001 THEN 'District_5'
        WHEN p.neighborhood = 5000 THEN 'Manufactured_Homes'
        WHEN p.neighborhood >= 4000 THEN 'District_4'
        WHEN p.neighborhood >= 3000 THEN 'District_3'
        WHEN p.neighborhood >= 2000 THEN 'District_2'
        WHEN p.neighborhood >= 1021 THEN 'District_1'
        WHEN p.neighborhood = 1020 THEN 'Manufactured_Homes'
        WHEN p.neighborhood >= 1001 THEN 'District_1'
        WHEN p.neighborhood = 1000 THEN 'Manufactured_Homes'
        WHEN p.neighborhood >= 451 THEN 'Commercial'
        WHEN p.neighborhood = 450 THEN 'Specialized_Cell_Towers'
        WHEN p.neighborhood >= 1 THEN 'Commercial'
        WHEN p.neighborhood = 0 THEN 'N/A_or_Error'
    ELSE NULL
    END AS District,
    p.neighborhood AS GEO,
    p.lrsn AS LRSN,
    TRIM(p.pin) AS PIN,
    TRIM(p.AIN) AS AIN,
    p.ClassCD AS PCC,
    p.LegalAcres

    FROM TSBv_PARCELMASTER AS p

    WHERE p.EffStatus = 'A'
        AND p.ClassCD NOT LIKE '070%'
)


SELECT DISTINCT
pmd.District
,pmd.GEO
,pmd.lrsn
,lh.RevObjId
,pmd.PIN
,pmd.AIN

,pmd.LegalAcres
,lh.TotalMktAcreage
,lh.TotalUseAcreage
,lh.TotalMktValue
,ag.AggregateType
,ag.AggregateSize

FROM LandHeader AS lh  
JOIN LBAggregateSize AS ag 
    ON lh.Id=ag.LandHeaderId 
    AND ag.EffStatus='A'
    AND ag.PostingSource='A'
    
JOIN CTE_ParcelMaster AS pmd
    ON lh.RevObjId=pmd.lrsn


WHERE lh.EffStatus='A' 
    AND lh.PostingSource='A'
    
    AND pmd.LegalAcres <> 0
    AND pmd.LegalAcres <> lh.TotalMktAcreage; -- This line checks for the inequality

    
    
    
    
    
    
    
