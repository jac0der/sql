-- write a SQL query that returns the average energy of songs that are by Drake.
SELECT
    AVG(s.energy) [Average Energy]
FROM
    songs s
JOIN
    artists a
ON
    s.artist_id = a.id
WHERE
    a.name = 'Drake';
