-- !preview conn=con

SELECT DISTINCT
-- TAG.Descr AS [TAG],
ta.Descr AS [TaxAuthority_Name],
Count (DISTINCT pm.LRSN)

--TAG Table
FROM TAG AS tag
--TAGTIF Key
LEFT JOIN TAGTIF ON TAG.Id=TAGTIF.TAGId 
  AND TAGTIF.EffStatus = 'A'
--TIF Table
LEFT JOIN TIF AS tif ON TAGTIF.TIFId=TIF.Id 
  AND TIF.EffStatus  = 'A'
--TAGTaxAuthority Key
LEFT JOIN TAGTaxAuthority ON TAG.Id=TAGTaxAuthority.TAGId 
  AND TAGTaxAuthority.EffStatus = 'A'
--TaxAuthority Table
LEFT JOIN TaxAuthority AS ta ON TAGTaxAuthority.TaxAuthorityId=ta.Id 
  AND ta.EffStatus = 'A'
--Pull in Parcel Master PINs for specific TAGs, TIFs, and/or TaxAuthorities you are looking for
LEFT JOIN TSBv_PARCELMASTER AS pm ON Tag.Descr = pm.TAG -- Join pm ON tag table


WHERE tag.EffStatus = 'A'
AND ta.Descr LIKE '203%'

GROUP BY
ta.Descr 
