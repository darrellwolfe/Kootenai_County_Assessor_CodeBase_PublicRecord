/*
AsTxDBProd
GRM_Main
*/
-- Parcel Master;

SELECT
    LTRIM(RTRIM(parcel.pin)) AS [PIN], 
    LTRIM(RTRIM(parcel.ain)) AS [AIN], 
    parcel.neighborhood AS [GEO],
    parcel.SitusAddress,
    p.permit_ref, 
    p.permit_desc, 
    CAST(p.cert_for_occ AS DATE) AS [cert_for_occ], -- Convert datetime column to date only
    t.AdjustedSalePrice AS [SalePrice],
    CAST(t.pxfer_date AS DATE) AS [TranxDate], -- Convert datetime column to date only
    CAST(f.date_completed AS DATE) AS [date_completed], -- Convert datetime column to date only
    f.need_to_visit, 
    f.field_person
FROM KCv_PARCELMASTER1 AS parcel
JOIN permits AS p ON parcel.lrsn=p.lrsn
JOIN field_visit AS f ON p.lrsn=f.lrsn AND p.field_number=f.field_number
JOIN transfer AS t ON p.lrsn=t.lrsn
WHERE parcel.EffStatus= 'A' 
    AND p.status= 'A' 
    AND f.date_completed IS NOT NULL
    AND f.field_person IS NOT NULL
    AND (f.need_to_visit IS NULL OR f.need_to_visit= 'N')
    AND (p.permit_desc LIKE '%HB%' OR p.permit_desc LIKE '%INC%')
    AND t.AdjustedSalePrice > 0
    AND t.pxfer_date BETWEEN '2022-01-01' AND '2023-01-15'
--Choose dates relevant to the roll in question
ORDER BY parcel.neighborhood, parcel.pin, p.permit_desc;
