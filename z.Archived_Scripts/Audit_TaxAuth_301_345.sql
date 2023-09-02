/*
AsTxDBProd
GRM_Main
*/
-- Tax Auth with only 345 & 301;
SELECT TagId, TagDescr, TaxAuthorityId, TaxAuthorityDescr
FROM KCv_AumentumEasy_TagTaxAuthorities
WHERE TaxAuthorityDescr LIKE '345%' OR TaxAuthorityDescr LIKE '301%'
ORDER BY TaxAuthorityDescr, TagDescr ASC;
