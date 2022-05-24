/*
  Preámbulo:
    Más info del comando \copy en:
    https://www.postgresql.org/docs/current/app-psql.html
*/

/*
==================================================
  1. Creación de la base de datos y de su esquema.
==================================================
*/

-- 1.1 Creando la base de datos.
DROP DATABASE IF EXISTS afiliacion_db;

CREATE DATABASE afiliacion_db;

-- 1.2 Se crea un esquema y se define el `search_path` para éste.
DROP SCHEMA IF EXISTS afiliacion_sch CASCADE;

CREATE SCHEMA afiliacion_sch;

ALTER DATABASE afiliacion_db
SET search_path TO "$user",afiliacion_sch;

/*
Si queremos reiniciar el `search_path`, ejecutamos el comando:

ALTER DATABASE afiliacion_db
RESET search_path;

Y luego nos reconectamos con \c afiliacion_db

Posteriormente, para verificar corremos `SHOW search_path;`.
*/


/* 
============================
  2. Creación de las tablas.
============================
*/

-- 2.1 Categoria.
DROP TABLE IF EXISTS categoria CASCADE; -- CASCADE quita la FK de tablas vinculadas a esta.

CREATE TABLE categoria (
  id SERIAL PRIMARY KEY,
  categoria VARCHAR(20) UNIQUE NOT NULL
);

\copy categoria (categoria) FROM '..\tablas\categoria.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2.2 Género.
DROP TABLE IF EXISTS genero CASCADE;

CREATE TABLE genero (
  id SERIAL PRIMARY KEY,
  genero VARCHAR(15) UNIQUE NOT NULL
);

\copy genero (genero) FROM '..\tablas\genero.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2.3 Rango etáreo.
DROP TABLE IF EXISTS rango_edad CASCADE;

CREATE TABLE rango_edad (
  id SERIAL PRIMARY KEY,
  rango_edad VARCHAR(20) UNIQUE NOT NULL
);

\copy rango_edad (rango_edad) FROM '..\tablas\rango-edad.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2.4 Partidos.
DROP TABLE IF EXISTS partidos CASCADE;

CREATE TABLE partidos (
  id SERIAL PRIMARY KEY,
  partido VARCHAR(50) NOT NULL,
  sigla_partido VARCHAR(15) NOT NULL,
  UNIQUE (partido, sigla_partido)
);

\copy partidos (partido, sigla_partido) FROM '..\tablas\partidos.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2.5 Regiones.
DROP TABLE IF EXISTS regiones CASCADE;

CREATE TABLE regiones (
  id SERIAL PRIMARY KEY,
  region VARCHAR(50) UNIQUE NOT NULL
);

\copy regiones (region) FROM '..\tablas\regiones.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2.6 Comunas.
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

-- 2.7 Afiliacion partidos.
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

