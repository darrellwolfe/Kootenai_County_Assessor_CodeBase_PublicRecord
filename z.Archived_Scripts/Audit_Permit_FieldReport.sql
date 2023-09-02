/*
AsTxDBProd
GRM_Main
*/

SELECT 
parcel.lrsn, 
parcel.pin, 
parcel.ain, 
parcel.ClassCD, 
parcel.DisplayName, 
parcel.SitusAddress, 
parcel.SitusCity,
parcel.neighborhood, 
parcel.TAG, 
parcel.Acres, 
parcel.DisplayDescr, 
parcel.EffStatus,
p.permit_ref, p.permit_desc, p.cert_for_occ,
f.date_completed, f.need_to_visit, f.field_person,
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
p.permit_fee AS [PERMIT FEE],
m2.memo_id AS [MEMO ID],
CONCAT(m2.memo_text,' ,', m3.memo_text,' ,', m4.memo_text) AS [MemoText]


FROM KCv_PARCELMASTER1 AS parcel
JOIN permits AS p ON parcel.lrsn=p.lrsn
JOIN field_visit AS f ON p.lrsn=f.lrsn AND p.field_number=f.field_number
LEFT OUTER JOIN memos AS m2 ON parcel.lrsn=m2.lrsn AND m2.memo_id = 'PERM' AND m2.memo_line_number = '2'
LEFT OUTER JOIN memos AS m3 ON parcel.lrsn=m3.lrsn AND m3.memo_id = 'PERM' AND m3.memo_line_number = '3'
LEFT OUTER JOIN memos AS m4 ON parcel.lrsn=m4.lrsn AND m4.memo_id = 'PERM' AND m4.memo_line_number = '4'



WHERE parcel.EffStatus= 'A'
AND p.status= 'A' 

ORDER BY parcel.neighborhood, parcel.pin;
