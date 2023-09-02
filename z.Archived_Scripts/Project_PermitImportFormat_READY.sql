
/*
AsTxDBProd
GRM_Main
Literally the same code as CHECK but without:
p.permit_ref, p.permit_desc, p.cert_for_occ,
f.date_completed, f.need_to_visit, f.field_person,
*/
-- Re-Import;

SELECT
parcel.pin AS PIN,
p.permit_ref AS REFERENCE#,
p.cost_estimate AS [COST ESTIMATE],
p.sq_ft AS [ESTIMATED SF],
p.filing_date AS [FILING DATE],
p.callback AS [CALLBACK DATE],
p.inactivedate,
p.cert_for_occ AS [DATE CERT FOR OCC],
p.permit_desc AS DESCRIPTION,
p.permit_type AS [PERMIT TYPE],
p.permit_source AS [PERMIT SOURCE],
p.phone_number AS [PHONE NUMBER],
p.permit_char3,
p.status_code,
p.permit_char20b,
p.permit_int2,
p.permit_int3,
p.permit_int4,
p.permservice AS [PERMANENT SERVICE DATE],
p.permit_fee AS [PERMIT FEE]


FROM KCv_PARCELMASTER1 AS parcel
JOIN permits AS p ON parcel.lrsn=p.lrsn
JOIN field_visit AS f ON p.lrsn=f.lrsn AND p.field_number=f.field_number

WHERE parcel.EffStatus= 'A' 
AND p.status= 'A' 
AND f.date_completed IS NOT NULL
AND f.field_person IS NOT NULL
AND (f.need_to_visit IS NULL OR f.need_to_visit= 'N')
AND (p.permit_desc NOT LIKE '%HB%' AND p.permit_desc NOT LIKE '%INC%')

