Select Distinct 
    RevObjId AS lrsn,
    TRIM(PIN) AS PIN, 
    TRIM(AIN) AS AIN, 
    CAST(LEFT(Prop_Class_Descr,3) AS INT) AS PCC,
    TRIM(Prop_Class_Descr) AS Prop_Class_Descr,
    Acres, 
    Cat19AC, 
    CASE WHEN ACRES >= 1 THEN 1 ELSE ACRES - Cat19Ac END AS SITE, 
    CASE WHEN ACRES > 1 THEN ACRES - 1 - CAT19AC ELSE 0 END AS REMACRES 

From 
    KC_MAP_PlatReportBase_v 
Where 
    EffStatus = 'A' 
    --AND PIN like ? 
Order by 
    PIN ASC