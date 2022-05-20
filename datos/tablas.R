#############################################
#       Rscript para crear las tablas       #
#############################################

# En este script se encuentra el código para crear las tablas que son
# almacenadas en archivos `.csv` y guardadas en la carpeta `..\tablas`.


# 1. Carga de datos y creación de la función `create_table`. ----
if(!file.exists("afiliacion_data.rds")) source(file = "limpieza-datos.R")

afiliacion_df <- readRDS(file = "afiliacion_data.rds")

create_table <- function(col) {
  # Regresa un data.frame debido a `drop = FALSE` en `subset()`.
  unique_values <- unique(
    x = subset(x = afiliacion_df, select = col)
  )

  # Reinicio nombres de filas.
  rownames(unique_values) <- NULL

  unique_values
}


# 2. Creando las tablas. ----

# 2.1 Categoría.
categoria <- create_table("categoria")

# 2.2 Género.
genero <- create_table("genero")

# 2.3 Rango de edad.
rango_edad <- create_table("rango_edad")
rango_edad$rango_edad <- sort(x = rango_edad$rango_edad)

# 2.4 Región.
regiones <- create_table("region")

region <- regiones$region

region_index <- c(6, 1, 11, 13, 14, 2, 5, 9, 8,
                  10, 7, 12, 16, 15, 4, 17, 3)

for(i in seq_len(length(region))) {
  regiones$region[i] <- region[region_index[i]]
}

rm(region, region_index, i)

# 2.5 Comuna.
comunas <- create_table(c("comuna", "region"))

id_region <- as.integer(rownames(regiones))

region_id <- integer(length = nrow(comunas))

for(i in seq_len(nrow(comunas))) {
  region_id[i] <- id_region[
    comunas$region[i] == regiones$region
  ]
}

comunas$region_id <- region_id
comunas <- comunas[, -2]

rm(i, region_id, id_region)

# 2.6 Partidos.
partidos <- create_table(c("partido", "sigla_partido"))

# 2.7 Afiliación partidos.
length_df <- nrow(afiliacion_df)

categoria_id <- partido_id <- edad_id <-
genero_id <- comuna_id <- region_id <- integer(length = length_df)

categoria_index <- as.integer(rownames(categoria))
partido_index <- as.integer(rownames(partidos))
edad_index <- as.integer(rownames(rango_edad))
genero_index <- as.integer(rownames(genero))
comuna_index <- as.integer(rownames(comunas))
region_index <- as.integer(rownames(regiones))

# ¿Se podría hacer mejor? Quizá...
for(i in seq_len(length_df)) {
  categoria_id[i] <- categoria_index[
    afiliacion_df$categoria[i] == categoria$categoria
  ]
  partido_id[i] <- partido_index[
    afiliacion_df$partido[i] == partidos$partido
  ]
  edad_id[i] <- edad_index[
      afiliacion_df$rango_edad[i] == rango_edad$rango_edad
  ]
  genero_id[i] <- genero_index[
      afiliacion_df$genero[i] == genero$genero
  ]
  comuna_id[i] <- comuna_index[
      afiliacion_df$comuna[i] == comunas$comuna
  ]
  region_id[i] <- region_index[
      afiliacion_df$region[i] == regiones$region
  ]
}

afiliacion_partidos <- data.frame(
  categoria_id, partido_id, edad_id, genero_id, comuna_id, region_id
)

# Tomo una muestra aleatoria de 150000 filas para no usar mucha memoria.
set.seed(2022)
muestra <- sample(x = nrow(afiliacion_partidos), size = 1.5e+05)
afiliacion_partidos <- afiliacion_partidos[muestra, ]

rownames(afiliacion_partidos) <- NULL # Reinicio nombre de filas.

afiliacion_partidos$id <- as.integer(rownames(afiliacion_partidos))

rm(length_df, i, categoria_id, partido_id, edad_id,
   genero_id, comuna_id, region_id, muestra, categoria_index,
   partido_index, edad_index, genero_index, comuna_index,
   region_index)


# 3. Creando los archivos .csv ----
obj_names <- c("afiliacion_partidos", "categoria", "comunas", "genero",
              "partidos", "rango_edad", "regiones")
table_names <- gsub(pattern = "_", replacement = "-", x = obj_names)
path_folder <- "../tablas"

if(!dir.exists(path = path_folder)) dir.create(path = path_folder)

for(i in seq_len(length(obj_names))) {
  write.csv(
    x = get(x = obj_names[i]),
    file = file.path(path_folder, paste0(table_names[i], ".csv")),
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )
}

rm(obj_names, table_names, path_folder, i)


# 4. Limpieza final. ----
rm(afiliacion_df, afiliacion_partidos, categoria, comunas, create_table,
   genero, partidos, rango_edad, regiones)

