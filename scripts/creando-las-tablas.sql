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
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
  id INTEGER PRIMARY KEY NOT NULL,
  categoria VARCHAR(20) UNIQUE NOT NULL
);

\copy categoria (id, categoria) FROM '..\tablas\categoria.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 2. Género.
DROP TABLE IF EXISTS genero;

CREATE TABLE genero (
  id INTEGER PRIMARY KEY NOT NULL,
  genero VARCHAR(15) UNIQUE NOT NULL
);

\copy genero (id, genero) FROM '..\tablas\genero.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 3. Rango etáreo.
DROP TABLE IF EXISTS rango_edad;

CREATE TABLE rango_edad (
  id INTEGER PRIMARY KEY NOT NULL,
  rango_edad VARCHAR(20) UNIQUE NOT NULL
);

\copy rango_edad (id, rango_edad) FROM '..\tablas\rango-edad.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 4. Partidos.
DROP TABLE IF EXISTS partidos;

CREATE TABLE partidos (
  id INTEGER PRIMARY KEY NOT NULL,
  partido VARCHAR(50) NOT NULL,
  sigla_partido VARCHAR(15) NOT NULL
  UNIQUE (partido, sigla_partido)
);

\copy partidos (id, partido, sigla_partido) FROM '..\tablas\partidos.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 5. Regiones.
DROP TABLE IF EXISTS regiones;

CREATE TABLE regiones (
  id INTEGER PRIMARY KEY NOT NULL,
  region VARCHAR(50) UNIQUE NOT NULL
);

\copy regiones (id, region) FROM '..\tablas\regiones.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 6. Comunas.
DROP TABLE IF EXISTS comunas;

CREATE TABLE comunas (
  id INTEGER PRIMARY KEY NOT NULL,
  comuna VARCHAR(70) UNIQUE NOT NULL,
  region_id INTEGER NOT NULL,
  CONSTRAINT region_id_fkey
    FOREIGN KEY (region_id)
      REFERENCES regiones (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

\copy comunas (id, comuna, region_id) FROM '..\tablas\comunas.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

-- 7. Afiliacion partidos.
DROP TABLE IF EXISTS afiliacion;

CREATE TABLE afiliacion (
  id INTEGER PRIMARY KEY NOT NULL,
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
\copy afiliacion (id, categoria_id, partido_id, edad_id, genero_id, comuna_id, region_id) FROM '..\tablas\afiliacion-partidos.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER, ENCODING 'utf8')

