/*
Taking notes from my Personal Property Power Query > to > Table build, so I can rebuild it in SQL
Query_PP_Parcels

M_Query Language

let
    Source = Sql.Database("AsTxDBProd", "GRM_Main"),
    dbo_KCv_PARCELMASTER1 = Source{[Schema="dbo",Item="KCv_PARCELMASTER1"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(dbo_KCv_PARCELMASTER1,{{"lrsn", "LSRN"}, {"pin", "PIN"}, {"ain", "AIN"}, {"neighborhood", "GEO"}}),
    #"Actives, PP Class" = Table.SelectRows(#"Renamed Columns", each ([EffStatus] = "A") and ([ClassCD] = "020 Commercial                                                  " or [ClassCD] = "021 Commercial 1                                                " or [ClassCD] = "022 Commercial 2                                                " or [ClassCD] = "030 Industrial                                                  " or [ClassCD] = "032 Industrial 2                                                " or [ClassCD] = "060 Transient                                                   " or [ClassCD] = "070 Commercial - Late                                           ")),
    #"AIN to front" = Table.ReorderColumns(#"Actives, PP Class",{"LSRN", "PIN", "AIN", "EffStatus", "CountyNumber", "ClassCD", "LP_Id", "DisplayName", "firstname", "lastname", "AttentionLine", "MailingAddress", "MailingCityStZip", "MailingZip5Char", "SitusAddress", "SitusCity", "SitusState", "SitusZip", "GEO", "TAG", "Acres", "DisplayDescr", "SecTwnRng"}),
    #"Removed Other Columns" = Table.SelectColumns(#"AIN to front",{"LSRN", "PIN", "AIN", "ClassCD", "DisplayName", "MailingAddress", "MailingCityStZip", "SitusAddress", "SitusCity", "TAG", "DisplayDescr"}),
    #"Extract after SITUS#" = Table.AddColumn(#"Removed Other Columns", "Text After Delimiter", each Text.AfterDelimiter([DisplayDescr], "SITUS#"), type text),
    #"Extra data after situs" = Table.SplitColumn(#"Extract after SITUS#", "Text After Delimiter", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"Text After Delimiter.1", "Text After Delimiter.2"}),
    #"Removed Columns" = Table.RemoveColumns(#"Extra data after situs",{"Text After Delimiter.2"}),
    #"Renamed Situs AIN" = Table.RenameColumns(#"Removed Columns",{{"Text After Delimiter.1", "Situs AIN"}}),
    #"Moved Situs AIN to Situs area" = Table.ReorderColumns(#"Renamed Situs AIN",{"LSRN", "PIN", "AIN", "ClassCD", "DisplayName", "MailingAddress", "MailingCityStZip", "Situs AIN", "SitusAddress", "SitusCity", "TAG", "DisplayDescr"}),
    #"Trimmed Text all but LSRN" = Table.TransformColumns(#"Moved Situs AIN to Situs area",{{"PIN", Text.Trim, type text}, {"AIN", Text.Trim, type text}, {"ClassCD", Text.Trim, type text}, {"DisplayName", Text.Trim, type text}, {"MailingAddress", Text.Trim, type text}, {"MailingCityStZip", Text.Trim, type text}, {"Situs AIN", Text.Trim, type text}, {"SitusAddress", Text.Trim, type text}, {"SitusCity", Text.Trim, type text}, {"TAG", Text.Trim, type text}, {"DisplayDescr", Text.Trim, type text}}),
    #"Merged Return Note" = Table.NestedJoin(#"Trimmed Text all but LSRN",{"LSRN"},#"Note (Annual, NonReturn)",{"objectId"},"Note (Annual, NonReturn)",JoinKind.LeftOuter),
    #"Return Status Notes" = Table.ExpandTableColumn(#"Merged Return Note", "Note (Annual, NonReturn)", {"Return Status"}, {"Return Status"}),
    #"Notes moved" = Table.ReorderColumns(#"Return Status Notes",{"LSRN", "PIN", "AIN", "ClassCD", "DisplayName", "Return Status", "MailingAddress", "MailingCityStZip", "Situs AIN", "SitusAddress", "SitusCity", "TAG", "DisplayDescr"}),
    #"Merged URDs" = Table.NestedJoin(#"Notes moved",{"LSRN"},#"Modifiers (URD)",{"lrsn"},"Modifiers (URD)",JoinKind.LeftOuter),
    #"Merged PP Exemption 602KK" = Table.NestedJoin(#"Merged URDs",{"LSRN"},#"Modifiers (PP Ex 602KK)",{"lrsn"},"Modifiers (PP Ex 602KK)",JoinKind.LeftOuter),
    #"Merged TaxAuth 301, 345" = Table.NestedJoin(#"Merged PP Exemption 602KK",{"LSRN"},#"TagTaxAuth (301, 345)",{"TagId"},"TagTaxAuth (301, 345)",JoinKind.LeftOuter),
    #"Expanded Modifiers (URD)" = Table.ExpandTableColumn(#"Merged TaxAuth 301, 345", "Modifiers (URD)", {"URD %", "URD $"}, {"URD %", "URD $"}),
    #"Expanded Modifiers (PP Ex 602KK)" = Table.ExpandTableColumn(#"Expanded Modifiers (URD)", "Modifiers (PP Ex 602KK)", {"602KK %", "602KK $"}, {"602KK %", "602KK $"}),
    #"Expanded TagTaxAuth (301, 345)" = Table.ExpandTableColumn(#"Expanded Modifiers (PP Ex 602KK)", "TagTaxAuth (301, 345)", {"TaxAuthorityShortDescr"}, {"TaxAuthorityShortDescr"}),
    #"Merged Assessed Value 2022" = Table.NestedJoin(#"Expanded TagTaxAuth (301, 345)",{"LSRN"},#"Assessed Value 2022",{"lrsn"},"Assessed Value 2022",JoinKind.LeftOuter),
    #"Expanded Assessed Value 2022" = Table.ExpandTableColumn(#"Merged Assessed Value 2022", "Assessed Value 2022", {"Assessed 2022"}, {"Assessed 2022"}),
    #"Merged MPPV Value 2022" = Table.NestedJoin(#"Expanded Assessed Value 2022",{"LSRN"},#"tPPAsset (MPP Value TaxYear 2022)",{"mPropertyId"},"tPPAsset (MPP Value TaxYear 2022)",JoinKind.LeftOuter),
    #"Merged MPPV VALUES 2023" = Table.NestedJoin(#"Merged MPPV Value 2022",{"LSRN"},#"tPPAsset (MPP Value TaxYear 2023)",{"mPropertyId"},"tPPAsset (MPP Value TaxYear 2023)",JoinKind.LeftOuter),
    #"Expanded tPPAsset (MPP Value TaxYear 2022)" = Table.ExpandTableColumn(#"Merged MPPV VALUES 2023", "tPPAsset (MPP Value TaxYear 2022)", {"MPPV Value 2022"}, {"MPPV Value 2022"}),
    #"Expanded tPPAsset (MPP Value TaxYear 2023)" = Table.ExpandTableColumn(#"Expanded tPPAsset (MPP Value TaxYear 2022)", "tPPAsset (MPP Value TaxYear 2023)", {"MPPV Value 2023"}, {"MPPV Value 2023"}),
    #"Value - Exemption: Taxable Val" = Table.AddColumn(#"Expanded tPPAsset (MPP Value TaxYear 2023)", "Net Taxable Value", each [MPPV Value 2023] - [#"602KK $"], type number),
    #"Removed Duplicates" = Table.Distinct(#"Value - Exemption: Taxable Val", {"LSRN"}),
    #"Sort Name then PIN" = Table.Sort(#"Removed Duplicates",{{"DisplayName", Order.Ascending}, {"PIN", Order.Ascending}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Sort Name then PIN",{"LSRN", "PIN", "AIN", "ClassCD", "Assessed 2022", "MPPV Value 2022", "MPPV Value 2023", "602KK $", "Net Taxable Value", "DisplayName", "Return Status", "MailingAddress", "MailingCityStZip", "Situs AIN", "SitusAddress", "SitusCity", "TAG", "DisplayDescr", "URD %", "URD $", "602KK %", "TaxAuthorityShortDescr"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Reordered Columns",{"MPPV Value 2022"}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Removed Columns1",{"LSRN", "PIN", "AIN", "ClassCD", "Assessed 2022", "MPPV Value 2023", "602KK %", "602KK $", "Net Taxable Value", "DisplayName", "Return Status", "MailingAddress", "MailingCityStZip", "Situs AIN", "SitusAddress", "SitusCity", "TAG", "DisplayDescr", "URD %", "URD $", "TaxAuthorityShortDescr"}),
    #"Remove 60, 70" = Table.SelectRows(#"Reordered Columns1", each [ClassCD] <> "060 Transient" and [ClassCD] <> "070 Commercial - Late")
in
    #"Remove 60, 70"



    SELECT 
    [dbo_KCv_PARCELMASTER1].[lrsn], 
    [dbo_KCv_PARCELMASTER1].[pin], 
    [dbo_KCv_PARCELMASTER1].[ain], 
    [dbo_KCv_PARCELMASTER1].[ClassCD], 
    [dbo_KCv_PARCELMASTER1].[DisplayName], 
    [dbo_KCv_PARCELMASTER1].[MailingAddress], 
    [dbo_KCv_PARCELMASTER1].[MailingCityStZip], 
    [Situs_AIN].[Text After Delimiter.1] AS [Situs AIN], 
    [dbo_KCv_PARCELMASTER1].[SitusAddress], 
    [dbo_KCv_PARCELMASTER1].[SitusCity], 
    [dbo_KCv_PARCELMASTER1].[TAG], 
    [dbo_KCv_PARCELMASTER1].[DisplayDescr], 
    [dbo_Note (Annual, NonReturn)].[Return Status], 
    [dbo_Modifiers (URD)].[URD %], 
    [dbo_Modifiers (URD)].[URD $], 
    [dbo_Modifiers (PP Ex 602KK)].[ExemptionCD] AS [PP Exemption 602KK], 
    [dbo_TagTaxAuth (301, 345)].[TagTaxAuth] AS [TaxAuth 301, 345]
FROM 
    [AsTxDBProd].[dbo].[KCv_PARCELMASTER1] AS [dbo_KCv_PARCELMASTER1]
LEFT JOIN 
    (SELECT 
        [objectId], 
        [Return Status]
    FROM 
        [AsTxDBProd].[dbo].[Note (Annual, NonReturn)]
    ) AS [dbo_Note (Annual, NonReturn)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Note (Annual, NonReturn)].[objectId]
LEFT JOIN 
    (SELECT 
        [lrsn], 
        [URD %], 
        [URD $]
    FROM 
        [AsTxDBProd].[dbo].[Modifiers (URD)]
    ) AS [dbo_Modifiers (URD)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Modifiers (URD)].[lrsn]
LEFT JOIN 
    (SELECT 
        [lrsn], 
        [ExemptionCD]
    FROM 
        [AsTxDBProd].[dbo].[Modifiers (PP Ex 602KK)]
    ) AS [dbo_Modifiers (PP Ex 602KK)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Modifiers (PP Ex 602KK)].[lrsn]
LEFT JOIN 
    (SELECT 
        [TagId], 
        [TagTaxAuth]
    FROM 
        [AsTxDBProd].[dbo].[TagTaxAuth (301, 345)]
    ) AS [dbo_TagTaxAuth (301, 345)]
ON 
    [dbo_KCv_PARCELMASTER1].[TAG] = [dbo_TagTaxAuth (301, 345)].[TagId]
CROSS APPLY 
    (SELECT 
        [Text After Delimiter].[Value]
    FROM 
        STRING_SPLIT([dbo_KCv_PARCELMASTER1].[DisplayDescr], 'SITUS#') 
        CROSS APPLY 
            STRING_SPLIT([value], ' ') 
        WHERE 
            [value] != ''
        ) AS [Situs_AIN]
WHERE 
    [dbo_KCv_PARCELMASTER1].[EffStatus



*/

