/*
AsTxDBProd
GRM_Main
*/

/*
AsTxDBProd
GRM_Main
*/


---------
--Select Lite
---------

Select
LTRIM(RTRIM(pm.lrsn)) AS [LRSN],
LTRIM(RTRIM(pm.pin)) AS [PIN],
LTRIM(RTRIM(pm.AIN)) AS [AIN],
LTRIM(RTRIM(pm.PropClassDescr)) AS [PCC],
LTRIM(RTRIM(pm.neighborhood)) AS [GEO],
LTRIM(RTRIM(pm.TAG)) AS [TAG],
LTRIM(RTRIM(pm.DisplayName)) AS [OwnerName],
LTRIM(RTRIM(pm.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(pm.SitusCity)) AS [SitusCity]

From TSBv_PARCELMASTER AS pm

Where pm.EffStatus = 'A'




-------
--OLD KCv Version
------

SELECT 
--Account Details
parcel.lrsn,
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
parcel.neighborhood AS [GEO],
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 


--Demographics
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity]


FROM KCv_PARCELMASTER1 AS parcel

WHERE parcel.EffStatus= 'A'


ORDER BY parcel.neighborhood, parcel.pin;







