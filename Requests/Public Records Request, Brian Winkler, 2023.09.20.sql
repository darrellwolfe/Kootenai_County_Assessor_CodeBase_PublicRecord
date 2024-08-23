
DECLARE @Year INT = 20230101;

WITH 
--------------------------
-- Pulls in only parcels with an improvement 
-- C - Commercial, D - Residential Dwelling, M - Manufactered Home
-- By filtering for these, automatically exlcudes pole barns and other improvements.
-- H Historical Value of most recent tax year, pulls in certified fixtures
-- A pulls in current active worksheet data
--------------------------
CTE_Improvement AS (
    SELECT
      e.lrsn
    , e.ext_id
    , e.extension
    , e.ext_description
    , i.improvement_id
    , i.imp_type
    , grades.tbl_element_desc AS Grade
    , i.year_built
    , i.year_remodeled
    , i.eff_year_built
    
    , dw.dwelling_number
    , dw.mkt_house_type
    , htyp.tbl_element_desc AS HouseType
    , dw.bedrooms
    , dw.family_rooms
    , dw.dining_rooms
    , dw.story_height

    , dw.full_baths
    , dw.half_baths
    
    , cb.bldg_section
    , cb.mkt_bldg_type
    , cu.use_code AS Commercial_Use_Code
    
    , mh.mh_make
    , make.tbl_element_desc AS MH_Make_Desc
    , mh.mh_model
    , model.tbl_element_desc AS MH_Model_Desc
    , mh.mh_serial_num
    , mh.mhpark_code
    , park.tbl_element_desc AS MH_Park_Desc
    
    FROM extensions AS e -- ON e.lrsn --lrsn link if joining this to another query
      -- AND e.status = 'A' -- Filter if joining this to another query
    JOIN improvements AS i ON e.lrsn=i.lrsn 
          AND e.extension=i.extension
          AND i.status='A'
          AND i.improvement_id IN ('M','C','D')
        --need codes to get the grade name, vs just the grade code#
        LEFT JOIN codes_table AS grades ON i.grade = grades.tbl_element
          AND grades.tbl_type_code='grades'
          
    --manuf_housing, comm_bldg, dwellings all must be after e and i
    
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
      AND e.eff_year = @Year
  
),

-----------------
-- CTEs for SF come from various tables depending on type of building
----------------
CTE_ResBldgSF AS (
  SELECT
    lrsn
,   extension
,   SUM(finish_living_area) AS ResBldg_SF
  FROM res_floor
  WHERE status = 'A'
  GROUP BY lrsn, extension
),

CTE_ManBldgSF AS (
  SELECT
    e.lrsn
,   e.extension
,   SUM(i.imp_size) AS MH_SF
  FROM extensions AS e --ON kcv.lrsn=e.lrsn
  --AND e.status = 'A'
    JOIN improvements AS i ON e.lrsn=i.lrsn 
      AND e.extension=i.extension
      AND i.status='A'
      AND i.improvement_id IN ('M')
      --('M','','')
  WHERE e.status = 'A'
  GROUP BY e.lrsn, e.extension
),

CTE_CommBldgSF AS (
  SELECT
     lrsn
    , extension
    , SUM(area) AS CommSF
  FROM comm_uses
  WHERE status = 'A'
  GROUP BY lrsn, extension
)

-- END CTE


SELECT DISTINCT
  --------------------------------
  --FROM ParcelMaster
  --------------------------------
  pm.lrsn
, CASE
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
, pm.neighborhood AS GEO
, TRIM(pm.NeighborHoodName) AS GEO_Name
, pm.pin AS PIN
, pm.AIN
, pm.ClassCD
, TRIM(pm.PropClassDescr) AS Property_Class_Type
, CASE 
    WHEN pm.ClassCD IN ('010', '020', '021', '022', '030', '031', '032', '040', '050', '060', '070', '080', '090') THEN 'Business_Personal_Property'
    WHEN pm.ClassCD IN ('314', '317', '322', '336', '339', '343', '413', '416', '421', '435', '438', '442', '451', '527') THEN 'Commercial_Industrial'
    WHEN pm.ClassCD IN ('411', '512', '515', '520', '534', '537', '541', '546', '548', '549', '550', '555', '565') THEN 'Residential'
    WHEN pm.ClassCD IN ('441', '525', '690') THEN 'Mixed_Use_Residential_Commercial'
    WHEN pm.ClassCD = '667' THEN 'Operating_Property'
    WHEN pm.ClassCD = '681' THEN 'Exempt_Property'
    ELSE NULL
  END AS Property_Type_Class
