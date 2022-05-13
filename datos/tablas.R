# options(help_type = "text")

if(!file.exists("afiliacion_data.rds")) source(file = "limpieza-datos.R")

afiliacion_df <- readRDS(file = "afiliacion_data.rds")

create_table <- function(col) {
  stopifnot(is.character(col))
  stopifnot(col %in% names(afiliacion_df))

  values <- unique(x = afiliacion_df[, col])

  if(class(values) == "data.frame") {
    rownames(values) <- NULL
    id <- 1:nrow(values)
    df <- cbind(id, values)
  } else {
    id <- 1:length(values)
    df <- data.frame(id, values)
    names(df)[2] <- col
  }
  
  return(df)
}


# Tablas ----

# 1. Categoría.
categoria <- create_table("categoria")

# 2. Género.
genero <- create_table("genero")

# 3. Rango de edad.
rango_edad <- create_table("rango_edad")
rango_edad$rango_edad <- sort(x = rango_edad$rango_edad)

# 4. Región.
regiones <- create_table("region")

region <- regiones$region

region_index <- c(6, 1, 11, 13, 14, 2, 5, 9, 8,
                  10, 7, 12, 16, 15, 4, 17, 3)

for(i in seq_len(length(region))) {
  regiones$region[i] <- region[region_index[i]]
}

rm(region, region_index, i)

# 5. Comuna.
comunas <- create_table(c("comuna", "region"))

id_region <- regiones$id

region_id <- integer(length = length(comunas$comuna))

for(i in seq_len(length(comunas$comuna))) {
  region_id[i] <- id_region[
    comunas$region[i] == regiones$region
  ]
}

comunas$region <- region_id
names(comunas)[3] <- "region_id"

rm(i, region_id, id_region)

# 6. Partidos.
partidos <- create_table(c("partido", "sigla_partido"))

#7. Afiliación partidos.

length_df <-nrow(afiliacion_df)

categoria_id <- integer(length = length_df)
partido_id <- integer(length = length_df)
edad_id <- integer(length = length_df)
genero_id <- integer(length = length_df)
comuna_id <- integer(length = length_df)
region_id <- integer(length = length_df)

# ¿Se podría hacer mejor? Quizá...
for(i in seq_len(length_df)) {
  categoria_id[i] <- categoria$id[
    afiliacion_df$categoria[i] == categoria$categoria
  ]
  partido_id[i] <- partidos$id[
    afiliacion_df$partido[i] == partidos$partido
  ]
  edad_id[i] <- rango_edad$id[
      afiliacion_df$rango_edad[i] == rango_edad$rango_edad
  ]
  genero_id[i] <- genero$id[
      afiliacion_df$genero[i] == genero$genero
  ]
  comuna_id[i] <- comunas$id[
      afiliacion_df$comuna[i] == comunas$comuna
  ]
  region_id[i] <- regiones$id[
      afiliacion_df$region[i] == regiones$region
  ]
}

afiliacion_partidos <- data.frame(
  id = 1:length_df, categoria_id, partido_id, sigla_id = partido_id,
  edad_id, genero_id, comuna_id, region_id
)

rm(length_df, i, categoria_id, partido_id, edad_id,
   genero_id, comuna_id, region_id)


# Creando los archivos .csv ----
table_name <- ls()[-c(1, 5)]
path_folder <- "../tables/"

if(!dir.exists(path = path_folder)) dir.create(path = path_folder)

for(i in seq_len(length(table_name))) {
  write.csv(
    x = get(x = table_name[i]),
    file = paste0(path_folder, table_name[i], ".csv"),
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )
}

rm(table_name, path_folder, i)

