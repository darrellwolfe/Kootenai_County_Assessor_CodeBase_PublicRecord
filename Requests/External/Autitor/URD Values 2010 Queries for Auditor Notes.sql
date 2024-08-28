
/*
AsTxDBProd
GRM_Main
*/




----------------------------------
--Current Iteration 07/11/2023 DGW CadValue Only
----------------------------------

Select
AssessmentYear,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Incr]

From CadValueTypeAmount_V AS cv 

Where cv.AssessmentYear IN ('2010')
AND cv.CadRollId IN ('315','316','317')
-- AND ValueTypeShortDescr = 'URD Total Incr'

Group By 
AssessmentYear,
SecondaryAttribute

Order by CadRollId, SecondaryAttribute;




/*
Notes
---
Roll Type	CadRollId	RollDescription	What is that really?
1st	281	2010 Personal Property Assessment Roll 1	PP1 Annual Personal Property
1st	279	2010 Real Property Assessment Roll 1	RP1 Annual Real Property
---
2nd	312	2010 OPT Assessment Roll 	Operating Property
---
2nd	315	2010 Late2 	PP2 - Set up wrong??
2nd	316	2010 Transient Assessment Roll 1	PP2 "Transient" Personal Property Roll (2nd Roll for PP)
2nd	317	2010 Late3 	Missed Property Roll PP3
*/



----------------------------------
--Current Iteration 07/11/2023 DGW WITHOUT PINs
----------------------------------

SELECT 
--CadRoll Columns
r.Id AS [CadRollId], r.AssessmentYear, r.Descr AS [RollType],
--CadLevel Columns
l.Id AS [CadLevelId], l.CreateLevelDate, l.LastBuildDate, l.StatusDate,
--CadInv (CadInventory) Columns
--Nothing from CadInv
--CadValueTypeAmount_V Columns
cv.AssessmentYear AS [CadValueAssessmentYear],
cv.CadRollDescr AS [CadValueRollDesc],
cv.ValueTypeShortDescr,
cv.ValueTypeDescr,
cv.SecondaryAttribute,
cv.ValueAmount

FROM CadRoll AS r
JOIN CadLevel AS l ON r.Id = l.CadRollId
JOIN CadInv AS i ON l.Id = i.CadLevelId
JOIN CadValueTypeAmount_V AS cv 
  ON i.Id=cv.CadInvId
  AND i.RevObjId = cv.RevObjId
  AND l.Id=cv.CadLevelId	
  AND r.Id=cv.CadRollId	

WHERE r.AssessmentYear IN ('2010')
AND cv.AssessmentYear IN ('2010')
AND cv.ValueTypeShortDescr = 'URD Total Incr'




----------------------------------
--Current Iteration 07/11/2023 DGW With PINs
----------------------------------

SELECT 
--CadRoll Columns
r.Id AS [CadRollId], r.AssessmentYear, r.Descr AS [RollType],
--CadLevel Columns
l.Id AS [CadLevelId], l.CreateLevelDate, l.LastBuildDate, l.StatusDate,
--CadInv (CadInventory) Columns
i.Id AS [CadInvId], i.PIN, i.AIN, i.GeoCd, i.TAGDescr AS TAG,
--CadValueTypeAmount_V Columns
cv.AssessmentYear AS [CadValueAssessmentYear],
cv.CadRollDescr AS [CadValueRollDesc],
cv.ValueTypeShortDescr,
cv.ValueTypeDescr,
cv.SecondaryAttribute,
cv.ValueAmount

FROM CadRoll AS r
JOIN CadLevel AS l ON r.Id = l.CadRollId
JOIN CadInv AS i ON l.Id = i.CadLevelId
JOIN CadValueTypeAmount_V AS cv 
  ON i.Id=cv.CadInvId
  AND i.RevObjId = cv.RevObjId
  AND l.Id=cv.CadLevelId	
  AND r.Id=cv.CadRollId	

WHERE r.AssessmentYear IN ('2010')
AND cv.AssessmentYear IN ('2010')
AND cv.ValueTypeShortDescr = 'URD Total Incr'






----------------------------------
--Current Iteration 07/11/2023 DGW CadValues Table ALL
----------------------------------


Select
*

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Incr'

Order By
CadRollDescr


----------------------------------
--URD Total Incr SUM by TIF
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Incr]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Incr'

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute

Order By
CadRollDescr



































------------------------------------------------------------------------------------------------------
--Below this line is previous attempts,saving for reference
------------------------------------------------------------------------------------------------------


----------------------------------
--URD Base Total
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Base]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Base'

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute

Order By
CadRollDescr

----------------------------------
--URD Total Incr
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Incr]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Incr'

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute

Order By
CadRollDescr


----------------------------------
--Total_Assessed_Value
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr,
SUM (ValueAmount) AS [Total_Assessed_Value]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'Total Value'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr

Order By
CadRollDescr



----------------------------------
--Net Tax Value
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr,
SUM (ValueAmount) AS [Net_Tax_Value]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'Net Tax Value'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr

Order By
CadRollDescr


