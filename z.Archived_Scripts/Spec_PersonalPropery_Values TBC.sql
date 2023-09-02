/*
AsTxDBProd
GRM_Main
Audit_PersProp_


Catagories that may affect Personal Property
010 Operating Property
--PP doesn't use Operating Property, that is monitored by the state, and IT places values provided by the state. 
020 Commercial
021 Commercial 1 -- Discontinued
022 Commercial 2
030 Industrial
032 Industrial 2
060 Transient -- Discontinued
070 Commercial - Late
--We keep 90 for exempts (churches, for example) but we don't monitor them. If a property becomes non-exempt, this acts as a placeholder.
090 Exempt PPV

Common Use Types

--First Roll
020 Commercial
030 Industrial

--Second Roll
022 Commercial 2
032 Industrial 2

--Not on any annual roll
070 Commercial - Late


-------------Under Construction-------------------

*/


SELECT 
--Account Details
parcel.lrsn,
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
--Values
SUM(tpp.mAppraisedValue) AS [MPP Value],

--Notes
LTRIM(RTRIM(n.noteText)) AS [Notes],
--Demographics
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress], 
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity], 
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 
LTRIM(RTRIM(parcel.DisplayDescr)) AS [LegalDesc]


FROM KCv_PARCELMASTER1 AS parcel
LEFT JOIN tPPAsset AS tpp ON parcel.lrsn=tpp.mPropertyId
LEFT JOIN Note AS n ON parcel.lrsn=n.objectId

WHERE parcel.EffStatus= 'A'
AND tpp.mEffStatus='A'
OR (n.noteText LIKE '%Annual%' AND n.noteText LIKE '2023')
OR (n.noteText LIKE '%NonReturn%' AND n.noteText LIKE '2023')

AND parcel.ClassCD IN ('020 Commercial','021 Commercial 1','022 Commercial 2','030 Industrial','032 Industrial 2','070 Commercial - Late')

GROUP BY parcel.lrsn,
parcel.pin,
parcel.ain,
parcel.ClassCD,
parcel.DisplayName,
parcel.SitusAddress,
parcel.SitusCity,
parcel.TAG,
n.noteText,
parcel.DisplayDescr

ORDER BY [ClassCD], [PIN];
