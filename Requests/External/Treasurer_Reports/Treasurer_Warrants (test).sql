/*
AsTxDBProd
GRM_Main
As a test, the LRSN/AIN that DeeAnn and I used was:
LRSN 49006
AIN 186888
*/

-----------------------------------
--START HERE
-----------------------------------

--Begins CTEs
WITH 
------------
-- Only most recent description header. 
-- For an unknown reason, there are sometimes two active headers.
------------
CTE_DescrHeader AS (
    SELECT
        dh.Id,
        dh.BegEffDate,
        dh.TranId,
        dh.RevObjId,
        dh.DescrHeaderType,
        dh.DisplayDescr,
        ROW_NUMBER() OVER (PARTITION BY dh.RevObjId ORDER BY dh.BegEffDate DESC) AS RowNum
    FROM DescrHeader AS dh
    WHERE dh.EffStatus = 'A'
),

CTE_MFDetails AS (
  Select
    e.lrsn,
    --Year, Vin, Make, if applicable
    i.year_built AS [YearBuilt],
    LTRIM(RTRIM(mh.mh_serial_num)) AS [VIN],
    LTRIM(RTRIM(ct.tbl_element_desc)) AS [Make]
  
  --Extensions always comes first
  From extensions AS e --ON kcv.lrsn=e.lrsn
  
  --Extensions linkes to improvements on lrsn AND extension
  JOIN improvements AS i ON e.lrsn=i.lrsn 
        AND e.extension=i.extension
        AND i.status='A'
        AND i.improvement_id='M'
  --manuf_housing, comm_bldg, dwellings all must be after e and i
  LEFT JOIN manuf_housing AS mh ON i.lrsn=mh.lrsn 
        AND i.extension=mh.extension
        AND mh.status='A'
    Join codes_table AS ct ON mh.mh_make=ct.tbl_element 
      AND ct.tbl_type_code='mhmake'
  
  Where e.status = 'A'
  
),

CTE_FncDetails AS (
--Summary by Year Level, but off ten cents
  SELECT
      RevObjId,
      TaxBillId,
      TaxYear,
      CAST(SUM(TaxAmount) AS decimal(18, 2)) AS [NetTax],
      CAST(SUM(IntAmount) AS decimal(18, 2)) AS [Interest],
      CAST(SUM(PenAmount) AS decimal(18, 2)) AS [Penalty],
      CAST(SUM(FeeAmount) AS decimal(18, 2)) AS [Fees],
      CAST(SUM(TaxAmount + PenAmount + IntAmount + FeeAmount + DiscAmount) AS decimal(18, 2)) AS [Total]
  FROM eGovFD_T
  --WHERE RevObjId = '49006' -- Test parcel LRSN 49006 AIN 186888
  GROUP BY
      RevObjId,
      TaxBillId,
      TaxYear
  --ORDER BY TaxYear DESC      
)


----Main Query Starts Here with Select

SELECT DISTINCT
  --Demographics
  LTRIM(RTRIM(kcv.ain)) AS [AIN], 
  LTRIM(RTRIM(kcv.pin)) AS [PIN], 
  LTRIM(RTRIM(pb.OwnerName1)) AS [Owner],
  LTRIM(RTRIM(pb.OwnerName2)) AS [AltOwner],
  LTRIM(RTRIM(kcv.AttentionLine)) AS [Comm_Attn],
  LTRIM(RTRIM(kcv.MailingAddress)) AS [MailingAddress],
  LTRIM(RTRIM(kcv.MailingCityStZip)) AS [Mailing_CSZ],
  LTRIM(RTRIM(pb.OwnerCountry)) AS [OwnerCountry],
  LTRIM(RTRIM(kcv.SitusAddress)) AS [SitusAddress],
--  LTRIM(RTRIM(kcv.DisplayDescr)) AS [LegalDescription],
  dd.DisplayDescr AS [ParcelBase_LegalDesc],

--CTE Amounts (incomplete, still searching for these figures)
  fndl.TaxBillId,
  fndl.TaxYear,
  fndl.[NetTax],
  fndl.[Interest],
  fndl.[Penalty],
  fndl.[Fees],
  fndl.[Total],

--CTE --Year, Vin, Make, if applicable
  mfd.[YearBuilt],
  mfd.[VIN],
  mfd.[Make]


--From Tables and CTEs

