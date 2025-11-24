
CREATE SEQUENCE public.genres_id_genre_seq;

CREATE TABLE public.Genres (
                id_genre INTEGER NOT NULL DEFAULT nextval('public.genres_id_genre_seq'),
                genre VARCHAR NOT NULL,
                CONSTRAINT genres_pk PRIMARY KEY (id_genre)
);


ALTER SEQUENCE public.genres_id_genre_seq OWNED BY public.Genres.id_genre;

CREATE SEQUENCE public.directors_id_director_seq_1;

CREATE TABLE public.Directors (
                id_director INTEGER NOT NULL DEFAULT nextval('public.directors_id_director_seq_1'),
                name VARCHAR NOT NULL,
                CONSTRAINT directors_pk PRIMARY KEY (id_director)
);


ALTER SEQUENCE public.directors_id_director_seq_1 OWNED BY public.Directors.id_director;

CREATE SEQUENCE public.movies_id_movie_seq;

CREATE TABLE public.Movies (
                id_movie INTEGER NOT NULL DEFAULT nextval('public.movies_id_movie_seq'),
                original_title VARCHAR NOT NULL,
                overview VARCHAR,
                release_date DATE NOT NULL,
                status VARCHAR NOT NULL,
                vote_average NUMERIC,
                vote_count INTEGER,
                actors VARCHAR,
                original_language VARCHAR,
                homepage VARCHAR,
                title VARCHAR NOT NULL,
                CONSTRAINT movies_pk PRIMARY KEY (id_movie)
);


ALTER SEQUENCE public.movies_id_movie_seq OWNED BY public.Movies.id_movie;

CREATE SEQUENCE public.relations_id_relations_seq;

CREATE TABLE public.Relations (
                id_relations INTEGER NOT NULL DEFAULT nextval('public.relations_id_relations_seq'),
                id_movie INTEGER NOT NULL,
                id_director INTEGER NOT NULL,
                id_genre INTEGER NOT NULL,
                CONSTRAINT relations_pk PRIMARY KEY (id_relations)
);


ALTER SEQUENCE public.relations_id_relations_seq OWNED BY public.Relations.id_relations;

ALTER TABLE public.Relations ADD CONSTRAINT genres_relations_fk
FOREIGN KEY (id_genre)
REFERENCES public.Genres (id_genre)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Relations ADD CONSTRAINT directors_relations_fk
FOREIGN KEY (id_director)
REFERENCES public.Directors (id_director)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Relations ADD CONSTRAINT movies_relations_fk
FOREIGN KEY (id_movie)
REFERENCES public.Movies (id_movie)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