, TRIM(pm.TAG) AS TAG
, pm.pin AS PIN
, pm.AIN
, TRIM(pm.DisplayName) AS Owner --< This would be the Business Name for Commercial Accounts
, TRIM(pm.SitusAddress) AS SitusAddress
, TRIM(pm.SitusCity) AS SitusCity
, TRIM(pm.SitusState) AS SitusState
, TRIM(pm.SitusZip) AS SitusZip
, TRIM(pm.CountyNumber) AS CountyNumber
, CASE
    WHEN pm.CountyNumber = '28' THEN 'Kootenai_County'
    ELSE NULL
  END AS County_Name
,  pm.LegalAcres
,  pm.Improvement_Status -- <-- Improved vs Vacant
  --------------------------------
  --Join Property Information CTE
  --------------------------------
, imp.extension
, imp.ext_description
, imp.improvement_id-- C - Commercial, D - Residential Dwelling, M - Manufactered Home
, imp.imp_type
, imp.Grade
, imp.year_built
, imp.year_remodeled
, imp.eff_year_built
, imp.dwelling_number
, imp.mkt_house_type
, imp.HouseType
, imp.story_height
, imp.family_rooms
, imp.dining_rooms
, imp.bedrooms
, imp.full_baths
, imp.half_baths
, imp.bldg_section
, imp.mkt_bldg_type
, imp.Commercial_Use_Code
, imp.mh_make
, imp.MH_Make_Desc
, imp.mh_model
, imp.MH_Model_Desc
, imp.mh_serial_num
, imp.mhpark_code
, imp.MH_Park_Desc
, resf.ResBldg_SF
, mhsf.MH_SF
, comsf.CommSF


--Tables

FROM TSBv_PARCELMASTER AS pm

LEFT JOIN CTE_Improvement AS imp ON imp.lrsn = pm.lrsn

LEFT JOIN CTE_ResBldgSF AS resf ON resf.lrsn = imp.lrsn
  AND resf.extension = imp.extension

LEFT JOIN CTE_ManBldgSF AS mhsf ON mhsf.lrsn = imp.lrsn
  AND mhsf.extension = imp.extension

LEFT JOIN CTE_CommBldgSF AS comsf ON comsf.lrsn = imp.lrsn
  AND comsf.extension = imp.extension


WHERE pm.EffStatus = 'A'
    --AND pm.ClassCD NOT LIKE '010%'
    --AND pm.ClassCD NOT LIKE '020%'
    --AND pm.ClassCD NOT LIKE '021%'
    --AND pm.ClassCD NOT LIKE '022%'
    --AND pm.ClassCD NOT LIKE '030%'
    --AND pm.ClassCD NOT LIKE '031%'
    --AND pm.ClassCD NOT LIKE '032%'
    AND pm.ClassCD NOT LIKE '060%'
    AND pm.ClassCD NOT LIKE '070%'
    AND pm.ClassCD NOT LIKE '090%'

--AND pm.lrsn = 65547 --< Only to test parcels for query integrity

GROUP BY
  pm.lrsn
, pm.pin
, pm.AIN
, pm.ClassCD
, pm.PropClassDescr
, pm.neighborhood
, pm.NeighborHoodName
, pm.TAG
, pm.DisplayName
, pm.SitusAddress
, pm.SitusCity
, pm.SitusState
, pm.SitusZip
, pm.CountyNumber
, pm.LegalAcres
, pm.Improvement_Status
, imp.extension
, imp.ext_description
, imp.improvement_id
, imp.imp_type
, imp.Grade
, imp.year_built
, imp.year_remodeled
, imp.eff_year_built
, imp.dwelling_number
, imp.mkt_house_type
, imp.HouseType
, imp.bedrooms
, imp.full_baths
, imp.half_baths
, imp.bldg_section
, imp.mkt_bldg_type
, imp.Commercial_Use_Code
, imp.mh_make
, imp.MH_Make_Desc
, imp.mh_model
, imp.MH_Model_Desc
, imp.mh_serial_num
, imp.mhpark_code
, imp.MH_Park_Desc
, imp.family_rooms
, imp.dining_rooms
, imp.story_height
, resf.ResBldg_SF
, mhsf.MH_SF
, comsf.CommSF

ORDER BY District, GEO, pm.AIN;

