/*
--Gather TotalValues by lrsn from the tppAsset table
WITH TotalValues AS (
   SELECT mPropertyId, 
          MAX(mChangeTimeStamp) AS [MostRecentAprslDate],
          SUM(mAcquisitionValue) AS [TotalAcquisitionValue], 
          SUM(mAppraisedValue) AS [TotalAppraisedValue]
   FROM tPPAsset
   WHERE mEffStatus = 'A' AND mbegTaxYear = '202300000' AND mendTaxYear = '202399999'
   GROUP BY mPropertyId
)
*/

--Gather TotalValues by lrsn from the tppAsset table

   SELECT mPropertyId, 
          MAX(mChangeTimeStamp) AS [MostRecentAprslDate],
          SUM(mAcquisitionValue) AS [TotalAcquisitionValue], 
          SUM(mAppraisedValue) AS [TotalAppraisedValue]
   FROM tPPAsset
   WHERE mEffStatus = 'A' AND mbegTaxYear = '202300000' AND mendTaxYear = '202399999'
   GROUP BY mPropertyId
