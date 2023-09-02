/*

Assessed Values

*/

/*
--Table
valuation
--Join
lrsn=lrsn --- Group by LRSN to get total value

imp_val (Cert Value)
imp_assess (Appraised Value)
property_class (PCC 10-90)
*/

--
SELECT 
    parcel.lrsn,
    LTRIM(RTRIM(parcel.pin)) AS [PIN], 
    LTRIM(RTRIM(parcel.ain)) AS [AIN], 
    parcel.neighborhood AS [GEO],
    v.land_market_val AS [Cert Land],
    v.imp_val AS [Cert Imp],
    (v.imp_val + v.land_market_val) AS [Cert Total Value],
    v.valuation_comment AS [Val Comment],
    v.eff_year AS [Tax Year],
    v.last_update AS [Last_Updated]
    
FROM KCv_PARCELMASTER1 AS parcel
INNER JOIN valuation AS v ON parcel.lrsn = v.lrsn
WHERE parcel.EffStatus = 'A'
AND v.status = 'A'
AND v.eff_year BETWEEN 20230101 AND 20231231
AND v.property_class IN ('10','20','21','22','30','32','60','70','80','90')

ORDER BY [GEO],[PIN],[Last_Updated];
