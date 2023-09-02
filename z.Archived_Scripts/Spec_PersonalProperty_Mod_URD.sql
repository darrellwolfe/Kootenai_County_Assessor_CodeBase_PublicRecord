/*
--Joins
{{"ModifierDescr", "PP Exemption 602KK"}, {"ModifierPercent", "602KK %"}, {"OverrideAmount", "602KK $"}})
{{"ModifierDescr", "Total URD Base"}, {"ModifierPercent", "URD %"}, {"OverrideAmount", "URD $"}})
dbo_TSBv_MODIFIERS, each ([PINStatus] = "A") and ([ModifierStatus] = "A"))
SELECT *
FROM TSBv_MODIFIERS

--Homeowner
602G Residential Improvements - Homeowners
Homeowner Calc Cap Override
Homeowner Manual Cap Override

--PTR
Property Tax Reduction (Circuit Breaker)
PTR Improvement Percentage
PTR Land Percentage

--Programs
Timber Program
Land Use Program
Total URD Base
State Land Sale
Non-Response Penalty

--Exemptions by code
PP Exemption 602KK
602K Speculative Value of Ag Land
602W Business Inventory Exempt From Taxation
602A Government property
602P Water/Air pollution control
602C Fraternal/benevolent/charitable
602E School/Education
602B Religious corporations or societies
602O Property used for Irrigation or Drainage
602CC Postconsumer Waste
602N Irrigation water and structures
602F Cemeteries/Libraries
602GG Low-income housing Owned by Non-profit
Small Employer Incentive 606A
602D Certain hospitals
Plant/Bldg Invest Tax Crit 602NN

*/

--This is a UNION of two

SELECT
lrsn,
ModifierDescr AS [63-602KK],
ModifierPercent AS [63-602KK_%],
OverrideAmount AS [63-602KK_$]
FROM TSBv_MODIFIERS
WHERE ModifierStatus='A'
AND ModifierDescr LIKE '%602KK%'
AND PINStatus='A'
AND  ExpirationYear > '2022'


SELECT
lrsn,
ModifierDescr AS [URD],
ModifierPercent AS [URD_%],
OverrideAmount AS [URD_$]
FROM TSBv_MODIFIERS
WHERE ModifierStatus='A'
AND ModifierDescr LIKE '%URD%'
AND PINStatus='A'
AND  ExpirationYear > '2022'



SELECT
lrsn,
ModifierDescr AS [HOEX],
ModifierPercent AS [HOEX_%],
OverrideAmount AS [HOEX_$]
FROM TSBv_MODIFIERS
WHERE ModifierStatus='A'
AND ModifierDescr LIKE '%Homeowner%'
AND PINStatus='A'
AND  ExpirationYear > '2022'

--Homeowner
602G Residential Improvements - Homeowners
Homeowner Calc Cap Override
Homeowner Manual Cap Override



