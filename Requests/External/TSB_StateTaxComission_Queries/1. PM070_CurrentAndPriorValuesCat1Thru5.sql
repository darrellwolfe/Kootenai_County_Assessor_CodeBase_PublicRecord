DECLARE @p_TaxYear INT = '2024';
DECLARE @ValueType INT = '109';
--Use the current tax year, 
-- the CTE_Temp_Prior auto subtracts one year to get prior year

WITH

CTE_ParcelMaster AS (
--------------------------------
--ParcelMaster
--------------------------------
Select Distinct
CASE
  WHEN pm.neighborhood >= 9000 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood >= 6003 THEN 'District_6'
  WHEN pm.neighborhood = 6002 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood = 6001 THEN 'District_6'
  WHEN pm.neighborhood = 6000 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood >= 5003 THEN 'District_5'
  WHEN pm.neighborhood = 5002 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood = 5001 THEN 'District_5'
  WHEN pm.neighborhood = 5000 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood >= 4000 THEN 'District_4'
  WHEN pm.neighborhood >= 3000 THEN 'District_3'
  WHEN pm.neighborhood >= 2000 THEN 'District_2'
  WHEN pm.neighborhood >= 1021 THEN 'District_1'
  WHEN pm.neighborhood = 1020 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood >= 1001 THEN 'District_1'
  WHEN pm.neighborhood = 1000 THEN 'Manufactured_Homes'
  WHEN pm.neighborhood >= 451 THEN 'Commercial'
  WHEN pm.neighborhood = 450 THEN 'Specialized_Cell_Towers'
  WHEN pm.neighborhood >= 1 THEN 'Commercial'
  WHEN pm.neighborhood = 0 THEN 'N/A_or_Error'
  ELSE NULL
END AS District
-- # District SubClass
,pm.neighborhood AS GEO
,TRIM(pm.NeighborHoodName) AS GEO_Name
,pm.lrsn
,TRIM(pm.pin) AS PIN
,TRIM(pm.AIN) AS AIN
,TRIM(pm.TAG) AS TAG

From TSBv_PARCELMASTER AS pm

Where pm.EffStatus = 'A'
AND pm.ClassCD NOT LIKE '070%'
),


CTE_Temp_Current AS (
			SELECT DISTINCT
			c.LRSN,
			c.PIN,
			c.AIN,	
			c.Tag,							
			(select EffStatus from RevObj r where r.id = c.lrsn and r.BegEffDate = (select max(BegEffDate) from RevObj rsub where rsub.id = r.id)) as CurrStatus,
			CurrYear = @p_TaxYear,
			CurrTotal = 0,
			Cat01c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200300),0),
			Acres01c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200300),0),
			Cat02c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200301),0),
			Acres02c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200301),0),
			Cat03c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200302),0),
			Acres03c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200302),0),
			Cat04c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200303),0),
			Acres04c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200303),0),
			Cat05c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200304),0),
			Acres05c = isnull((select ValueAmount from ValueTypeAmount where HeaderId = c.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200304),0)
			FROM tsbv_cadastre AS c
			WHERE c.TaxYear = @p_TaxYear
  --AND c.ValueType = 101 -- LandMarket
  --AND c.ValueType = 112 -- PABLYV
  --AND c.ValueType = 471 -- AcresByCat
    --  109 Total Value Total Value

  AND c.ValueType = 109 -- AssessedByCat
),


CTE_Temp_Prior AS (
			SELECT DISTINCT
			p.LRSN as PriorLRSN,
			PriorYear = @p_TaxYear - 1,
			PriorTotal = 0,
			Cat01p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200300),0),
			Acres01p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200300),0),
			Cat02p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200301),0),
			Acres02p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200301),0),
			Cat03p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200302),0),
			Acres03p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200302),0),
			Cat04p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200303),0),
			Acres04p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200303),0),
			Cat05p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 470 and AddlObjectId = 1200304),0),
			Acres05p = isnull((select ValueAmount from ValueTypeAmount where HeaderId = p.CadInvId and ValueTypeId = 471 and AddlObjectId = 1200304),0)
		
			FROM tsbv_cadastre AS p
			WHERE p.TaxYear = @p_TaxYear - 1
  --AND p.ValueType = 101 -- LandMarket
  --AND p.ValueType = 112 -- PABLYV
  --AND p.ValueType = 471 -- AcresByCat
      AND p.ValueType = 109 -- AssessedByCat
)



Select
/*
pmd.District
,pmd.GEO
,pmd.GEO_Name
,pmd.PIN
,pmd.TAG
*/
tc.LRSN
,tc.PIN
,tc.AIN
,tc.Tag
,tc.CurrStatus
,tc.CurrYear
,tc.CurrTotal
,tc.Cat01c
,tc.Acres01c
,tc.Cat02c
,tc.Acres02c
,tc.Cat03c
,tc.Acres03c
,tc.Cat04c
,tc.Acres04c
,tc.Cat05c
,tc.Acres05c

,tp.PriorLRSN
,tp.PriorYear
,tp.PriorTotal
,tp.Cat01p
,tp.Acres01p
,tp.Cat02p
,tp.Acres02p
,tp.Cat03p
,tp.Acres03p
,tp.Cat04p
,tp.Acres04p
,tp.Cat05p
,tp.Acres05p




From CTE_Temp_Current AS tc
  --ON tc.LRSN = pmd.lrsn

Inner Join CTE_Temp_Prior AS tp
  ON tp.PriorLRSN = tc.LRSN

Order by 2
--From CTE_ParcelMaster AS pmd

--Order By pmd.District,pmd.GEO,pmd.PIN;



/*
Converting report from TSB Dashboard view not in our database to SQL
Table View in Crystal is: TSBsp_tsb_CPCertCat1Thru5;1
Report Name: PM070_CurrentAndPriorValuesCat1Thru5

c=Current
{TSBsp_tsb_CPCertCat1Thru5;1.cat01c} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat02c} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat03c} + 
{TSBsp_tsb_CPCertCat1Thru5;1.cat04c} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat05c}

p=Prior
{TSBsp_tsb_CPCertCat1Thru5;1.cat01p} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat02p} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat03p} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat04p} +
{TSBsp_tsb_CPCertCat1Thru5;1.cat05p}

"PIN"	"TAG"	Status

"Curr Year"	
"CurrCat01"	
"CurrAcres01"	
"CurrCat02"	
"CurrAcres02"	
"CurrCat03"	
"CurrAcres03"	
"CurrCat04"	
"CurrAcres04"	
"CurrCat05"	
"CurrAcres05"	

"PriorYear"	
"PriorCat01"	
"PriorAcres01"	
"PriorCat02"	
"PriorAcres02"	
"PriorCat03"	
"PriorAcres03"	
"PriorCat04"	
"PriorAcres04"	
"PriorCat05"	
"PriorAcres05"


Categories unclear, requested clarification from 
'Sandy Bowens' and 'Brad Broenneke'

Darrell G Wolfe 
Created 03/05/2024


*/



