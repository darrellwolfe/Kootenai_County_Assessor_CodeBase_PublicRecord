-- !preview conn=conn
/*
AsTxDBProd
GRM_Main
,mAcquisitionDate
,mAcquisitionValue
,mAppraisedValue
,mDescription
    
    SELECT *
FROM tPPAccount

*/

--CTE_Allocations AS (
Select DISTINCT
a.lrsn
,a.extension
,e.ext_description
,a.improvement_id
,a.land_line_number
,i.imp_type
,a.group_code
,c.tbl_element_desc AS CodeDescription


From TSBv_PARCELMASTER AS pm
-- Join a to pm for active parcels only
Join allocations AS a 
  On a.lrsn = pm.lrsn
  And a.status='A'
  --And a.group_code IN ('98','99')

--Join e to i
Join extensions AS e
  On e.lrsn = a.lrsn
  And e.extension = a.extension
  And e.status = 'A'
--Join i to a
Left Join improvements AS i
  On a.lrsn=i.lrsn 
  And a.extension = i.extension
  And i.improvement_id = a.improvement_id
  And i.status = 'A'

-- Join a to c
Left Join codes_table AS c
  On a.group_code = c.tbl_element
  And c.code_status = 'A' 
  And tbl_type_code= 'impgroup'
  
Where pm.EffStatus = 'A'
--And a.group_code IN ('98','99')
--)

--Order by a.group_code
