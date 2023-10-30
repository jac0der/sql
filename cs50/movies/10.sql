-- write a SQL query to list the names of all people who have directed a movie that 
-- received a rating of at least 9.0.
-- If a person directed more than one movie that received a rating of at least 9.0, 
-- they should only appear in your results once.
SELECT
    DISTINCT(name)
FROM
    people p
JOIN
    directors d
ON
    p.id = d.person_id
JOIN
    movies m
ON
    m.id = d.movie_id
JOIN
    ratings r
ON
    r.movie_id = m.id
WHERE
    r.rating >= 9.0;
