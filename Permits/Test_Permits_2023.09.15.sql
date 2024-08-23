






--Additional Data
p.cost_estimate AS [COST ESTIMATE],
p.sq_ft AS [ESTIMATED SF],

--Other Dates
LTRIM(RTRIM(p.permit_source)) AS [PERMIT SOURCE],
p.filing_date AS [FILING DATE],
p.permservice AS [PERMANENT SERVICE DATE],
f.field_out AS [WORK ASSIGNED DATE],


JOIN permits AS p ON parcel.lrsn=p.lrsn
  AND p.status= 'A' 

LEFT JOIN field_visit AS f ON p.field_number=f.field_number
  AND f.status='A'