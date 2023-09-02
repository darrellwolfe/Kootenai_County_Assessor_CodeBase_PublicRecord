-- !preview conn=con

/*
AsTxDBProd
GRM_Main

LTRIM(RTRIM())

*/


Select
pm.lrsn,
pm.pin,
pm.AIN,
pm.PropClassDescr,
pm.neighborhood,
pm.NeighborHoodName,
pm.TAG,
pm.DisplayName,
pm.SitusAddress,
pm.SitusCity,
pm.LegalAcres,
pm.TotalAcres,
pm.Improvement_Status,
pm.WorkValue_Land,
pm.WorkValue_Impv,
pm.WorkValue_Total,
pm.CostingMethod
RevObjId,
cv.PIN,
cv.AIN,
cv.ClassCd,
cv.TAGShortDescr,
cv.TAGYear,
cv.AssessmentYear,
cv.CadRollDescr,
cv.RollLevel,
cv.ValueAmount,
cv.CalculatedAmount,
cv.FormattedValueAmount,
cv.ValueTypeShortDescr,
cv.ValueTypeDescr

From TSBv_PARCELMASTER AS pm
Join CadValueTypeAmount_V AS cv ON pm.lrsn = cv.RevObjId
WHERE cv.AssessmentYear LIKE '2023%'
AND cv.CadRollDescr NOT LIKE '%Personal%'
AND cv.AIN = '193308'

Order By cv.ValueTypeDescr 
--WHERE cv.AssessmentYear IN ('2023','2022','2021','2020','2019','2018')