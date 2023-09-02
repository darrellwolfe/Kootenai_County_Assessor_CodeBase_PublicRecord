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
    ag.AggregateSize AS [LandBase],
    -- Add a calculated column named 'CalculatedAcres' to the 'parcel' table
    ROUND(parcel.Acres - lh.TotalMktAcreage, 4) AS [LegalAcres_vs_MarketAcres],
    ROUND(parcel.Acres - ag.AggregateSize, 4) AS [LegalAcres_vs_LandBase],
    lh.LandModelId,
    lh.NbhdWhenPriced,
    CONVERT(VARCHAR, lh.LastUpdate, 101) AS [LastUpdate]
FROM 
    KCv_PARCELMASTER1 AS parcel
JOIN 
    LandHeader AS lh ON parcel.lrsn=lh.RevObjId AND lh.EffStatus='A'
JOIN 
    LBAggregateSize AS ag ON lh.Id=ag.LandHeaderId AND ag.PostingSource='A'
WHERE 
    parcel.EffStatus= 'A'
    -- Filter the LandModelId by the current (or desired) LandModel 702023 is TaxYear 2023
    AND lh.LandModelId='702023'
    -- Filter the calculated columns to only include instances where one of the three is not a 0 or null.
    AND ((parcel.Acres - lh.TotalMktAcreage) <> 0 AND (parcel.Acres - lh.TotalMktAcreage) IS NOT NULL)
    AND ((parcel.Acres - ag.AggregateSize) <> 0 AND (parcel.Acres - ag.AggregateSize) IS NOT NULL)
ORDER BY 
    parcel.neighborhood, parcel.pin;
