# Normalizando una base de datos.

La idea de este repositorio fue, en primer lugar, aplicar la idea central de normalizar una base datos (reducir lo más posible la redundancia de información para mejorar su gestión) y luego usarla para practicar un poco en SQL usando PostgreSQL.

La base de datos con la que trabajo es sobre la militancia en partidos políticos en Chile. Ésta es publicada por el Servicio Electoral (SERVEL), quienes la construyen a partir de la información que deben entregar estas instituciones al organismo estatal luego de realizar sus procesos de afiliación. Corresponde a la actualización del 31 de agosto de 2021 y puede ser descargada [acá](https://www.servel.cl/wp-content/uploads/2021/09/partidos20210831.csv). Más detalles sobre estas estadísticas pueden encontrarse en el [siguiente enlace](https://www.servel.cl/estadisticas-de-partidos-politicos/).

Este conjunto de datos luce como se ve en la siguiente muestra de cinco filas:

```
Categoría Cedula Comuna        FECHA_RESP Partido            Rango edad Region Domicilio Región      Sexo     DV
--------- ------ ------        ---------- -------            ---------- ---------------- ------      ----     --
Nuevo     0      Alto Hospicio 08312021   EVOLUCION POLITICA 20-24 años De Tarapaca      De Tarapaca Femenino 0
Nuevo     0      Iquique       08312021   IGUALDAD           20-24 años De Tarapaca      De Tarapaca Femenino 0
Nuevo     0      Iquique       08312021   IGUALDAD           20-24 años De Tarapaca      De Tarapaca Femenino 0
Nuevo     0      Alto Hospicio 08312021   NUEVO TIEMPO       20-24 años De Tarapaca      De Tarapaca Femenino 0
Nuevo     0      Alto Hospicio 08312021   NUEVO TIEMPO       20-24 años De Tarapaca      De Tarapaca Femenino 0
```

Debido a que no entregan información relevante y, además, para aprovechar de reducir el peso del archivo, decidí quitar las siguientes columnas: `Cedula`, `FECHA_RESP` y `DV`. También saqué `Region Domicilio` ya que como mi idea es simplemente practicar, consideré que bastaba con `Región`.

Como la mayoría de las columnas restantes tiene información redundante (en cada una se repiten datos), decidí crear siete tablas:

- `categoria`.
- `genero`.
- `comunas`.
- `regiones`.
- `rango_edad`.
- `partidos`.
- `afiliacion`.

Estas tablas las almacené en una base de datos llamada `afiliacion_db` y la relación entre ellas está dada como se observa en el siguiente diagrama.

![Diagrama de relación de tablas](./img/diagrama-relaciones.png).

Para hacer el proceso más rápido, completé las tablas de la base de datos `afiliacion_db` creando previamente archivos `.csv` usando el lenguaje de programación R, cuyos scripts se pueden encontrar en la carpeta [`datos`](./datos/).

Por otra parte, los scripts para crear las tablas y ejecutar algunas consultas (*queries*) en PostgreSQL están en el directorio [`scripts`](./scripts/).

