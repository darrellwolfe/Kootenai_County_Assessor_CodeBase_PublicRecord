-- !preview conn=conn


DECLARE @Year INT = 2023

SELECT
    t.lrsn,
    t.pxfer_date AS [TransferDate],
    t.AdjustedSalePrice AS [SalesPrice_ProVal],
    t.DocNum,
    t.ConvForm,
    t.SaleDesc,
    t.TfrType,
    t.GrantorName AS [Grantor_Seller],
    t.GranteeName AS [Grantee_Buyer],
    t.last_update AS [LastUpdated],
    t.sxfer_date AS [Secondary_Transfer_Date]
FROM transfer AS t
WHERE t.pxfer_date BETWEEN CAST(@Year AS VARCHAR) + '-01-01' AND CAST(@Year AS VARCHAR) + '-12-31'
--AND t.AdjustedSalePrice <> 0






