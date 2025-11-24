
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
    (1,2,3)
);

SELECT * FROM relations;