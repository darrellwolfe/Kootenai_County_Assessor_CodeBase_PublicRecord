SELECT
    RTRIM(LTRIM(kcv.lrsn)) AS [LRSN],
    RTRIM(LTRIM(kcv.ain)) AS [AIN],
    RTRIM(LTRIM(kcv.pin)) AS [PIN],
    RTRIM(LTRIM(kcv.ClassCD)) AS [PPClassCD],
    --We don't want individual assets but the total value of all assets for these AINs
    SUM(tPP.mAppraisedValue) AS [MPPVAppraisedValue],
    SUM(tPP.mAcquisitionValue) AS [AcquisitionValue],
    RTRIM(LTRIM(kcv.DisplayName)) AS [DisplayName],
    RTRIM(LTRIM(kcv.SitusAddress)) AS [SitusAddress],
    RTRIM(LTRIM(kcv.SitusCity)) AS [SitusCity],
    RTRIM(LTRIM(kcv.TAG)) AS [TAG],
    RTRIM(LTRIM(kcv.MailingAddress)) AS [MailingAddress],
    RTRIM(LTRIM(kcv.MailingCityStZip)) AS [MailingCityStZip]

FROM KCv_PARCELMASTER1 AS kcv
INNER JOIN tPPAsset AS tPP ON kcv.lrsn=tPP.mPropertyId
LEFT JOIN KCv_AumentumEasy_TagTaxAuthorities AS ta ON kcv.TAG=ta.TagDescr
LEFT JOIN TSBv_MODIFIERS AS m ON kcv.lrsn=m.lrsn

WHERE tPP.mEffStatus='A'
    AND kcv.EffStatus='A'
    AND ta.TaxAuthorityDescr IN ('301-FC DIST #17', '345-HAYDEN LK WTRSHD IMP')
    AND m.ModifierStatus='A'
    AND m.ModifierDescr IN ('PP Exemption 602KK', 'Total URD Base')
    AND tPP.mbegTaxYear >= 202300000 AND tPP.mendTaxYear <= 202399999
    AND kcv.ClassCD IN ('020 Commercial', '21 Commercial 1', '22 Commercial 2','030 Industrial', '32 Industrial 2', '070 Commercial - Late', '060 Transient')
--Include or disinclude any types you want to see or not see

GROUP BY kcv.lrsn, kcv.ain, kcv.pin, kcv.ClassCD, kcv.DisplayName, kcv.SitusAddress, kcv.SitusCity, kcv.TAG, kcv.MailingAddress, kcv.MailingCityStZip

ORDER BY kcv.DisplayName, kcv.pin
