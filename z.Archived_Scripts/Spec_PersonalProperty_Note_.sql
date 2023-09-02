





SELECT 
id AS [NoteTableID],
objectId AS [lrsn],
noteText AS [PPNotes]
FROM Note
WHERE noteText LIKE '%2023%' AND '%Annual%'
OR noteText LIKE '%2023%' AND '%Non Return%'
