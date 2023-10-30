-- write a SQL query to list the titles of the five highest rated movies (in order) 
-- that Chadwick Boseman starred in, starting with the highest rated.
-- You may assume that there is only one person in the database with the name Chadwick Boseman.
SELECT
    title
FROM
    people p
JOIN
    stars s
ON
    p.id = s.person_id
JOIN
    movies m
ON
    s.movie_id = m.id
JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    p.name = 'Chadwick Boseman'
ORDER BY
    r.rating DESC
LIMIT 5;