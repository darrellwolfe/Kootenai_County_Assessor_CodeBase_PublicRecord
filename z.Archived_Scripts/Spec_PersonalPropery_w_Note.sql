SELECT 
parcel.lrsn,
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress], 
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity], 
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 
LTRIM(RTRIM(parcel.DisplayDescr)) AS [LegalDesc],
LTRIM(RTRIM(noteText)) AS [Note]



FROM KCv_PARCELMASTER1 AS parcel
LEFT JOIN note as n ON parcel.lrsn=n.objectId


WHERE parcel.EffStatus= 'A'
AND parcel.ClassCD IN ('020 Commercial','021 Commercial 1','022 Commercial 2','030 Industrial','032 Industrial 2','070 Commercial - Late')
AND (n.noteText LIKE '%Annual%' AND n.noteText LIKE '%2023%'
OR n.noteText LIKE '%NonReturn%' AND n.noteText IN ('%2023%','%2021%','%2022%''%2020%''%2019%'))

ORDER BY [Owner], [ClassCD], [PIN];
