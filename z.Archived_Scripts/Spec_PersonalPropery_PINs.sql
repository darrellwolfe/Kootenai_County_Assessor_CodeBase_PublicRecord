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


*/

SELECT 
parcel.lrsn,
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress], 
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity], 
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 
LTRIM(RTRIM(parcel.DisplayDescr)) AS [LegalDesc]



FROM KCv_PARCELMASTER1 AS parcel


WHERE parcel.EffStatus= 'A'
AND parcel.ClassCD IN ('020 Commercial','021 Commercial 1','022 Commercial 2','030 Industrial','032 Industrial 2','070 Commercial - Late')

ORDER BY [ClassCD], [PIN];
