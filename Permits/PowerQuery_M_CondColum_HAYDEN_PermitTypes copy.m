//------------------------------------------
//-- Conditional Columns CDA Permits, Permit Types
//------------------------------------------
//PRIORITY ORDER

//NEW RES 1
if Text.Contains([Type], "RES SINGLE FAMILY") then 1
else if Text.Contains([Description], "SINGLE FAMILY") then 1
else if Text.Contains([Type], "TOWNHOME") then 1
else if Text.Contains([Type], "MULTIFAMILY") then 1
else if Text.Contains([Type], "DUPLEX") then 1
else if Text.Contains([Type], "MULTIFAMILY") then 1
else if Text.Contains([Type], "MULTIFAMILY") then 1
//NEW COM 2
else if Text.Contains([Type], "COM NEW") then 2
else if Text.Contains([Type], "COM FOUNDATION") then 2
else if Text.Contains([Description], "COM FOUNDATION") then 2
//MOBILE SETTING 99
else if Text.Contains([Type], "MOBILE") then 99
else if Text.Contains([Description], "MOBILE") then 99
else if Text.Contains([Type], "MH") then 99
else if Text.Contains([Description], "MH") then 99
//ADDITION OR ALTERATION 3
else if Text.Contains([Description], "COM ALTERATION") then 3
else if Text.Contains([Type], "COM ALTERATION") then 3
else if Text.Contains([Type], "COM ACCESSORY") then 3
else if Text.Contains([Type], "RES ACCESSORY") then 3
else if Text.Contains([Type], "RES ALTERATION") then 3
else if Text.Contains([Type], "RES ADDITION") then 3
else if Text.Contains([Type], "COM ADDITION") then 3
//OUTBUILDINGS AND OTHER STRUCTURES 4
else if Text.Contains([Type], "RES OTHER ST") then 5
else if Text.Contains([Description], "COM OTHER") then 5
else if Text.Contains([Description], "COM OTHER") then 5
//MISC REVIEW 5
//MANDATORY REVIEW 6
else if Text.Contains([Description], "DEMO") then 6
else if Text.Contains([Type], "DEMO") then 6
//BOAT DOCK 14 USUALLY THROUGH IDL ONLY
//MECHANICAL PERMITS 9
// BY Type
else if Text.Contains([Type], "MECHANICAL") then 9
else if Text.Contains([Type], "ROOFING") then 9
else if Text.Contains([Type], "MECHANICAL") then 9
else if Text.Contains([Type], "MECH") then 9
else if Text.Contains([Type], "ROOFING") then 9
else if Text.Contains([Type], "SIDING") then 9
else if Text.Contains([Type], "SOLAR") then 9
else if Text.Contains([Type], "SIDING") then 9
else if Text.Contains([Type], "WINDOW") then 9
else if Text.Contains([Type], "DOOR") then 9
// BY Description
else if Text.Contains([Description], "MECHANICAL") then 9
else if Text.Contains([Description], "ROOFING") then 9
else if Text.Contains([Description], "MECHANICAL") then 9
else if Text.Contains([Description], "MECH") then 9
else if Text.Contains([Description], "ROOFING") then 9
else if Text.Contains([Description], "SIDING") then 9
else if Text.Contains([Description], "SOLAR") then 9
else if Text.Contains([Description], "SIDING") then 9
else if Text.Contains([Description], "WINDOW") then 9
else if Text.Contains([Description], "DOOR") then 9
//ELSE ZERO FOR NOW
else 0
(208) 772-4411