# Kootenai County Assessor Office CodeBase

## The various codes SQL, VBA, Python, R, and more we use for reporting and analysis.

### Views:

**KCv_PARCELMASTER1**
- List of Parcels (Active/Inactive) with PIN, AIN, Acres, Names, Address (Situs & Mailing), etc.

**KCv_AumentumEasy_TagTaxAuthorities**
- List of TAGs with associated Tax Authority Groups (Ex: 1-Kootenai County)
**RELREVOBJ_V**
- List of Parcels that are related to parent parcels (Ex: Mobile related to Situs).

### Tables:
- valuation
- reconciliation
- extensions
- LandHeader
- LandDetail
- tPPAsset
- Modifier


### Special Tables:
- codes_table

SELECT *
FROM codes_table

*Optionally: codes_table AS c*
*Contains the description for all reference codes. In the entire codes table the first three columns are required to reference the table, additional columns optional and rarely used in reporting.*
 
- Column1: “tbl_type_code”
 - Requires filter to the specific code type (examples below).
 - Filter: WHERE tbl_type_code= ‘(sub table here)’

- Column2: “tbl_element”

- Column3: “tbl_element_desc”

SELECT tbl_element AS (Name#), tbl_element_desc AS (Name Desc)
SELECT tbl_element AS Site Rating#, tbl_element_desc AS Site Rating Desc

**Common examples as follows:**

WHERE tbl_type_code= ‘lcmshortdesc’
- appealstatus: 1=Entered
- fieldvisit: AR=Aerial, IN=Inspection
- impgroup: 10=10-Non HO Eligible; 10H=10H Homesite
- lcmshortdesc: 01=1 Per Eff. Front Foot; 02= 2 Lump Sum Site Value
- memo: ACC=Confidential Ownership; IMP=Improvement Information
- mhmake: 80=FourSeasons; 70=Fleetwood
- mhmodel: 120=Cedar Cove; 180=Country Squire
- mhpark: 23=Golden Spikes Estates; 29=Bayview Resort
- permits: 2=New Commercial Permit; 1=New Dwelling Permit
- siterating: 1D=No View; 1F=Average View; 2D=Legend 1; 10=Legend 23
