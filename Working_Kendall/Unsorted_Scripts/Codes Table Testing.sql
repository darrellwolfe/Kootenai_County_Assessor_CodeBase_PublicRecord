-- !preview conn=con
/*
AsTxDBProd
GRM_Main

CODES TABLE TESTING

*/

SELECT p.AIN,
v.*


FROM valuation AS v
JOIN TSBv_PARCELMASTER AS p ON v.lrsn = p.lrsn

WHERE v.status = 'A'
AND v.last_update > '2024-02-10'

ORDER BY p.AIN