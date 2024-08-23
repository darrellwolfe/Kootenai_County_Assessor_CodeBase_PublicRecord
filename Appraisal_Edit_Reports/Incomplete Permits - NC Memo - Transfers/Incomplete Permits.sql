-- !preview conn=con

SELECT
TRIM(p.pin) AS [PIN],
TRIM(p.AIN) AS [AIN],
p.neighborhood AS [GEO],
pe.permit_ref AS [Permit #],
pe.permit_desc,
pe.permit_type,
pe.cert_for_occ,
pe.permservice,
pe.filing_date


FROM TSBv_PARCELMASTER AS p
JOIN permits as pe ON p.lrsn=pe.lrsn
WHERE p.EffStatus = 'A'
AND pe.status = 'A'
AND pe.permit_desc LIKE '%INC%'