
CTE_CadasterInventory AS (
SELECT DISTINCT
r.AssessmentYear
,r.Descr AS AssessmentType
,l.CadRollId
,l.RollLevel 
,i.TranId
,i.CadLevelId
,i.RevObjEffStatus
,i.RevObjId AS CadRoll_LRSN
,TRIM(i.PIN) AS PIN
,TRIM(i.AIN ) AS AIN
,TRIM(i.GeoCd) AS GEO
,TRIM(i.TAGDescr) AS TAG

FROM CadRoll r
JOIN CadLevel l ON r.Id = l.CadRollId
JOIN CadInv i ON l.Id = i.CadLevelId

--Tax Year 2023 (Annual Roll Only) so far
--WHERE r.Id IN ('559', '560', '561')

WHERE r.AssessmentYear IN ('2023')

ORDER BY GEO, PIN
)