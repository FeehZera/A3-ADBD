import sqlalchemy
import pandas
import psycopg2
import openpyxl

import pandas as pd
from sqlalchemy import create_engine, text


# 1. CONFIGURAÇÕES
DB_URL = "postgresql://postgres:123456@192.168.15.10:5432/movie"  # AJUSTE AQUI
EXCEL_PATH = "data.xlsx"  # caminho do seu arquivo .xlsx

# 2. FUNÇÃO AUXILIAR PARA GÊNEROS
def explode_genres(genres_str):
    """
    Recebe algo como:
        'Drama, Action, Adventure, Science_Fiction'
    e devolve:
        ['Drama', 'Action', 'Adventure', 'Science_Fiction']
    """
    if pd.isna(genres_str):
        return []
    return [g.strip() for g in str(genres_str).split(",") if g.strip()]


# 3. LER EXCEL
df = pd.read_excel(EXCEL_PATH)

# Corrige nome de coluna se vier como release_data
if "release_data" in df.columns and "release_date" not in df.columns:
    df = df.rename(columns={"release_data": "release_date"})

# 4. CONECTAR NO POSTGRES
engine = create_engine(DB_URL)

# -----------------------------
# 5. CARREGAR DIRECTORS (sem _tmp)
# -----------------------------
# diretores únicos a partir do Excel
directors_df = (
    df["director"]
    .dropna()
    .drop_duplicates()
    .to_frame(name="name")
)

with engine.begin() as conn:
    # Busca diretores que já existem
    existing = conn.execute(text("SELECT id_director, name FROM directors;")).fetchall()
    existing_map = {row.name: row.id_director for row in existing}

    # Filtra só os que ainda não existem
    new_directors_df = directors_df[~directors_df["name"].isin(existing_map.keys())]

    # Insere só os novos
    if not new_directors_df.empty:
        new_directors_df.to_sql("directors", conn, if_exists="append", index=False)

    # Atualiza o mapa com tudo
    all_rows = conn.execute(text("SELECT id_director, name FROM directors;")).fetchall()
    director_map = {row.name: row.id_director for row in all_rows}

# -----------------------------
# 6. CARREGAR GENRES (sem _tmp)
# -----------------------------
all_genres = set()
for g_str in df["genres"]:
    all_genres.update(explode_genres(g_str))

genres_df = pd.DataFrame(sorted(all_genres), columns=["genre"])

with engine.begin() as conn:
    existing = conn.execute(text("SELECT id_genre, genre FROM genres;")).fetchall()
    existing_map = {row.genre: row.id_genre for row in existing}

    new_genres_df = genres_df[~genres_df["genre"].isin(existing_map.keys())]

    if not new_genres_df.empty:
        new_genres_df.to_sql("genres", conn, if_exists="append", index=False)

    all_rows = conn.execute(text("SELECT id_genre, genre FROM genres;")).fetchall()
    genre_map = {row.genre: row.id_genre for row in all_rows}

# -----------------------------
# 7. CARREGAR MOVIES
# -----------------------------
movies_df = pd.DataFrame({
    "original_title":    df["original_title"],
    "overview":          df["overview"],
    "release_date":      pd.to_datetime(df["release_date"], errors="coerce"),
    "status":            df["status"],
    "vote_average":      df["vote_average"],
    "vote_count":        df["vote_count"],
    "actors":            df["cast"],
    "original_language": df["original_language"],
    "homepage":          df["homepage"],
    "title":             df["title"],
})

with engine.begin() as conn:
    # Insere movies (id_movie gerado pelo banco)
    movies_df.to_sql("movies", conn, if_exists="append", index=False)

    # Recupera todos os filmes com seus ids
    rows = conn.execute(text("""
        SELECT id_movie, title, original_title
        FROM movies
        ORDER BY id_movie;
    """)).fetchall()

# mapa (title, original_title) -> id_movie
movie_map = {
    (r.title, r.original_title): r.id_movie
    for r in rows
}

# -----------------------------
# 8. CARREGAR RELATIONS
# -----------------------------
relations_rows = []

for _, row in df.iterrows():
    title = row["title"]
    orig_title = row["original_title"]
    director_name = row["director"]
    genres_str = row["genres"]

    id_movie = movie_map.get((title, orig_title))
    id_director = director_map.get(director_name)

    if id_movie is None or id_director is None:
        # pula linha quebrada
        continue

    for g in explode_genres(genres_str):
        id_genre = genre_map.get(g)
        if id_genre is None:
            continue

        relations_rows.append({
            "id_movie": id_movie,
            "id_director": id_director,
            "id_genre": id_genre,
        })

relations_df = pd.DataFrame(relations_rows)

with engine.begin() as conn:
    relations_df.to_sql("relations", conn, if_exists="append", index=False)

print("Carga concluída com sucesso (sem tabelas temporárias).")