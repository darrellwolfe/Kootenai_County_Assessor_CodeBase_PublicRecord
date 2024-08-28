-- !preview conn=conn
/*
AsTxDBProd
GRM_Main
,mAcquisitionDate
,mAcquisitionValue
,mAppraisedValue
,mDescription
      
*/


    DECLARE @ThisYearMPPVFrom INT = '202300000';
    DECLARE @ThisYearMPPVTo INT = '202399999';

    SELECT DISTINCT
    mDescription

    FROM tPPAsset
    WHERE mEffStatus = 'A' 
--    AND mPropertyId = 502477

      And mbegTaxYear BETWEEN @ThisYearMPPVFrom AND @ThisYearMPPVTo
      And mendTaxYear BETWEEN @ThisYearMPPVFrom AND @ThisYearMPPVTo
