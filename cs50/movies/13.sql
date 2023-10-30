-- write a SQL query to list the names of all people who starred in a movie in which Kevin Bacon 
 -- also starred.
-- There may be multiple people named Kevin Bacon in the database. Be sure to only select the 
-- Kevin Bacon born in 1958.
-- Kevin Bacon himself should not be included in the resulting list.
SELECT
    DISTINCT(p.name)
FROM
    people p
JOIN
    stars s
ON
    p.id = s.person_id
JOIN
    movies m
ON
    m.id = s.movie_id
WHERE
    m.id
IN
(
    -- find all movies in which Kevin Bacon who was born in 1958 starred in.
    SELECT
        s.movie_id
    FROM
        people p
    JOIN
        stars s
    ON
        p.id = s.person_id
    WHERE
        p.name = 'Kevin Bacon'
    AND
        p.birth = 1958
)
AND
    p.name != 'Kevin Bacon';