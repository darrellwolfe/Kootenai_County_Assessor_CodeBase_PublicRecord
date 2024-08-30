

DECLARE @CurrentYear INT = YEAR(GETDATE());


SELECT
    lrsn,
    TRIM(ModifierDescr) AS URD,
    ModifierPercent AS URDPerc,
    OverrideAmount AS URD_Amount,
    ExpirationYear

FROM TSBv_MODIFIERS
WHERE ModifierStatus='A'
AND ModifierDescr LIKE '%URD%'
AND PINStatus='A'
AND ExpirationYear > @CurrentYear
