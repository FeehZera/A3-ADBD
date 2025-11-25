
INSERT INTO movies (
    original_title,
    overview,
    release_date,
    status,
    vote_average,
    vote_count,
    actors,
    original_language,
    homepage,
    title
) VALUES (
    'Avatar',
    'Um ex-fuzileiro naval é enviado ao planeta Pandora e entra em conflito entre seguir ordens e proteger o novo mundo.',
    '2009-12-10',
    'Released',
    7.8,
    1200000,
    'Sam Worthington, Zoe Saldana, Sigourney Weaver',
    'en',
    'https://www.avatar.com',
    'Avatar'
);

SELECT * FROM movies;

INSERT into directors (name) VALUES ('James Cameron');
INSERT into genres(genre) VALUES ('Science Fiction');
INSERT into genres(genre) VALUES ('Adventure');
INSERT into genres(genre) VALUES ('Action');

SELECT * FROM directors;
SELECT * FROM genres;

INSERT INTO relations (
    id_movie,
    id_director,
    id_genre
) VALUES (
    (1),
    (1),
    (1)
);

SELECT * FROM relations;

SELECT * FROM directors;

SELECT * FROM genres;

SELECT * FROM movies where id_movie = 4804;

DELETE FROM relations;
DELETE FROM movies;
DELETE FROM genres;
DELETE FROM directors;

TRUNCATE TABLE directors, movies, relations, genres RESTART IDENTITY CASCADE;
--retorna filmes a partir de uma data
SELECT 
    title, 
    release_date 
FROM 
    public.Movies 
WHERE 
    release_date >= '2015-01-01';
--retorna filmes e diretores
SELECT 
    m.title AS filme,
    d.name AS diretor
FROM 
    public.Movies m
JOIN 
    public.Relations r ON m.id_movie = r.id_movie
JOIN 
    public.Directors d ON r.id_director = d.id_director;
--retorna filmes, diretores e media do votos
SELECT 
    g.genre, 
    COUNT(r.id_movie) AS total_filmes, 
    AVG(m.vote_average) AS media_votos
FROM 
    public.Genres g
JOIN 
    public.Relations r ON g.id_genre = r.id_genre
JOIN 
    public.Movies m ON r.id_movie = m.id_movie
GROUP BY 
    g.genre
HAVING 
    COUNT(r.id_movie) > 5;
--retorna filme e o voto de cada um
SELECT 
    title, 
    vote_average
FROM 
    public.Movies
WHERE 
    vote_average > (
        SELECT AVG(vote_average) FROM public.Movies
    );
--retorna filmes que possuem uma plavra especifica em seu titulo
SELECT 
    title, 
    overview 
FROM 
    public.Movies 
WHERE 
    title ILIKE '%Love%';
--retorna os 5 filmes com nota mais altas
    SELECT 
    title, 
    vote_average 
FROM 
    public.Movies 
WHERE 
    vote_average IS NOT NULL
ORDER BY 
    vote_average DESC 
LIMIT 5;
--retorna quantos lancamentos ocoreram em cada ano
SELECT 
    EXTRACT(YEAR FROM release_date) AS ano,
    COUNT(id_movie) AS total_lancamentos
FROM 
    public.Movies
GROUP BY 
    EXTRACT(YEAR FROM release_date)
ORDER BY 
    ano DESC;
--retona o total de diretores
SELECT 
    COUNT(DISTINCT id_director) AS total_diretores_unicos
FROM 
    public.Relations;
--retorna os filmes e seus elencos
SELECT 
    title, 
    actors 
FROM 
    public.Movies 
WHERE 
    actors ILIKE '%Brad Pitt%';
--retorna os generos com notas acima de 9
SELECT 
    g.genre
FROM 
    public.Genres g
WHERE EXISTS (
    SELECT 1 
    FROM public.Relations r 
    JOIN public.Movies m ON r.id_movie = m.id_movie
    WHERE r.id_genre = g.id_genre 
    AND m.vote_average > 9.0
);