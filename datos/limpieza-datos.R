# options(help_type = "text")

if(file.exists("afiliacion_data.rds")) {
  unlink("afiliacion_data.rds")
}

if(!file.exists("partidos20210831.csv")) {
  unzip(zipfile = "afiliacion-data.zip")
}

afiliacion_data <- read.csv(
  file = "partidos20210831.csv",
  sep = ";"
)

unlink(x = "partidos20210831.csv")

names(x = afiliacion_data) <- names(x = afiliacion_data) |>
  tolower() |>
  gsub(pattern = "\\.", replacement = "_") |>
  iconv(to = "ASCII//TRANSLIT")

names(x = afiliacion_data)[9] <- "genero"

# Vectorizar antes del loop hace todo más rápido :P
partido_sigla <- c("EVOPOLI","IGUALDAD","NT","PDG","PRO","RN","RD","PS",
                   "COMUNES","PCCH","CS","DC","PH","UPA","CIUDADANOS",
                   "FRVS","PPD","PRSD","PRI","UDI","PEV","PR","PL","PNC",
                   "PTR","PCC")

partido_nombres <- unique(x = afiliacion_data$partido)

partidos <- afiliacion_data$partido

length_partidos <- length(partidos)

sigla_partido <- character(length = length_partidos)

for(i in seq_len(length_partidos)) {
  sigla_partido[i] <- partido_sigla[partidos[i] == partido_nombres]
}

afiliacion_data$sigla_partido <- sigla_partido

# Quito y ordeno columnas.
afiliacion_data <- afiliacion_data[, c(1, 5, 12, 6, 9, 3, 8)]

# Debe abrirse con la función `readRDS`.
saveRDS(object = afiliacion_data, file = "afiliacion_data.rds")

removing <- c("afiliacion_data", "i", "length_partidos",
              "partido_nombres", "partido_sigla", "partidos",
              "sigla_partido")

rm(list = ls()[ls() %in% removing], removing)