FROM KCv_PARCELMASTER1 AS kcv 
JOIN parcel_base_data AS pb ON kcv.lrsn=pb.lrsn
  AND pb.status='A'
LEFT JOIN CTE_DescrHeader AS dd ON pb.lrsn=dd.RevObjId
  AND dd.RowNum = 1
LEFT JOIN CTE_MFDetails AS mfd ON kcv.lrsn=mfd.lrsn
LEFT JOIN CTE_FncDetails AS fndl ON kcv.lrsn=fndl.RevObjId
  AND fndl.[Total] > '0'
--Begin WHERE Clauses for Primary From Table

WHERE kcv.EffStatus='A'
AND kcv.pin NOT LIKE 'GENERAL PARCEL'
AND kcv.pin LIKE 'M%'
    OR kcv.pin LIKE 'L%'
    OR kcv.pin LIKE 'G%'
    OR kcv.pin LIKE 'E%'
    OR (kcv.pin LIKE 'R%' AND kcv.DisplayDescr LIKE '%Golden Spike%')
    OR (kcv.pin LIKE 'U%' AND kcv.ClassCD='010 Operating Property')
    OR (kcv.pin LIKE '%' AND kcv.DisplayDescr LIKE '%PP On Real%')
  
--End with Order By
ORDER BY [PIN];
-----------------------------------
--STOP STOP STOP STOP STOP NOT BELOW THIS LINE
-----------------------------------









-------
--To be Explored, These came from Aumentum Support (Brenda Mabry <Brenda.Mabry@Aumentumtech.com>)
-- I'm not sure this helped. Hm...
-------
/*

From the Aumentum Explorer
Tax  year, tax roll, taxing authority, fund and bill number are required to link a payment to its charge.
The percent interest will be calculated when the numerator and denominator are available.
A PrimeLPId attribute value equal to the Id indicates the primary legal party name. PrimeLPId values not matching the Id are related names (e.g. aka, fka) and the type of related party is indicated by the AliasType attribute.



This pulls results that don't quite match Aumentum
RevObjId
TaxYear
NetTaxDue
49006
2022
328.37
49006
2018
0.94
This shows 0.94 owed in 2018, but aumentum shows zero.

--If you include TaxYear and Inst as columns, you will get the tax broken down by installment for the year
Select 
  fd.RevObjId,
  fd.TaxYear,
  --fd.Inst,
  SUM(fd.Amount) AS [NetTaxDue]

From FnclDetail AS fd

Where fd.RevObjId = 49006

  -- And TaxYear = 2022
Group By
  fd.RevObjId,
  fd.TaxYear
  --fd.Inst
HAVING SUM(fd.Amount) > 0

Order By TaxYear DESC


---------
-- FnclDetail table
--For the Amount Due for PIN 002200020040 aka fd.RevObjId = 129
---------
CTE_TotalNetTax AS (
Select 
  fd.RevObjId,
  SUM(fd.Amount) AS [NetTaxDue]
From FnclDetail AS fd
  --Where TaxYear = 2022
  --Where fd.RevObjId = 129
  -- And TaxYear = 2022
  --If you include TaxYear and Inst as columns, you will get the tax broken down by installment for the year
Group By
  fd.RevObjId
),

-- !preview conn=con

/*

WHERE column_name LIKE '%BillDateType%' -- Promising??

SELECT * FROM information_schema.columns 
WHERE column_name LIKE '%BillDateType%'
Order By table_name, column_name


--------------------------

WebIVRExp_T -- way old info
DistDetail -- Not it
DistFnclTotal -- Not it
PenIntChrgBase -- OLD
ChrgType -- No
BillDateType -- No
DelqFeeId_T -- Nope
DelqGroupObjV_V -- Not helpful
DelqFeeChrgType -- Blank table
DelqFeeRpt_T -- Blank table
DelqTaskDetail -- Blank
DelqReport_T -- Blank
GLTranDetail -- Maybe

FnclChrgSummary -- Blank table
FnclPmtSummary -- Blank table

SELECT * FROM information_schema.columns 
WHERE column_name LIKE '%PenAmount%';

eGovFD_T -- Very Promising
PaymentHdr -- Only gives payment history, not future owed
FnclChrgSummary -- Empty Table
FnclPmtSummary -- Empty
eGovFDRI_T --Empty
KCv_FnclDetail_Summary1_v -- no go
FLNapDetail_T -- empty table
PenIntChrgBase -- key table
PenIntRuleHeader -- key table
PenIntRuleRange -- key table

--Summary by Year Level, but off ten cents
SELECT
    RevObjId,
    TaxYear,
    CAST(SUM(TaxAmount) AS decimal(18, 2)) AS Tax,
    CAST(SUM(PenAmount) AS decimal(18, 2)) AS Pen,
    CAST(SUM(IntAmount) AS decimal(18, 2)) AS Ints,
    CAST(SUM(FeeAmount) AS decimal(18, 2)) AS Fee,
    CAST(SUM(DiscAmount) AS decimal(18, 2)) AS DiscA,
    CAST(SUM(TaxAmount + PenAmount + IntAmount + FeeAmount + DiscAmount) AS decimal(18, 2)) AS Total
FROM eGovFD_T
WHERE RevObjId = '49006'
GROUP BY
    RevObjId,
    TaxYear
ORDER BY
    TaxYear DESC


--Installment Level, but off ten cents
SELECT
*

FROM eGovFD_T
WHERE RevObjId = '49006'
ORDER BY
    TaxYear DESC


--------------------------
DefaultDate_T -- Maybe
DelqGrpDelqFee -- Maybe?
DelqGroupCrit --- Maybe?
BillDate -- Maybe? It shows Installent 1 v 2?


DelqGroup -- This is groups (Ex: 
2022 Delinquent Mobiles                                         
2022 Delinquent Floathomes                                      
2022 PMT DNP Certifications                                     
2020 Delinquent Real Property                                   
Etc... )

DelqGrpDelqFee -- Maybe?

DelqGroupRevObj -- RevObjId (lrsn), TaxYear, BillNumber, BillHeaderId

DelqFee -- DFType, Name
Name includes (Cost Fee, Sheriff Fee, Warrant Cost, etc.)

DelqFeeChrgType - Blank

DelqNoticeData
-- TaxBillId, TaxYear, NoticeDate, NoticeAmount

DelqWarrant
-- TranId, ObjectId,  WarrantYear, WarrantDate, ExperiationDate, WarrantNumber

DGDFRevObj -- Maybe?

CAGlobal -- Maybe?

ReceiptHeader -- Interesting?
Where BusDate > '2021-01-01'



*/