//Tables>Columns
--Table
tPPAsset

--Join Details
mPropertyId=lrsn
mbegTaxYear (202300000)
mendTaxYear (202399999)
mEffStatus='A'

--Asset Details
mAssetCategory (First drop down, Cat# that lives under Cat Desc (Ex: Misc =  68)
mNote (Cat Desc)
mScheduleName (Schedule, like 00,05,19)
mAcquisitionDate (from dec)
mAcquisitionValue (from dec)
mDescription (MILK DISP)
mAppraisedValue
mProrateValue
mSerialNumber
mMfg
mOverrideValue

--Additional
mAppraiser
mChangeTimeStamp (this is a date)
mUserId (This shows if individual or system change)


--Table
valuation

--Join
lrsn=lrsn --- Group by LRSN to get total value
last_update (date) --In Power Query, used a Table.Buffer(Table.Sort()), then remove duplicates to get most recent
status='A'
update_user_id (apprasier)
imp_val (Cert Value)
imp_assess (Appraised Value)
property_class (PCC 10-90)

--Table
KCv_AumentumEasy_TagTaxAuthorities
--Join
TagId
TagDescr
TaxAuthorityDescr (LIKE 345, 301)
--What if we joined this to parcel master and then filtered by city, to determine master tags


--Table
TSBv_MODIFIERS"

--Joins
{{"ModifierDescr", "PP Exemption 602KK"}, {"ModifierPercent", "602KK %"}, {"OverrideAmount", "602KK $"}})
{{"ModifierDescr", "Total URD Base"}, {"ModifierPercent", "URD %"}, {"OverrideAmount", "URD $"}})
dbo_TSBv_MODIFIERS, each ([PINStatus] = "A") and ([ModifierStatus] = "A"))












