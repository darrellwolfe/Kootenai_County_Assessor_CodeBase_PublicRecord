/*
AsTxDBProd
GRM_Main

--Last Three Years 2020-2022
AND v.eff_year BETWEEN 20200101 AND 20221231

*/

WITH TAXBILLVALUES AS (

SELECT DISTINCT
CONCAT(CAST(tb.TaxYear AS VARCHAR(10)), '-', tb.BillNumber) AS [TaxBill#],
tb.AssessmentYear AS [AssessmentYear],
tbn.RevObjId AS [RevObjId],
tbv.ValueTypeId AS [ValueTypeId],
vt.Descr AS [ValueType],
tbv.ValueAmount AS [TaxBillAmount]

FROM TaxBill AS tb
INNER JOIN TaxBillTran AS tbn ON tb.Id = tbn.TaxBillId
INNER JOIN TaxBillValue AS tbv ON tbn.Id = tbv.TaxBillTranId
INNER JOIN ValueType AS vt ON tbv.ValueTypeId=vt.Id

WHERE tb.AssessmentYear IN (2019, 2020, 2021, 2022, 2023)

)





SELECT 
--Account Details
parcel.lrsn,
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
parcel.neighborhood AS [GEO],
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 

--Values Tax Assessed
v.land_assess AS [Assessed Land],
v.imp_assess AS [Assessed Imp],
(v.imp_assess + v.land_assess) AS [Assessed Total Value],
v.valuation_comment AS [Val Comment],
MAX(v.eff_year) AS [Tax_Year],
MAX(v.last_update) AS [Last_Update],
--TaxBill
tb.TaxBill#,
tb.AssessmentYear AS [AssessmentYear],
tb.RevObjId AS [RevObjId],
tb.ValueTypeId AS [ValueTypeId],
tb.ValueType,
tb.TaxBillAmount,

--Demographics
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity],
--Mailing
LTRIM(RTRIM(parcel.AttentionLine)) AS [Attn],
LTRIM(RTRIM(parcel.MailingAddress)) AS [MailingAddress],
LTRIM(RTRIM(parcel.MailingCityStZip)) AS [Mailing CSZ],

--Acres
parcel.Acres,
--Other
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 
LTRIM(RTRIM(parcel.DisplayDescr)) AS [LegalDescription],
LTRIM(RTRIM(parcel.SecTwnRng)) AS [SecTwnRng]

FROM KCv_PARCELMASTER1 AS parcel
JOIN valuation AS v ON parcel.lrsn = v.lrsn
JOIN TAXBILLVALUES AS tb ON parcel.lrsn=tb.RevObjId


WHERE parcel.EffStatus = 'A'
AND v.status = 'A'
--Last Three Years 2020-2022
AND v.eff_year BETWEEN 20200101 AND 20221231


GROUP BY 
parcel.lrsn,
parcel.ain,
parcel.pin,
parcel.neighborhood,
parcel.ClassCD,
v.land_assess,
v.imp_assess,
(v.imp_assess + v.land_assess),
v.valuation_comment,
parcel.DisplayName,
parcel.SitusAddress,
parcel.SitusCity,
parcel.AttentionLine,
parcel.MailingAddress,
parcel.MailingCityStZip,
parcel.Acres,
parcel.TAG,
parcel.DisplayDescr,
parcel.SecTwnRng
tb.TaxBill#,
tb.AssessmentYear,
tb.RevObjId,
tb.ValueTypeId,
tb.ValueType,
tb.TaxBillAmount