---------------------------------
--Net Tax Value 2.0
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr,
SUM (ValueAmount) AS [Net_Tax_Value]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'Net Tax Value'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr

Order By
CadRollDescr


----------------------------------
--Total_Assessed_Value 2.0
----------------------------------
Select
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr,
SUM (ValueAmount) AS [Total_Assessed_Value]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'Total Value'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')

Group By 
AssessmentYear,
CadRollDescr,
ValueTypeShortDescr,
ValueTypeDescr,
SecondaryAttribute,
TAGDescr

Order By
CadRollDescr



----------------------------------
--URD Base Total
----------------------------------
Select
AssessmentYear,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Base]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Base'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')


Group By 
AssessmentYear,
SecondaryAttribute

Order By
SecondaryAttribute

----------------------------------
--URD Total Incr 2.0
----------------------------------
Select
AssessmentYear,
SecondaryAttribute,
SUM (ValueAmount) AS [URD_Total_Incr]

From CadValueTypeAmount_V

WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'URD Total Incr'
AND CadRollDescr IN ('2010 Late2','2010 Late3','2010 OPT Assessment Roll','2010 Transient Assessment Roll 1')


Group By 
AssessmentYear,
SecondaryAttribute

Order By
SecondaryAttribute


/*

----------------------------------
-- NOTES AND DISCOVERY
----------------------------------



Total Exemptions
Total Value
Net Tax Value

UR_BaseByCat
UR_IncrByCat
URD Total Base
URD Total Incr

Select Distinct
cv.ValueTypeShortDescr,
cv.ValueTypeDescr

FROM CadValueTypeAmount_V AS cv -- ON pm.lrsn = cv.RevObjId
WHERE cv.AssessmentYear IN ('2010')
Order by cv.ValueTypeShortDescr;

SELECT * FROM information_schema.columns 
WHERE table_name LIKE 'TIF%';

SELECT * FROM information_schema.columns 
WHERE column_name LIKE 'TaxCalcDetail%';

Select *
From TIFSummaryRpt
WHERE AssessmentYear IN ('2010')
AND ValueTypeShortDescr = 'SupValCat'

TIF_KC_V
TIF_V
TIFDetailRpt
TIFRole
TIFSummaryRpt
TIFTaxAuth_V
TIFTRDValues_T
TIFValueType


Column: SourceValueType
ValueTypeCalc
TaxCalcDetail

Select *
From TaxCalcDetail
Where TIFId <> '0'

Select *
From CadInv

Where CadLevelId IN ('312','315','316','317')



Select *
From CadLevel

Where CadRollId IN ('312','315','316','317')
And CadLevel IN ('312','315','316','317')

Select *
From CadRoll
--2010
Where CadRoll.Id IN ('312','315','316','317')

2nd
315	2010 Late2  PP2
317	2010 Late3  Missed Property

316	2010 Transient Assessment Roll 1

312	2010 OPT Assessment Roll 


1st
281	2010 Personal Property Assessment Roll 1
279	2010 Real Property Assessment Roll 1

Select *
From valuetypeamount vta 
Where vta.headertype=100153

--ON vta.headertype=100153 AND vta.headerid=ci.id
	--	AND vta.addlobjectid NOT IN (--1200355,

SELECT * FROM information_schema.columns 
WHERE column_name LIKE 'type%';


Select *
From Type

SELECT * FROM "GRM_Main"."dbo"."a_abstract_base"

SELECT * FROM information_schema.columns 
WHERE table_name LIKE 'TIF%';

SELECT * FROM information_schema.columns 
WHERE column_name LIKE 'TaxCalcDetail%';

KCv_CadValue_Export_v
CadValuesByTagRpt_T
KC_AumentumEasy_BalancingTaxAuthorityCadastreValues
KC_AumentumEasy_BalancingUrdCadastreValues
KC_MAP_cad_valtypeamount_cypy_v
KCv_CadValue_Export1a
CadValueError_T
KCv_CadValue_Export2a

SELECT * FROM information_schema.columns 
WHERE table_name LIKE '%Cad%'
AND  table_name LIKE '%val%'

Select *
From KC_AumentumEasy_BalancingUrdCadastreValues

Select *
From KC_AumentumEasy_BalancingTaxAuthorityCadastreValues
Where BalancingYear IN ('2021')

Select *
From KC_MAP_cad_valtypeamount_cypy_v




JOIN tagrole tgr ON tgr.id=ci.tagroleid AND tgr.begeffdate=ci.tagroledate

JOIN tag ON tag.id=ci.tagid AND tag.begeffyear=ci.tagyear

LEFT OUTER JOIN tifrole tr ON tr.objectid=ci.revobjid AND tr.objecttype=100002 
		AND tr.effstatus='A' AND tr.begeffdate=
		(SELECT MAX(tr_sub.begeffdate) FROM tifrole tr_sub WHERE tr_sub.id=tr.id
			 AND tr_sub.begeffdate < '01-02-' + CAST(@EffYear AS VARCHAR(4)))

LEFT OUTER JOIN tif ON tif.id=tr.tifid AND tif.effstatus='A' AND tif.begeffyear=





*/

