/*
  Preámbulo:
    Más info del comando \copy en:
    https://www.postgresql.org/docs/current/app-psql.html
*/
-- Creando la base de datos.
DROP DATABASE IF EXISTS afiliacion_db;

CREATE DATABASE afiliacion_db;

/* 
==========================
  Creando las tablas.
==========================
*/

-- 1. Categoria.
DROP TABLE IF EXISTS categoria CASCADE; -- CASCADE quita la FK de tablas vinculadas a esta.

CREATE TABLE categoria (
  id SERIAL PRIMARY KEY,
  categoria VARCHAR(20) UNIQUE NOT NULL
);

\copy categoria (categoria) FROM '..\tablas\categoria.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2. Género.
DROP TABLE IF EXISTS genero CASCADE;

CREATE TABLE genero (
  id SERIAL PRIMARY KEY,
  genero VARCHAR(15) UNIQUE NOT NULL
);

\copy genero (genero) FROM '..\tablas\genero.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 3. Rango etáreo.
DROP TABLE IF EXISTS rango_edad CASCADE;

CREATE TABLE rango_edad (
  id SERIAL PRIMARY KEY,
  rango_edad VARCHAR(20) UNIQUE NOT NULL
);

\copy rango_edad (rango_edad) FROM '..\tablas\rango-edad.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 4. Partidos.
DROP TABLE IF EXISTS partidos CASCADE;

CREATE TABLE partidos (
  id SERIAL PRIMARY KEY,
  partido VARCHAR(50) NOT NULL,
  sigla_partido VARCHAR(15) NOT NULL,
  UNIQUE (partido, sigla_partido)
);

\copy partidos (partido, sigla_partido) FROM '..\tablas\partidos.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 5. Regiones.
DROP TABLE IF EXISTS regiones CASCADE;

CREATE TABLE regiones (
  id SERIAL PRIMARY KEY,
  region VARCHAR(50) UNIQUE NOT NULL
);

\copy regiones (region) FROM '..\tablas\regiones.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 6. Comunas.
DROP TABLE IF EXISTS comunas CASCADE;

CREATE TABLE comunas (
  id SERIAL PRIMARY KEY,
  comuna VARCHAR(70) UNIQUE NOT NULL,
  region_id INTEGER NOT NULL,
  CONSTRAINT region_id_fkey
    FOREIGN KEY (region_id)
      REFERENCES regiones (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

\copy comunas (comuna, region_id) FROM '..\tablas\comunas.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 7. Afiliacion partidos.
DROP TABLE IF EXISTS afiliacion CASCADE;

CREATE TABLE afiliacion (
  id SERIAL PRIMARY KEY,
  categoria_id INTEGER NOT NULL REFERENCES categoria (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  partido_id INTEGER NOT NULL REFERENCES partidos (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  edad_id INTEGER NOT NULL REFERENCES rango_edad (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  genero_id INTEGER NOT NULL REFERENCES genero (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  comuna_id INTEGER NOT NULL REFERENCES comunas (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  region_id INTEGER NOT NULL REFERENCES regiones (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Son 150000 filas, así que hay que esperar un pequeño momento :)
\copy afiliacion (categoria_id, partido_id, edad_id, genero_id, comuna_id, region_id) FROM '..\tablas\afiliacion-partidos.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

