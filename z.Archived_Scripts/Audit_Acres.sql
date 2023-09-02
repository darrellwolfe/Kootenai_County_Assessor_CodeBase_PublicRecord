/*
AsTxDBProd
GRM_Main
*/

SELECT 
parcel.lrsn,
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
parcel.neighborhood AS [GEO],
parcel.Acres AS [LegalAcres],
lh.TotalMktAcreage,
lh.TotalUseAcreage,
-- Add a calculated column named 'CalculatedAcres' to the 'parcel' table
(parcel.Acres - lh.TotalMktAcreage) AS [LegalAcres_vs_MarketAcres],
(parcel.Acres - lh.TotalUseAcreage) AS [LegalAcres_vs_UseAcres],
(lh.TotalMktAcreage - lh.TotalUseAcreage) AS [MarketAcres_vs_UseAcres],
lh.LandModelId,
lh.NbhdWhenPriced,
CONVERT(VARCHAR, lh.LastUpdate, 101) AS [LastUpdate]


FROM KCv_PARCELMASTER1 AS parcel
JOIN LandHeader AS lh ON parcel.lrsn=lh.RevObjId AND lh.EffStatus='A'

WHERE parcel.EffStatus= 'A'
-- Filter the LandModelId by the current (or desired) LandModel 702023 is TaxYear 2023
AND lh.LandModelId='702023'
-- Filter the calculated columns to only include instances where one of the three is not a 0 or null.
AND ((parcel.Acres - lh.TotalMktAcreage) <> 0 OR (parcel.Acres - lh.TotalMktAcreage) IS NOT NULL)
AND ((parcel.Acres - lh.TotalUseAcreage) <> 0 OR (parcel.Acres - lh.TotalUseAcreage) IS NOT NULL)
AND ((lh.TotalMktAcreage - lh.TotalUseAcreage) <> 0 OR (lh.TotalMktAcreage - lh.TotalUseAcreage) IS NOT NULL)

ORDER BY parcel.neighborhood, parcel.pin;