Select *
From
PenIntGroupHeader

--FnclHeader
--- Id, TranId, ProcessId

-- DelqGroupRevObj 
--- ON DelqGroupRevObj.DelqGroupId=DelqGroup.Id
--- DelqGroupId, RevObjId, BillHeaderId, TaxYear, BillNumber 
-- EffStatus = 'A'

-- DelqGroup
--- EffStatus = 'A', Id, Name, TaxYear







*/
---------
-- taxbill, TaxBillTran, taxBillValue, grm_records_RevObjByEffDate four table joins
--For the Amount Due for PIN 002200020040 aka fd.RevObjId = 129
--Test RevObjId 49006 PIN MKT000C00650 | LRSN 49006 |AIN 186888
---------
Select 
-- * 
tbt.RevObjId,
tbt.AcctId,
--rtrim(ro.PIN) AS [PIN], 
--rtrim(ro.AIN) AS [AIN],
tb.BillNumber,
tb.taxyear,
--Inst
--ro.Id, 
tv.ValueAmount,
tv.ValueTypeId
--sum(amount) AS bal 

From TaxBill AS tb
Join TaxBillTran AS tbt ON tb.id = tbt.TaxBillId
Join taxBillValue AS tv ON tv.TaxBillTranId = tbt.id
--Join grm_records_RevObjByEffDate(getdate(), NULL) AS ro ON ro.id = tbt.RevObjId

Where tb.BillNumber = '242668' and tb.taxyear = '2022'
-- TaxBill numbers recycle every year with different associated properties (which is crazy) so you have to combine the taxbill number AND year to get the right account.

--Where RevObjId = '49006




---------
-- FnclDetail table
--For the Amount Due for PIN 002200020040 aka fd.RevObjId = 129
--Test RevObjId 49006 PIN MKT000C00650 | LRSN 49006 |AIN 186888
---------

Select 
fd.RevObjId,
SUM(fd.Amount) AS [NetTaxDue]

From FnclDetail AS fd

Where TaxYear = 2022
--Where fd.RevObjId = 129
-- And TaxYear = 2022
Group By
 fd.RevObjId;

