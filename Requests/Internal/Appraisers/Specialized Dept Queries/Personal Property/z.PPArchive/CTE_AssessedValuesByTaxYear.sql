-- !preview conn=conn





--CTE_AssessedValuesByTaxYear
Select
lrsn
,(land_assess + imp_assess) AS AssessedValue
,CAST(LEFT(eff_year,4) AS INT) AS TaxYear
,valuation_comment

From valuation

Where status = 'A'
--AND lrsn = 510587
And eff_year > 20180101
--And eff_year IN ('','','','','')
