/*
One SQL in Power Query runs the Certified Values
One SQL in Power QUery runs the Worksheet Values
Both to Connection Only 

Merge both queries into a final combined version, then run the following M calculations by "Add Column > Custom Column..."

Land % Change
if [Certified Land]=0 then
if [Worksheet_Land]=0 then 0 else 1
else ([Worksheet_Land]-[Certified Land])/ Number.Abs([Certified Land])

Imp % Change
if [Certified Imp]=0 then
if [Worksheet_Imp]=0 then 0 else 1
else ([Worksheet_Imp]-[Certified Imp])/Number.Abs([Certified Imp])

Total % Change
if [Certified Total Value]=0 then
if [Worksheet Total]=0 then 0 else 1
else ([Worksheet Total]-[Certified Total Value])/Number.Abs([Certified Total Value])


Set final columns to %

Fourth Conditional Column>

New Cert SF Rate
[Certified Land]/([Acres]*43560)

*/
























