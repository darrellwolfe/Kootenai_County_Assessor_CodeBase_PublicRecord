-- !preview conn=con

SELECT DISTINCT
  pm.lrsn,
  pm.DisplayName AS Owner,
  pm.MailingAddress,
  pm.MailingCityStZip,
  pm.pin,
  pm.AIN,
  pm.TAG,
  pm.DisplayDescr AS Legal_Desc,
  pm.LegalAcres

FROM TSBv_PARCELMASTER AS pm
WHERE pm.EffStatus = 'A'