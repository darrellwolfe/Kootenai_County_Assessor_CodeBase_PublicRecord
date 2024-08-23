-- !preview conn=conn


/*
AsTxDBProd
GRM_Main

**PERSONAL PROPERTY QUERY REQUIRES YEARLY UPDATES IN SEVERAL TABLES, REVIEW ALL YEARS
2023 TO 2024, ETC.

*/


--Begins CTE Statements chained within a single WITH statement

--Only change year, not structure
--Change first four digits to last year for both
DECLARE @LastYearCertFrom INT = '20220101';
DECLARE @LastYearCertTo INT = '20221231';

--Change first four digits to this year for both
DECLARE @Jan1ThisYear1 DATETIME;
SET @Jan1ThisYear1 = '2023-01-01 00:00:00';

DECLARE @Jan1ThisYear2 DATETIME;
SET @Jan1ThisYear2 = '2023-01-01 23:59:59';



DECLARE @ThisYearCertFrom INT = '20230101';
DECLARE @ThisYearCertTo INT = '20231231';
DECLARE @ThisYearMPPVFrom INT = '202300000';
DECLARE @ThisYearMPPVTo INT = '202399999';



WITH

CTE_PCC_to_System AS (
Select
tbl_type_code AS PCC
,tbl_element AS ClassCD
,tbl_element_desc AS ClassCD_Desc
,CodesToSysType AS ClassCD_SystemType

From codes_table
Where tbl_type_code LIKE '%PCC%'
And code_status = 'A'

--Order by tbl_element_desc
)

--CTE_GetRevObjByEffDate_Jan1 AS (
SELECT
grobed.Id -- Id is RevObjId is lrsn
,grobed.BegEffDate
,grobed.TranId
,grobed.GeoCd
,grobed.ClassCd
--,grobed.ClassCd AS ClassCd_Today
,sys.ClassCD AS ClassCd_Jan1
,sys.ClassCD_Desc AS ClassCdDesc_Jan1


,TRIM(grobed.PIN) AS PIN
,TRIM(grobed.UnformattedPIN) AS UnformattedPIN
,TRIM(grobed.AIN) AS AIN
,ROW_NUMBER() OVER (PARTITION BY grobed.Id ORDER BY grobed.BegEffDate DESC) AS RowNumber

From RevObj AS grobed
LEFT JOIN CTE_PCC_to_System AS sys
  ON grobed.ClassCd = sys.ClassCD_SystemType


Where BegEffDate BETWEEN @Jan1ThisYear1 AND @Jan1ThisYear2
--Where BegEffDate = @Today
--),
