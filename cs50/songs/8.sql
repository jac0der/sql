-- write a SQL query that lists the names of the songs that feature other artists.
-- songs that feature other artists will include “feat.” in the name of the song.
SELECT
    name
FROM
    songs
WHERE
    name like '%feat%';
