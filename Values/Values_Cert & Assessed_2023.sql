/*
AsTxDBProd
GRM_Main
*/


----------------------
--Values Combined --Change to desired year in CTE Statements
----------------------


WITH 
  CTE_Cert AS (
    SELECT 
      lrsn,
      --Certified Values
      v.land_market_val AS [Cert Land],
      v.imp_val AS [Cert Imp],
      (v.imp_val + v.land_market_val) AS [Cert Total Value],
      v.eff_year AS [Tax Year],
      ROW_NUMBER() OVER (PARTITION BY v.lrsn ORDER BY v.last_update DESC) AS RowNumber
    FROM valuation AS v
    WHERE v.eff_year BETWEEN 20230101 AND 20231231
--Change to desired year
      AND v.status = 'A'
  ),

  CTE_Assessed AS (
    SELECT 
      lrsn,
      --Assessed Values
      v.land_assess AS [Assessed Land],
      v.imp_assess AS [Assessed Imp],
      (v.imp_assess + v.land_assess) AS [Assessed Total Value],
      v.eff_year AS [Tax Year],
      ROW_NUMBER() OVER (PARTITION BY v.lrsn ORDER BY v.last_update DESC) AS RowNumber
    FROM valuation AS v
    WHERE v.eff_year BETWEEN 20230101 AND 20231231
--Change to desired year
      AND v.status = 'A'
  )

SELECT 
  parcel.lrsn,
  LTRIM(RTRIM(parcel.pin)) AS [PIN], 
  LTRIM(RTRIM(parcel.ain)) AS [AIN], 
  parcel.neighborhood AS [GEO],
  parcel.Acres,
  parcel.ClassCD,
  --Certified Values
  crt.[Cert Land],
  crt.[Cert Imp],
  crt.[Cert Total Value],
  --Assessed Values
  asd.[Assessed Land],
  asd.[Assessed Imp],
  asd.[Assessed Total Value]

FROM KCv_PARCELMASTER1 AS parcel
LEFT JOIN CTE_Cert AS crt ON parcel.lrsn = crt.lrsn
LEFT JOIN CTE_Assessed AS asd ON parcel.lrsn = asd.lrsn

WHERE parcel.EffStatus = 'A'
AND crt.RowNumber=1
AND asd.RowNumber=1

ORDER BY [GEO], [PIN];
