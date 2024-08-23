-- !preview conn=conn

/*
AsTxDBProd
GRM_Main

---------
--Select All
---------
Select Distinct *
From TSBv_PARCELMASTER AS pm
Where pm.EffStatus = 'A'

TAFRate is the table where yearly Tax Rates are stored:
TAFRate.TaxYear
TAFRate.TAFId

Are the key fields

TAF is linking between TaxAuthority and Fund 
TAGTaxAuthority is the linking between TaxAuthority and TAG

Select Distinct
*

taf.TaxYear
,taf.TAFId
,taf.TaxRate

From TAFRate AS taf

Where taf.TaxYear = '2023'

Order by taf.TaxYear, taf.TAFId;

*/


Select *
From TAF