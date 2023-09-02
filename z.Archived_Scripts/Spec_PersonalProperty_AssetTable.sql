/*
AsTxDBProd
GRM_Main
*/


SELECT
--Asset Details
pp.mAssetCategory, --(First drop down, Cat# that lives under Cat Desc (Ex: Misc =  68)
pp.mNote, --(Cat Desc)
pp.mScheduleName, --(Schedule, like 00,05,19)
pp.mAcquisitionDate, --(from annual declaration, then goes into MPPV)
pp.mAcquisitionValue, --(from annual declaration, then goes into MPPV)
pp.mDescription, --(Ex: MILK DISP)
pp.mAppraisedValue, -- This is the final value, see next note
/*
-- This is the final value assigned by MPPV, after depreciation. 
-- The Appraised Value will initially pull by asset, creating duplicate results for most ID/lrsn's. 
-- To get the aggregate value for the year for a single account, must filter by year, active, and do some kind of agregation, 
like a sum and group by, possibly in a cte with your joins.
*/
pp.mOverrideValue, -- Rare, but MPPV values can have override
pp.mProrateValue, -- Rare, but MPPV values can prorate, usually because of a hyper special case, usually ordered from state or bocc
pp.mSerialNumber, -- Optional, can include serial num on asset
pp.mMfg, -- Optional, can include other details, like Manufacterer on asset
--Additional
pp.mAppraiser, -- Who changed value, human or system?
pp.mChangeTimeStamp, -- When was it changed (this is a date)
pp.mUserId, -- (This shows if individual or system change)
--Join Details
pp.mPropertyId, -- this is the lrsn, join to lrsn on Parcel Master
pp.mbegTaxYear, -- in year plus five formatt for some reason
pp.mendTaxYear, -- in year plus five formatt for some reason
pp.mEffStatus -- 'A' or 'I' Active,Inactive

--Table
FROM tPPAsset AS pp
--If joining, use: pp.mPropertyId=parcel.lrsn (or whatever table you are joining)

--Conditions
WHERE pp.mEffStatus='A'
AND pp.mbegTaxYear ='202300000'
AND pp.mendTaxYear = '202399999'
ORDER BY pp.mPropertyId, pp.mAssetCategory, pp.mScheduleName, pp.mAcquisitionDate
--End;