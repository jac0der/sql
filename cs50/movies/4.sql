-- write a SQL query to determine the number of movies with an IMDb rating of 10.0.
SELECT
    COUNT(*)
FROM
    movies m
JOIN
    ratings r
ON m.id = r.movie_id
WHERE
    r.rating = 10.0;