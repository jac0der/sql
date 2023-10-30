-- write a SQL query to list the titles of all movies in which both Bradley Cooper and 
-- Jennifer Lawrence starred.
-- You may assume that there is only one person in the database with the name Bradley Cooper.
-- You may assume that there is only one person in the database with the name Jennifer Lawrence.
-- USING IMPLICIT JOIN SYNTAX HERE....
SELECT
    m.title
FROM
    people p, stars s, movies m
WHERE
    p.id = s.person_id
AND
    s.movie_id = m.id
AND
    m.id IN
(
    SELECT
        s.movie_id
    FROM
        stars s
    WHERE
        s.person_id
    IN
    (
        SELECT
            p.id
        FROM
            people p
        WHERE
            p.name = 'Bradley Cooper'
    )
)
AND
    p.name = 'Jennifer Lawrence';