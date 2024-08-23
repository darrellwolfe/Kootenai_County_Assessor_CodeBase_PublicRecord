-- !preview conn=conn

/*
AsTxDBProd
GRM_Main

---------
--Select All
---------
Select Distinct *
From TSBv_PARCELMASTER AS pm
Where pm.EffStatus = 'A'

*/



--CTE_AllocationsGroupCodeKey AS (
SELECT 
c.tbl_type_code AS CodeType
,c.tbl_element AS GroupCode_KC
,LEFT(c.tbl_element,2) AS GroupCode_STC
,c.tbl_element_desc AS CodeDescription
,CASE 
    WHEN c.tbl_element_desc LIKE '%EXEMPT%' THEN 'Exempt_Property'
    WHEN c.tbl_element_desc LIKE '%OPERATING%' THEN 'Operating_Property'
    WHEN c.tbl_element_desc LIKE '%QIE%' THEN 'Qualified_Improvement_Expenditure'
    WHEN c.tbl_element LIKE '%P%' THEN 'Business_Personal_Property'
    WHEN LEFT(c.tbl_element,2) IN ('98','99') THEN 'Non-Allocated_Error'
    WHEN LEFT(c.tbl_element,2) IN ('25') THEN 'Common_Area'
    WHEN LEFT(c.tbl_element,2) IN ('81') THEN 'Exempt_Property'
    WHEN LEFT(c.tbl_element,2) IN ('19') THEN 'RightOfWay_ROW_Cat19'
    WHEN LEFT(c.tbl_element,2) IN ('45') THEN 'Operating_Property'
    
    WHEN LEFT(c.tbl_element,2) IN ('01','03','04','05','06','07','08','09','10','11','31','32','33') THEN 'Timber_Ag'
    WHEN LEFT(c.tbl_element,2) IN ('12','15','20','26','30','32','34','37','41') THEN 'Residential'
    WHEN LEFT(c.tbl_element,2) IN ('13','16','21','27','35','38','42') THEN 'Commercial'
    WHEN LEFT(c.tbl_element,2) IN ('14','17','22','36','39','43') THEN 'Industrial'
    WHEN LEFT(c.tbl_element,2) IN ('49','50','51') THEN 'Leased_Land'
    WHEN LEFT(c.tbl_element,2) IN ('46','47','48','55','65') THEN 'Mobile_Home'
    ELSE 'Other'
  END AS Category

,CASE
  WHEN LEFT(c.tbl_element,2) IN ('01','03','04','05','06','07','09','10',
                                '11','12','13','14','15','16','17','18',
                                '19','20','21','22','25','26','27','81') THEN 'State_Land'
  ELSE NULL
END AS State_Land

,CASE
  WHEN LEFT(c.tbl_element,2) BETWEEN '56' AND '72' THEN 'State_Imp'
  WHEN LEFT(c.tbl_element,2) IN ('25','26','30','32','34','35','36','37',
                                '38','39','41','42','43','46','47',
                                '48','49','50','51','55','65','81') THEN 'State_Imp'
  ELSE NULL
END AS State_Imp


FROM codes_table AS c
WHERE c.code_status = 'A' 
AND c.tbl_type_code = 'impgroup'
ORDER BY c.tbl_element_desc;
--)