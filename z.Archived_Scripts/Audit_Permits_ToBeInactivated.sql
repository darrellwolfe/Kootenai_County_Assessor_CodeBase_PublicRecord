
/*
AsTxDBProd
GRM_Main
*/
-- Parcel Master;

SELECT
parcel.pin, parcel.ain, parcel.neighborhood AS GEO, parcel.SitusAddress,
p.permit_ref, p.permit_desc, p.cert_for_occ,
f.date_completed, f.need_to_visit, f.field_person

FROM KCv_PARCELMASTER1 AS parcel
JOIN permits AS p ON parcel.lrsn=p.lrsn
JOIN field_visit AS f ON p.lrsn=f.lrsn AND p.field_number=f.field_number

WHERE parcel.EffStatus= 'A' 
AND p.status= 'A' 
AND f.date_completed IS NOT NULL
AND f.field_person IS NOT NULL
AND (f.need_to_visit IS NULL OR f.need_to_visit= 'N')


ORDER BY parcel.neighborhood, parcel.pin;


