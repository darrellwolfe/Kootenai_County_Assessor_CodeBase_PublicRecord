SELECT
    TRIM(p.AIN),
    t.pxfer_date,
    t.AdjustedSalePrice

FROM TSBv_PARCELMASTER AS p
    JOIN transfer AS t ON p.lrsn = t.lrsn
        AND t.status = 'A'