---------
-- FnclDetail & FnclTran tables
--For the Amount Due for PIN 002200020040 aka fd.RevObjId = 129
--Test RevObjId 49006 PIN MKT000C00650 | LRSN 49006 |AIN 186888
--Use the TafId to get the different values 
-- and then you can sum to get the total due, etc.
---------

Select *
-- fd.RevObjId AS [lrsn]
-- fd.AcctId AS [Rev Account],
-- fd.TaxYear
-- fd.AssessmentYear
-- fd.TAFId
-- fd.Amount
-- fd.Inst

From FnclDetail AS fd
Join FnclTran AS ft ON fd.FnclTranId = ft.id
Where fd.RevObjId = 49006
  --And TaxYear = 2022
  --And fd.CatType = 290085
  --And fd.TAFId = 469


---------
-- TAF & fund tables 
-- Cadaster Level stuff, not individual account stuff.
-- Rather, it will show you how a payment is broken down after it's paid
-- but I'm looking for total due, not where it goes. If I need this later, it's good to have. :) 
---------
--This will give you the amount for each type that is in the installments section                    
Select *
From TAF AS t
Join fund AS f on f.id = t.FundId
Where t.id = 469






/*

WHERE column_name LIKE '%BillDateType%' -- Promising??

SELECT * FROM information_schema.columns 
WHERE column_name LIKE '%BillDateType%'
Order By table_name, column_name


--------------------------

WebIVRExp_T -- way old info
DistDetail -- Not it
DistFnclTotal -- Not it
PenIntChrgBase -- OLD
ChrgType -- No
BillDateType -- No
DelqFeeId_T -- Nope
DelqGroupObjV_V -- Not helpful
DelqFeeChrgType -- Blank table
DelqFeeRpt_T -- Blank table
DelqTaskDetail -- Blank
DelqReport_T -- Blank
GLTranDetail -- Maybe

--------------------------
DefaultDate_T -- Maybe
DelqGrpDelqFee -- Maybe?
DelqGroupCrit --- Maybe?
BillDate -- Maybe? It shows Installent 1 v 2?


DelqGroup -- This is groups (Ex: 
2022 Delinquent Mobiles                                         
2022 Delinquent Floathomes                                      
2022 PMT DNP Certifications                                     
2020 Delinquent Real Property                                   
Etc... )

DelqGrpDelqFee -- Maybe?

DelqGroupRevObj -- RevObjId (lrsn), TaxYear, BillNumber, BillHeaderId

DelqFee -- DFType, Name
Name includes (Cost Fee, Sheriff Fee, Warrant Cost, etc.)

DelqFeeChrgType - Blank

DelqNoticeData
-- TaxBillId, TaxYear, NoticeDate, NoticeAmount

DelqWarrant
-- TranId, ObjectId,  WarrantYear, WarrantDate, ExperiationDate, WarrantNumber

DGDFRevObj -- Maybe?




*/


