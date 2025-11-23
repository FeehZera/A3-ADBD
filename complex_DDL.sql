
CREATE SEQUENCE public.directors_id_director_seq_1;

CREATE TABLE public.Directors (
                id_director INTEGER NOT NULL DEFAULT nextval('public.directors_id_director_seq_1'),
                name VARCHAR NOT NULL,
                CONSTRAINT directors_pk PRIMARY KEY (id_director)
);


ALTER SEQUENCE public.directors_id_director_seq_1 OWNED BY public.Directors.id_director;

CREATE TABLE public.Movies (
                id_movie INTEGER NOT NULL,
                original_title VARCHAR NOT NULL,
                overview VARCHAR,
                genre VARCHAR,
                release_date DATE NOT NULL,
                status VARCHAR NOT NULL,
                vote_average NUMERIC,
                vote_count INTEGER,
                cast_1 VARCHAR,
                original_language VARCHAR,
                homepage VARCHAR,
                id_director INTEGER NOT NULL,
                title VARCHAR NOT NULL,
                CONSTRAINT movies_pk PRIMARY KEY (id_movie)
);


ALTER TABLE public.Movies ADD CONSTRAINT directors_movies_fk
FOREIGN KEY (id_director)
REFERENCES public.Directors (id_director)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
