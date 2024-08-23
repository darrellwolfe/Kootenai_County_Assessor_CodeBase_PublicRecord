-- !preview conn=conn


/*
AsTxDBProd
GRM_Main
*/


Select
nfc.neighborhood AS GEO
--com_model_serial
--,nfc.com_other_mod
--,nfc.cbf_model_number
--,nfc.commercial_mod
--,nfc.industrial_mod
, CASE
    WHEN nfc.commercial_mod = 0
    THEN 1.00
    ELSE CAST(nfc.commercial_mod AS DECIMAL(10,2)) / 100 
  END AS [Worksheet_CommFactor]
--For Database
, CASE
    WHEN nfc.commercial_mod = 0
    THEN 100
    ELSE nfc.commercial_mod
  END AS [Database_CommFactor]



From neigh_com_impr AS nfc

WHERE nfc.status='A'
AND nfc.inactivate_date='99991231'
AND nfc.com_model_serial='9998'
--AND nf.res_model_serial=@TaxYear

--neigh_com_impr.neighborhood