/*
--This will give you the amount for each type that is in the installments section                    

TAF ID	FundId	ShortDescr	Descr
62	52	90247           	WORLEY FIRE DISTRICT                                            
118	93	90410           	W SELTICE PF URD                                                
93	82	90299           	TWIN LAKES WATER DISTRICT                                       
96	85	90302           	TWIN LAKES REC SEWER DIST                                       
66	56	90252           	TIMBERLAKE FIRE DIST                                            
171	21	90100           	STATE OF IDAHO                                                  
65	55	90251           	ST MARIES FIRE DISTRICT                                         
490	148	90256           	ST MARIES FIRE BOND                                             
61	51	90246           	SPIRIT LAKE FIRE DISTRICT                                       
177	17	60181           	SOLID WASTE FEES                                                
508	154	90407           	SILVERADO URD                                                   
63	53	90249           	SHOSHONE FIRE PROTECTION DIST                                   
477	145	90234-SUPP      	SCHOOL DIST #44J-PLUMMER/WORLEY SUPP                            
479	147	90234-CO-OP     	SCHOOL DIST #44J-PLUMMER/WORLEY COOP                            
54	44	90234           	SCHOOL DIST #44J-PLUMMER/WORLEY                                 
475	146	90235-SUPP      	SCHOOL DIST #391J-KELLOGG SUPP                                  
55	45	90235           	SCHOOL DIST #391J-KELLOGG                                       
473	144	90233-SUPP      	SCHOOL DIST #274-KOOTENAI SUPP                                  
53	43	90233           	SCHOOL DIST #274-KOOTENAI                                       
471	143	90232-SUPP      	SCHOOL DIST #273-POST FALLS SUPP                                
52	42	90232           	SCHOOL DIST #273-POST FALLS                                     
469	142	90231-SUPP      	SCHOOL DIST #272-LAKELAND SUPP                                  
51	41	90231           	SCHOOL DIST #272-LAKELAND                                       
467	141	90230-SUPP      	SCHOOL DIST #271-CDA SUPP                                       
50	40	90230           	SCHOOL DIST #271-CDA                                            
144	98	90425           	RIVERBEND URD                                                   
12	14	46421           	REVALUATION                                                     
73	62	90279           	REMINGTON WATER DISTRICT                                        
505	151	90408           	RATHDRUM URD                                                    
60	50	90245           	RATHDRUM FIRE DISTRICT                                          
263	100	10004           	PROPERTY TAX RELIEF                                             
507	153	90402           	POST FALLS TECH URD                                             
59	49	90244           	POST FALLS FIRE DISTRICT                                        
134	99	90427           	POST FALLS EXPO URD                                             
97	86	90303           	PINEVIEW WATER ASSOCIATION                                      
92	81	90298           	PINEVIEW ESTATES WATER DIST                                     
509	156	90412           	PF URD-DOWNTOWN DISTRICT                                        
510	158	90413           	PF URD PLEASANT VIEW                                            
142	96	90417           	PF CENTER POINT URD                                             
9	11	35150           	PARKS & REC                                                     
83	72	90289           	OHIO MATCH WATER DIST                                           
6	8	32160           	NOXIOUS WEEDS                                                   
68	58	90254           	NORTHERN LAKES FIRE DIST                                        
94	83	90300           	NORTH KOOTENAI WATER DIST                                       
100	89	90351           	NORTH IDAHO COLLEGE                                             
67	57	90253           	MICA KIDD ISLAND FIRE DIST                                      
2	3	13053           	LIABILITY INSURANCE                                             
75	64	90281           	KOOTENAI WATER DISTRICT                                         
131	61	90273           	KOOTENAI LIBRARY-BOND                                           
56	46	90240           	KOOTENAI FIRE DISTRICT #1                                       
103	16	47179           	KOOTENAI EMSS-AMBULANCE                                         
70	60	90271           	KOOTENAI CONSOLIDATED LIBRARY                                   
205	2	10301           	KOOTENAI CO TREASURER                                           
206	5	15601           	KOOTENAI CO JUSTICE FUND                                        
69	59	90255           	KOOTENAI CO FIRE & RESCUE                                       
102	15	47173           	KOOTENAI CO EMS 47173                                           
101	90	90352           	KOOTENAI  HOSPITAL DISTRICT                                     
79	68	90285           	KINGSTON-CATALDO SEWER DIST                                     
78	67	90284           	KIDD ISLAND BAY SEWER DIST                                      
3	4	15003           	JUSTICE FUND                                                    
10	12	40245           	INDIGENT                                                        
451	140	90228-DIST-OTHER	HW#3-DIST-OTHER                                                 
8	10	34175           	HISTORICAL SOCIETY                                              
7	9	33174           	HEALTH UNIT                                                     
495	150	90229-TORT      	HD#4-WORLEY-TORT                                                
284	107	90229-SP BRDG   	HD#4-WORLEY-SPECIAL BRIDGE                                      
49	39	90229-M&O       	HD#4-WORLEY-M&O                                                 
425	134	90229-DIST-SP BR	HD#4-DIST-SPECIAL BRIDGE                                        
426	135	90229-DIST-M&O  	HD#4-DIST-M&O                                                   
424	133	90229-CDA-M&O   	HD#4-CDA-M&O                                                    
419	132	90228-HRISON-M&O	HD#3-HARRISON-M&O                                               
411	131	90228-FERNAN-M&O	HD#3-FERNAN-M&O                                                 
282	106	90228-TORT      	HD#3-EASTSIDE-TORT                                              
281	105	90228-SP BRDG   	HD#3-EASTSIDE-SPECIAL BRIDGE                                    
46	38	90228-M&O       	HD#3-EASTSIDE-M&O                                               
404	137	90228-DIST-TORT 	HD#3-DIST-TORT                                                  
402	126	90228-DIST-SP BR	HD#3-DIST-SPECIAL BRIDGE                                        
410	130	90228-DIST-M&O  	HD#3-DIST-M&O                                                   
401	125	90228-CDA-M&O   	HD#3-CDA-M&O                                                    
393	124	90227-SP LK-M&O 	HD#2-SPIRIT LAKE-M&O                                            
385	123	90227-RTHDRM-M&O	HD#2-RATHDRUM-M&O                                               
278	104	90227-TORT      	HD#2-LAKES HWY-TORT                                             
277	103	90227-SP BRDG   	HD#2-LAKES HWY-SPECIAL BRIDGE                                   
42	37	90227-M&O       	HD#2-LAKES HWY-M&O                                              
369	121	90227-HAYDEN-M&O	HD#2-HAYDEN-M&O                                                 
377	122	90227-HY LK-M&O 	HD#2-HAYDEN LAKE-M&O                                            
372	129	90227-DIST-TORT 	HD#2-DIST-TORT                                                  
370	127	90227-DIST-SP BR	HD#2-DIST-SPECIAL BRIDGE                                        
371	128	90227-DIST-M&O  	HD#2-DIST-M&O                                                   
361	120	90227-DALTON-M&O	HD#2-DALTON-M&O                                                 
353	119	90227-CDA-M&O   	HD#2-CDA-M&O                                                    
345	118	90227-ATHOL-M&O 	HD#2-ATHOL-M&O                                                  
340	117	90225-ST LN-M&O 	HD#1-STATE LINE-M&O                                             
332	116	90225-RTHDRM-M&O	HD#1-RATHDRUM-M&O                                               
274	102	90225-TORT      	HD#1-POST FALLS-TORT                                            
273	101	90225-SP BRDGE  	HD#1-POST FALLS-SPECIAL BRIDGE                                  
34	36	90225-PF-M&O    	HD#1-POST FALLS-M&O                                             
316	114	90225-HEUTER-M&O	HD#1-HEUTTER-M&O                                                
308	113	90225-HAYDEN-M&O	HD#1-HAYDEN-M&O                                                 
300	112	90225-HSR LK-M&O	HD#1-HAUSER LK-M&O                                              
299	111	90225-DIST-TORT 	HD#1-DIST-TORT                                                  
297	109	90225-DIST-SP BR	HD#1-DIST-SPECIAL BRIDGE                                        
298	110	90225-DIST-M&O  	HD#1-DIST-M&O                                                   
289	108	90225-CDA-M&O   	HD#1-CDA-M&O                                                    
493	149	90345           	HAYDEN LK WTRSHD IMP                                            
77	66	90283           	HAYDEN LAKE REC SEWER DIST                                      
58	48	90243           	HAYDEN LAKE FIRE DIST                                           
57	47	90242           	HAUSER LAKE FIRE DIST                                           
98	87	90304           	HARBOR VW EST W&S DIST                                          
90	79	90296           	HACKNEY WATER/SEWER DIST                                        
82	71	90288           	GREEN FERRY WATER/SEWER DIST                                    
95	84	90301           	FLOOD CONTROL DISTRICT #17                                      
64	54	90250           	EASTSIDE FIRE DISTRICT                                          
107	94	90411           	EAST POST FALLS URD                                             
81	70	90287           	DRY ACRES WATER/SEWER DIST                                      
99	88	90350           	DRAINAGE DISTRICT #1                                            
11	13	45251           	DISTRICT COURT                                                  
180	18	80513           	DEL 3% YIELD TRUST                                              
181	20	80562           	DEFERRED TAX TRUST                                              
91	80	90297           	DALTON IRRIGATION DIST                                          
1	1	10003           	CURRENT EXPENSE                                                 
5	7	31171           	COUNTY FAIR                                                     
506	152	90401           	COEUR D ALENE ATLAS URD                                         
176	19	80515           	CO SPEC ASSESSMENT TRUST                                        
76	65	90282           	CLELAND BAY SEWER DIST                                          
26	35	90214           	CITY OF WORLEY                                                  
25	34	90213           	CITY OF STATE LINE                                              
24	33	90212           	CITY OF SPIRIT LAKE                                             
23	32	90211           	CITY OF RATHDRUM                                                
22	31	90210           	CITY OF POST FALLS                                              
21	30	90209           	CITY OF HUETTER                                                 
20	29	90208           	CITY OF HAYDEN LAKE                                             
19	28	90207           	CITY OF HAYDEN                                                  
18	27	90206           	CITY OF HAUSER LAKE                                             
17	26	90205           	CITY OF HARRISON                                                
16	25	90204           	CITY OF FERNAN LAKE                                             
15	24	90203           	CITY OF DALTON GARDENS                                          
14	23	90202           	CITY OF COEUR D' ALENE                                          
13	22	90201           	CITY OF ATHOL                                                   
140	97	90420           	CDA URD AGENCY                                                  
105	92	90409           	CDA RIVERVIEW URD                                               
74	63	90280           	CATALDO WATER DISTRICT                                          
80	69	90286           	BAYVIEW WATER/SEWER DIST                                        
444	138	49179           	Aquifer Protection District                                     
4	6	30101           	AIRPORT                                                         
134	99	90427           	90427                                                           
144	98	90425           	90425                                                           
140	97	90420           	90420                                                           
142	96	90417           	90417                                                           
130	95	90415           	90415                                                           
107	94	90411           	90411                                                           
118	93	90410           	90410                                                           
105	92	90409           	90409                                                           
104	91	90400           	90400                                                           
101	90	90352           	90352                                                           
100	89	90351           	90351                                                           
99	88	90350           	90350                                                           
98	87	90304           	90304                                                           
97	86	90303           	90303                                                           
96	85	90302           	90302                                                           
95	84	90301           	90301                                                           
94	83	90300           	90300                                                           
93	82	90299           	90299                                                           
92	81	90298           	90298                                                           
91	80	90297           	90297                                                           
90	79	90296           	90296                                                           
89	78	90295           	90295                                                           
88	77	90294           	90294                                                           
87	76	90293           	90293                                                           
86	75	90292           	90292                                                           
85	74	90291           	90291                                                           
84	73	90290           	90290                                                           
83	72	90289           	90289                                                           
82	71	90288           	90288                                                           
81	70	90287           	90287                                                           
80	69	90286           	90286                                                           
79	68	90285           	90285                                                           
78	67	90284           	90284                                                           
77	66	90283           	90283                                                           
76	65	90282           	90282                                                           
75	64	90281           	90281                                                           
74	63	90280           	90280                                                           
73	62	90279           	90279                                                           
131	61	90273           	90273                                                           
70	60	90271           	90271                                                           
69	59	90255           	90255                                                           
68	58	90254           	90254                                                           
67	57	90253           	90253                                                           
66	56	90252           	90252                                                           
65	55	90251           	90251                                                           
64	54	90250           	90250                                                           
63	53	90249           	90249                                                           
62	52	90247           	90247                                                           
61	51	90246           	90246                                                           
60	50	90245           	90245                                                           
59	49	90244           	90244                                                           
58	48	90243           	90243                                                           
57	47	90242           	90242                                                           
56	46	90240           	90240                                                           
55	45	90235           	90235                                                           
54	44	90234           	90234                                                           
53	43	90233           	90233                                                           
52	42	90232           	90232                                                           
51	41	90231           	90231                                                           
50	40	90230           	90230                                                           
49	39	90229           	90229                                                           
46	38	90228           	90228                                                           
42	37	90227           	90227                                                           
34	36	90225           	90225                                                           
26	35	90214           	90214                                                           
25	34	90213           	90213                                                           
24	33	90212           	90212                                                           
23	32	90211           	90211                                                           
22	31	90210           	90210                                                           
21	30	90209           	90209                                                           
20	29	90208           	90208                                                           
19	28	90207           	90207                                                           
18	27	90206           	90206                                                           
17	26	90205           	90205                                                           
16	25	90204           	90204                                                           
15	24	90203           	90203                                                           
14	23	90202           	90202                                                           
13	22	90201           	90201                                                           
171	21	90100           	90100                                                           
181	20	80562           	80562                                                           
176	19	80515           	80515                                                           
180	18	80513           	80513                                                           
177	17	60181           	60181                                                           
130	95	90415           	4TH AVENUE POST FALLS URD                                       
103	16	47179           	47179                                                           
102	15	47173           	47173                                                           
12	14	46421           	46421                                                           
11	13	45251           	45251                                                           
10	12	40245           	40245                                                           
9	11	35150           	35150                                                           
8	10	34175           	34175                                                           
7	9	33174           	33174                                                           
6	8	32160           	32160                                                           
5	7	31171           	31171                                                           
4	6	30101           	30101                                                           
206	5	15601           	15601                                                           
3	4	15003           	15003                                                           
2	3	13053           	13053                                                           
205	2	10301           	10301                                                           
1	1	10003           	10003                                                           




*/
