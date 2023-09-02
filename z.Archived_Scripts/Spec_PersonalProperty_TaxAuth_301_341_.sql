/*

Looking to have zero:
345
301

*/

--Table

SELECT
TagDescr,
TaxAuthorityDescr

FROM KCv_AumentumEasy_TagTaxAuthorities
WHERE (TaxAuthorityDescr LIKE '%345%' 
OR TaxAuthorityDescr LIKE '%301%')
