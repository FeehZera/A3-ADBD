CREATE DATABASE Movie;

CREATE TABLE Movies (
    genres TEXT,
    original_language VARCHAR(5),
    release_date DATE,
    status VARCHAR(50),
    title TEXT,
    vote_average NUMERIC,
    vote_count INT,
    director TEXT
);