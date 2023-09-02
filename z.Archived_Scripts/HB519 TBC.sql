
/*
AsTxDBProd
GRM_Main

    AND t.AdjustedSalePrice > 0
    AND t.pxfer_date BETWEEN '2022-01-01' AND '2023-01-15'


*/

WITH TransferDate AS (
    SELECT
        tx.lrsn,
        tx.AdjustedSalePrice AS [SalePrice],
        tx.pxfer_date,
        ROW_NUMBER() OVER (PARTITION BY tx.lrsn ORDER BY tx.pxfer_date DESC) AS RowNum
    FROM transfer AS tx
    WHERE tx.status = 'A'
)

SELECT 
parcel.lrsn,
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
parcel.neighborhood AS [GEO],
m.memo_text AS [MEMOS],
CAST(t.pxfer_date AS DATE) AS [TranxDate], -- Convert datetime column to date only
tr.AdjustedSalePrice AS [SalePrice],
a.group_code AS [GroupCode],
a.property_class AS [ClassCode],
a.extension AS [Record],
a.improvement_id AS [ImpId],
CONVERT(VARCHAR, a.last_update, 101) AS [LastUpdate],
i.extension AS [IMP],
p.permit_ref AS [Permit Ref#],
p.permit_desc AS [Permit Description], 
CONVERT(VARCHAR, p.cert_for_occ, 101) AS [Occ Date],
CONVERT(VARCHAR, f.date_completed, 101) AS [Completed Date], 
f.need_to_visit AS [Visit Y_N], 
f.field_person AS [Appraiser]




FROM KCv_PARCELMASTER1 AS parcel
JOIN memos AS m ON parcel.lrsn=m.lrsn AND m.memo_id = 'B519' AND m.memo_line_number = '1' AND m.status='A'
LEFT JOIN allocations AS a ON parcel.lrsn=a.lrsn AND a.status='A'
LEFT JOIN improvements AS i ON parcel.lrsn=i.lrsn AND i.status = 'A'
LEFT JOIN permits AS p ON parcel.lrsn=p.lrsn AND p.status= 'A'
LEFT JOIN field_visit AS f ON p.lrsn=f.lrsn AND p.field_number=f.field_number
LEFT JOIN TransferDate AS t ON parcel.lrsn=t.lrsn
LEFT JOIN transfer AS tr ON parcel.lrsn=t.lrsn

WHERE parcel.EffStatus= 'A' 
    AND p.status= 'A' 
    AND f.date_completed IS NOT NULL
    AND f.field_person IS NOT NULL
    AND (f.need_to_visit IS NULL OR f.need_to_visit= 'N')
    AND (p.permit_desc LIKE '%HB%' OR p.permit_desc LIKE '%INC%')
AND t.RowNum = 1



ORDER BY parcel.neighborhood, parcel.pin;
