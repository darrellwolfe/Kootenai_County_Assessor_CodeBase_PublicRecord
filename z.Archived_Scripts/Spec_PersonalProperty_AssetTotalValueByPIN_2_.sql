

/*
AsTxDBProd
GRM_Main


--These filter the tPPAsset table to the right year, but since we use them in the CTE to get the sum totals per lrsn, we do not need them again on the join to main query.
AND pp.mEffStatus='A'
AND pp.mbegTaxYear ='202300000'
AND pp.mendTaxYear = '202399999'
--Change Year each year 202300000 becomes 20240000, etc.



LEFT JOIN TotalValues AS tpp ON tpp.mPropertyId=parcel.lrsn
AND tpp.mChangeTimeStamp = MostRecentDate
??
*/




--Load CTE queries into final results
SELECT 
--Account Details
parcel.lrsn,
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
parcel.neighborhood AS [GEO],
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
--Demographics
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity],
--Value TotalAcquisitionValue
--Value TotalAppraisedValue
--Exemption 602KK
--Calculated Net
--Note
--304 & 341
--URD
--Mailing
LTRIM(RTRIM(parcel.AttentionLine)) AS [Attn],
LTRIM(RTRIM(parcel.MailingAddress)) AS [MailingAddress],
LTRIM(RTRIM(parcel.MailingCityStZip)) AS [Mailing CSZ]


FROM KCv_PARCELMASTER1 AS parcel

WHERE parcel.EffStatus= 'A'
AND (parcel.ClassCD LIKE '10%'
	OR parcel.ClassCD LIKE '20%'
	OR parcel.ClassCD LIKE '21%'
	OR parcel.ClassCD LIKE '22%'
	OR parcel.ClassCD LIKE '30%'
	OR parcel.ClassCD LIKE '32%'
	OR parcel.ClassCD LIKE '60%'
	OR parcel.ClassCD LIKE '70%'
	OR parcel.ClassCD LIKE '80%'
	OR parcel.ClassCD LIKE '90%'
	)


ORDER BY [GEO], [PIN]
;


/*

*/