



SELECT pin, Acres, EffStatus 

FROM KCv_PARCELMASTER1 AS kcv.lrsn
LEFT JOIN allocations AS a ON kcv.lrsn=a.lrsn
LEFT JOIN LandHeader AS lh ON kcv.lrsn=lh.lrsn
LEFT JOIN LandDetail AS ld ON lh.Id=ld.LandHeaderId AND 

Where EffStatus= 'A' 
AND left(pin, 5) like '%N%%' 




Order By pin ASC
DBQuery>dbH,tmp1,KC_MASTR,NumRecs,NumFields,0
