DECLARE @CurrentLandModel INT = 702024;

SELECT DISTINCT
  p.lrsn AS [LRSN],
  TRIM(p.pin) AS [PIN],
  TRIM(p.AIN) AS [AIN],
  CASE
      WHEN p.neighborhood >= 9000 THEN 'Manufactured_Homes'
      WHEN p.neighborhood >= 6003 THEN 'District_6'
      WHEN p.neighborhood = 6002 THEN 'Manufactured_Homes'
      WHEN p.neighborhood = 6001 THEN 'District_6'
      WHEN p.neighborhood = 6000 THEN 'Manufactured_Homes'
      WHEN p.neighborhood >= 5003 THEN 'District_5'
      WHEN p.neighborhood = 5002 THEN 'Manufactured_Homes'
      WHEN p.neighborhood = 5001 THEN 'District_5'
      WHEN p.neighborhood = 5000 THEN 'Manufactured_Homes'
      WHEN p.neighborhood >= 4000 THEN 'District_4'
      WHEN p.neighborhood >= 3000 THEN 'District_3'
      WHEN p.neighborhood >= 2000 THEN 'District_2'
      WHEN p.neighborhood >= 1021 THEN 'District_1'
      WHEN p.neighborhood = 1020 THEN 'Manufactured_Homes'
      WHEN p.neighborhood >= 1001 THEN 'District_1'
      WHEN p.neighborhood = 1000 THEN 'Manufactured_Homes'
      WHEN p.neighborhood >= 451 THEN 'Commercial'
      WHEN p.neighborhood = 450 THEN 'Specialized_Cell_Towers'
      WHEN p.neighborhood >= 1 THEN 'Commercial'
      WHEN p.neighborhood = 0 THEN 'N/A_or_Error'
    ELSE NULL
  END AS District,
  p.neighborhood AS GEO,
  ld.LandType AS [Land Type],
  ld.SoilIdent AS [Soil ID],
  ld.LDAcres,
  CASE
    WHEN ld.LDAcres > '5' THEN 'Over 5 Acres'
    WHEN ld.LDAcres < '5' THEN 'Under 5 Acres'
  ELSE NULL
  END AS Acre_Group,
  p.DisplayName AS [Owner Name]
  
FROM TSBv_PARCELMASTER AS p
JOIN LandHeader AS lh ON p.lrsn = lh.RevObjId
JOIN LandDetail AS ld ON lh.Id = ld.LandHeaderId

WHERE lh.LandModelId = @CurrentLandModel
AND ld.PostingSource = 'A'
AND ld.EffStatus = 'A'
AND p.EffStatus = 'A'
AND ld.LandType IN ('4','52')

ORDER BY
  p.DisplayName,
  PIN