--Possible option from ChatGPT, asked it to turn my Power Query M Langage into SQL Script.

/*
AsTxDBProd
GRM_Main
*/

SELECT 
--Account Details
parcel.lrsn,
LTRIM(RTRIM(parcel.ain)) AS [AIN], 
LTRIM(RTRIM(parcel.pin)) AS [PIN], 
parcel.neighborhood AS [GEO],
LTRIM(RTRIM(parcel.ClassCD)) AS [ClassCD], 
--Demographics
LTRIM(RTRIM(parcel.DisplayName)) AS [Owner], 
LTRIM(RTRIM(parcel.SitusAddress)) AS [SitusAddress],
LTRIM(RTRIM(parcel.SitusCity)) AS [SitusCity],
--Mailing
LTRIM(RTRIM(parcel.AttentionLine)) AS [Attn],
LTRIM(RTRIM(parcel.MailingAddress)) AS [MailingAddress],
LTRIM(RTRIM(parcel.MailingCityStZip)) AS [Mailing CSZ],
--Other
LTRIM(RTRIM(parcel.TAG)) AS [TAG], 
LTRIM(RTRIM(parcel.DisplayDescr)) AS [LegalDescription],

Assessed 2019
Assessed 2020
Assessed 2021
Assessed 2022
Assessed 2023

