
CREATE SEQUENCE directors_id_director_seq_1;

CREATE TABLE Directors (
                id_director INTEGER NOT NULL DEFAULT nextval('directors_id_director_seq_1'),
                name VARCHAR NOT NULL,
                CONSTRAINT directors_pk PRIMARY KEY (id_director)
);


ALTER SEQUENCE directors_id_director_seq_1 OWNED BY Directors.id_director;

CREATE TABLE Movies (
                id_movie INTEGER NOT NULL,
                original_title VARCHAR NOT NULL,
                overview VARCHAR,
                genre VARCHAR,
                release_date DATE NOT NULL,
                status VARCHAR NOT NULL,
                vote_average NUMERIC,
                vote_count INTEGER NOT NULL,
                cast_1 VARCHAR,
                original_language VARCHAR,
                homepage VARCHAR,
                id_director INTEGER NOT NULL,
                CONSTRAINT movies_pk PRIMARY KEY (id_movie)
);


ALTER TABLE Movies ADD CONSTRAINT directors_movies_fk
FOREIGN KEY (id_director)
REFERENCES Directors (id_director)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
