-- !preview conn=con



 /*
AsTxDBProd
GRM_Main

LTRIM(RTRIM())
*/

----------------------------------
-- View/Master Query: Always e > i > then finally mh, cb, dw
----------------------------------
Select Distinct
--Extensions Table
e.lrsn,
LTRIM(RTRIM(pm.pin)) AS [PIN],
LTRIM(RTRIM(pm.AIN)) AS [AIN],
pm.neighborhood AS [GEO],
LTRIM(RTRIM(pm.NeighborHoodName)) AS [GEO_Name],
LTRIM(RTRIM(pm.PropClassDescr)) AS [ClassCD],
LTRIM(RTRIM(pm.TAG)) AS [TAG],
LTRIM(RTRIM(pm.DisplayName)) AS [Owner],
LTRIM(RTRIM(pm.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(pm.SitusCity)) AS [SitusCity],
pm.WorkValue_Land,
pm.WorkValue_Impv,
pm.WorkValue_Total,
e.extension,
e.ext_description,
e.data_collector,
e.collection_date,
e.appraiser,
e.appraisal_date,

--Improvements Table
  --codes_table 
  --AND park.tbl_type_code='grades'
i.imp_type,
i.year_built,
i.eff_year_built,
i.year_remodeled,
i.condition,
i.grade AS [GradeCode], -- is this a code that needs a key?
grades.tbl_element_desc AS [GradeType],

-- Residential Dwellings dw
  --codes_table
  -- AND htyp.tbl_type_code='htyp'  
dw.mkt_house_type,
htyp.tbl_element_desc AS [HouseTypeName],
dw.mkt_rdf AS [RDF], -- Relative Desirability Facotor (RDF), see ProVal, Values, Cost Buildup, under depreciation

--Commercial
cu.use_code,

--manuf_housing
    --codes_table 
    --AND make.tbl_type_code='mhmake'
    --AND model.tbl_type_code='mhmodel'    
    --AND park.tbl_type_code='mhpark'
mh.mh_make,
make.tbl_element_desc AS [MH_Make],
mh.mh_model,
model.tbl_element_desc AS [MH_Model],
mh.mh_serial_num AS [VIN],
mh.mhpark_code,
park.tbl_element_desc AS [MH_Park]

--Extensions always comes first
FROM extensions AS e -- ON e.lrsn --lrsn link if joining this to another query
  -- AND e.status = 'A' -- Filter if joining this to another query
JOIN improvements AS i ON e.lrsn=i.lrsn 
      AND e.extension=i.extension
      AND i.status='A'
      AND i.improvement_id IN ('M','C','D')
    --need codes to get the grade name, vs just the grade code#
    LEFT JOIN codes_table AS grades ON i.grade = grades.tbl_element
      AND grades.tbl_type_code='grades'
--ParcelMaster
JOIN TSBv_PARCELMASTER AS pm ON e.lrsn=pm.lrsn
--manuf_housing, comm_bldg, dwellings all must be after e and i
  AND pm.EffStatus = 'A'
  AND pm.ClassCD NOT LIKE '070%'

--COMMERCIAL      
LEFT JOIN comm_bldg AS cb ON i.lrsn=cb.lrsn 
      AND i.extension=cb.extension
      AND cb.status='A'
    LEFT JOIN comm_uses AS cu ON cb.lrsn=cu.lrsn
      AND cb.extension = cu.extension
      AND cu.status='A'
      
--RESIDENTIAL DWELLINGS
LEFT JOIN dwellings AS dw ON i.lrsn=dw.lrsn
      AND dw.status='A'
      AND i.extension=dw.extension
  LEFT JOIN codes_table AS htyp ON dw.mkt_house_type = htyp.tbl_element 
    AND htyp.tbl_type_code='htyp'  
     
--MANUFACTERED HOUSING
LEFT JOIN manuf_housing AS mh ON i.lrsn=mh.lrsn 
      AND i.extension=mh.extension
      AND mh.status='A'
  LEFT JOIN codes_table AS make ON mh.mh_make=make.tbl_element 
    AND make.tbl_type_code='mhmake'
  LEFT JOIN codes_table AS model ON mh.mh_model=model.tbl_element 
    AND model.tbl_type_code='mhmodel'
  LEFT JOIN codes_table AS park ON mh.mhpark_code=park.tbl_element 
    AND park.tbl_type_code='mhpark'
    

WHERE e.status = 'A'
--AND i.improvement_id IN ('M')
AND (pm.neighborhood IN ('1000','1020','5000','5002','6000','6002')
    OR pm.neighborhood >= '9000')



Order by [GEO], [PIN], e.extension;



