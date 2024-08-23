-- !preview conn=con

SELECT DISTINCT
  LTRIM(RTRIM(parcel.AIN)) AS [AIN],
  LTRIM(RTRIM(parcel.pin)) AS [PIN],
  parcel.SitusAddress,
  parcel.neighborhood,
  p.permit_ref,
  p.permit_type,
  p.cert_for_occ,
  p.permservice

FROM TSBv_PARCELMASTER AS parcel
JOIN permits AS p ON parcel.lrsn = p.lrsn
  AND p.status = 'A'
  AND p.permit_type <> '9'
  AND (p.permservice IS NOT NULL OR p.cert_for_occ IS NOT NULL)
WHERE parcel.EffStatus = 'A'
  AND parcel.neighborhood > '1'
  AND parcel. neighborhood < '999'
;