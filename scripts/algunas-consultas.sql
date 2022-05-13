/*
  Corriendo algunas queries en la base de datos `afiliacion_db`.
  Para entrar y usarla, debo ejecutar el comando:
     `psql -U practica_pg -d afiliacion_db`
*/

-- Formo la tabla original con 15 filas.
SELECT categoria.categoria, partidos.partido,
       partidos.sigla_partido, rango_edad.rango_edad,
       genero.genero, comunas.comuna, regiones.region
FROM afiliacion
INNER JOIN categoria on afiliacion.categoria_id = categoria.id
INNER JOIN partidos ON afiliacion.sigla_id = partidos.id
INNER JOIN rango_edad ON afiliacion.edad_id = rango_edad.id
INNER JOIN genero ON afiliacion.genero_id = genero.id
INNER JOIN comunas ON afiliacion.comuna_id = comunas.id
INNER JOIN regiones ON afiliacion.region_id = regiones.id
LIMIT 15;


-- Veo en qué partidos militan las personas que viven en el extranjero.
SELECT partidos.partido, partidos.sigla_partido
FROM afiliacion
INNER JOIN regiones ON regiones.id = afiliacion.region_id
INNER JOIN partidos ON partidos.id = afiliacion.sigla_id
WHERE regiones.region = 'INTERNACIONAL'
LIMIT 15;

-- Cantidad de militantes por partidos en la comuna de Quilicura
-- ordenados en forma decreciente.
SELECT partidos.partido, partidos.sigla_partido,
       COUNT(partidos.sigla_partido) as cantidad
FROM afiliacion
INNER JOIN partidos ON partidos.id = afiliacion.partido_id
INNER JOIN comunas ON comunas.id = afiliacion.comuna_id
WHERE comuna = 'Quilicura'
GROUP BY (partido, sigla_partido)
ORDER BY cantidad DESC;

