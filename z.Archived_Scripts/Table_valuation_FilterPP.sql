SELECT DISTINCT
lrsn,
SUM(imp_val) AS [CertValue],
MAX(last_update) AS [LastUpdated]

FROM valuation
WHERE status='A'
AND property_class IN ('10','20','21','22','30','32','60','70','80','90')
AND eff_year BETWEEN 20220101 AND 20221231

GROUP BY lrsn
ORDER BY lrsn
