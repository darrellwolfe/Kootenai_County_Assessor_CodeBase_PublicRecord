PF Permit Types Key


In Power Query, 

Add Column > Custom Column > 

New Column Name: 
ProVal Permit Types

Custom Column Formula:
= 

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Roofing/Siding/Windows") then "9" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Roofing/Siding/Windows") then "9" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Tenant Improvement/Alt") then "3" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Addition") then "3" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "New Construction") then "2" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Swimming Pool") then "3" 
else

if ([Record Type] = "Commercial Building Permit" and [Type of Work] = "Retaining Wall") then "3" 
else


if ([Record Type] = "Mechanical Permit") then "9" 
else


if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Roofing/Siding/Windows") then "9" 
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Solar") then "9" 
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Manufactured Home") then "99" 
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Solar Installation") then "9"
else 

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Retaining Wall") then "3"
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Alteration") then "3"
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Foundation Only") then "3"
else

if ([Record Type] = "Residential Building Permit" and [Type of Work] = "New Construction") then "1"
else


if ([Record Type] = "Residential Building Permit" and [Type of Work] = "Addition") then "3"

else "Review"