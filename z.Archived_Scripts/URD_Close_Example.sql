/*
It looks like there is an error in the syntax of the SQL query provided. It should be:
*/

UPDATE DescrHeader
SET DisplayDescr = REPLACE(DisplayDescr, 'URD EAST PF 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'EAST PF URD 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'EAST PF URD 2005', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD EAST PF 2005', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS EAST URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PST FALLS EAST URD BSE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PST FALLS EAST URD BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PST FALLS URD EAST BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'E PF URD BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'E PF URD BS YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'E PF URD BASE YR 2005? OR 2002?', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'E POST FALLS URD BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'EAST POST FALLS URD BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'EAST POST FALLS URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'EAST PF URD 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF E URD BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF E URD BS YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF EAST BS YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF URD EAST PF BASE 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF EAST URD 2005', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF EAST URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF EAST URD BY 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF URD BS YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS EAST URD 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS EAST URD BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS URD BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF URD 03 PF EAST', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD PF EAST BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD EAST PF 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD 03 PF EAST', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD PF 03', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD 03 PR EAST  (sic)', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD POST FALLS EAST BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD POST FALLS E BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD EAST OST FALLS BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD EAST POST FALLS BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, '03 POST FALLS EAST URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, '03 PF EAST', ' ');

/*  
AND THIS ONE
*/

  UPDATE DescrHeader
SET DisplayDescr = REPLACE(DisplayDescr, 'CENTER POINT URD 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'CENTER POINT URD BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'CENTER POINT URD 2005', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'CENTER POINT URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD CTR POINT 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD CENTER POINT 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD CENTER POINT BASE YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD PF CENTER POINT', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS CTR POINT URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS CNTR POINTE URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PST FALLS CENTER PT URD BS YR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PST FALLS CENTER POINT URD BASE YEAR 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS CENTER POINT URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS CENTER POINT URD 2002', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'PF CTR POINT URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD 01 PF CTR POINTE', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'POST FALLS CNTR POINTE URD', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD 01 PF CTR PT', ' '),
    DisplayDescr = REPLACE(DisplayDescr, 'URD 01 PF CTR POINTE', ' '),
    DisplayDescr = REPLACE(DisplayDescr, '01 POST FALLS CTR POINT URD', ' ');


  