MPPV Value 2023


/*
Placeholder
    [dbo_Note (Annual, NonReturn)].[Return Status], 
    [dbo_Modifiers (URD)].[URD %], 
    [dbo_Modifiers (URD)].[URD $], 
    [dbo_Modifiers (PP Ex 602KK)].[ExemptionCD] AS [PP Exemption 602KK], 
    [dbo_TagTaxAuth (301, 345)].[TagTaxAuth] AS [TaxAuth 301, 345]
*/
-- This is an extract from the DisplayDescr: [Situs_AIN].[Text After Delimiter.1] AS [Situs AIN], 


FROM KCv_PARCELMASTER1 AS parcel

Note
Modifiers URD
Modifiers 602KK
TagTaxAuth OR KCv_AumentumEasy_TagTaxAuthorities
tPP


WHERE parcel.EffStatus= 'A'





ORDER BY parcel.neighborhood, parcel.pin;

/*

#"Merged Assessed Value 2022" = Table.NestedJoin(#"Expanded TagTaxAuth (301, 345)",{"LSRN"},#"Assessed Value 2022",{"lrsn"},"Assessed Value 2022",JoinKind.LeftOuter),
    #"Expanded Assessed Value 2022" = Table.ExpandTableColumn(#"Merged Assessed Value 2022", "Assessed Value 2022", {"Assessed 2022"}, {"Assessed 2022"}),
    #"Merged MPPV Value 2022" = Table.NestedJoin(#"Expanded Assessed Value 2022",{"LSRN"},#"tPPAsset (MPP Value TaxYear 2022)",{"mPropertyId"},"tPPAsset (MPP Value TaxYear 2022)",JoinKind.LeftOuter),
    #"Merged MPPV VALUES 2023" = Table.NestedJoin(#"Merged MPPV Value 2022",{"LSRN"},#"tPPAsset (MPP Value TaxYear 2023)",{"mPropertyId"},"tPPAsset (MPP Value TaxYear 2023)",JoinKind.LeftOuter),
    #"Expanded tPPAsset (MPP Value TaxYear 2022)" = Table.ExpandTableColumn(#"Merged MPPV VALUES 2023", "tPPAsset (MPP Value TaxYear 2022)", {"MPPV Value 2022"}, {"MPPV Value 2022"}),
    #"Expanded tPPAsset (MPP Value TaxYear 2023)" = Table.ExpandTableColumn(#"Expanded tPPAsset (MPP Value TaxYear 2022)", "tPPAsset (MPP Value TaxYear 2023)", {"MPPV Value 2023"}, {"MPPV Value 2023"}),
  


FROM 


    [AsTxDBProd].[dbo].[KCv_PARCELMASTER1] AS [dbo_KCv_PARCELMASTER1]
LEFT JOIN 
    (SELECT 
        [objectId], 
        [Return Status]
    FROM 
        [AsTxDBProd].[dbo].[Note (Annual, NonReturn)]
    ) AS [dbo_Note (Annual, NonReturn)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Note (Annual, NonReturn)].[objectId]
LEFT JOIN 
    (SELECT 
        [lrsn], 
        [URD %], 
        [URD $]
    FROM 
        [AsTxDBProd].[dbo].[Modifiers (URD)]
    ) AS [dbo_Modifiers (URD)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Modifiers (URD)].[lrsn]
LEFT JOIN 
    (SELECT 
        [lrsn], 
        [ExemptionCD]
    FROM 
        [AsTxDBProd].[dbo].[Modifiers (PP Ex 602KK)]
    ) AS [dbo_Modifiers (PP Ex 602KK)]
ON 
    [dbo_KCv_PARCELMASTER1].[LSRN] = [dbo_Modifiers (PP Ex 602KK)].[lrsn]
LEFT JOIN 
    (SELECT 
        [TagId], 
        [TagTaxAuth]
    FROM 
        [AsTxDBProd].[dbo].[TagTaxAuth (301, 345)]
    ) AS [dbo_TagTaxAuth (301, 345)]
ON 
    [dbo_KCv_PARCELMASTER1].[TAG] = [dbo_TagTaxAuth (301, 345)].[TagId]
CROSS APPLY 
    (SELECT 
        [Text After Delimiter].[Value]
    FROM 
        STRING_SPLIT([dbo_KCv_PARCELMASTER1].[DisplayDescr], 'SITUS#') 
        CROSS APPLY 
            STRING_SPLIT([value], ' ') 
        WHERE 
            [value] != ''
        ) AS [Situs_AIN]
WHERE 
    [dbo_KCv_PARCELMASTER1].[EffStatus

    */