
library(dplyr)
library(tidyr)
library(jsonlite)
library(httr2)

datos_inegi_total <- function(id_indicador, token, banco) {
  
  # 1. Definición de la sub-función de descarga
  datos_inegi_v2 <- function(id_indicador, token) {
    
    # URL para serie HISTÓRICA completa
    url <- paste0(
      "https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
      id_indicador, "/es/00/false/BIE-BISE/2.0/", token, "?type=json"
    )
    
    dest_file <- "datos_inegi_temporal.json"
    
    # Intentamos descargar el archivo físicamente a tu computadora primero
    # Esto suele saltarse el error de 'lexical error' porque no lo lee en memoria de inmediato
    tryCatch({
      download.file(url, 
                    destfile = dest_file, 
                    method = "libcurl", # Método más robusto
                    quiet = TRUE, 
                    mode = "wb",
                    headers = c("User-Agent" = "Mozilla/5.0"))
      
      # Leemos el archivo descargado
      json_data <- jsonlite::fromJSON(dest_file)
      
      # Limpiamos el archivo temporal
      if (file.exists(dest_file)) file.remove(dest_file)
      
      return(json_data$Series$OBSERVATIONS[[1]])
      
    }, error = function(e) {
      message("Error al descargar: ", e$message)
      return(NULL)
    })
  }
  
  # 2. Ejecución de la descarga
  df <- datos_inegi_v2(id_indicador, token)
  
  if (is.null(df)) stop("No se pudieron obtener datos.")
  
  # 3. Procesamiento y Ordenamiento
  df_clean <- df %>%
    mutate(OBS_VALUE = as.numeric(OBS_VALUE)) %>%
    arrange(TIME_PERIOD)
  
  # 4. Extracción de Metadatos de Fecha
  fecha_inicio_txt <- first(df_clean$TIME_PERIOD)
  partes <- as.numeric(strsplit(fecha_inicio_txt, "/")[[1]])
  
  anio_ini <- partes[1]
  per_ini  <- if(length(partes) > 1) partes[2] else 1
  
  # Frecuencia automática
  freq_detectada <- n_distinct(sub(".*/", "", df_clean$TIME_PERIOD))
  
  # 5. Conversión a Serie de Tiempo
  serie_ts <- ts(df_clean$OBS_VALUE, 
                 start = c(anio_ini, per_ini), 
                 frequency = freq_detectada)
  
  # 6. Visualización
  plot(serie_ts, main = paste("Indicador:", id_indicador), 
       ylab = "Valor", xlab = "Tiempo", col = "blue", lwd = 2)
  
  # 7. Información de salida
  cat("--- Resumen de la Serie ---\n")
  cat("Inicio detectado:", anio_ini, "/", per_ini, "\n")
  cat("Frecuencia:", freq_detectada, "\n")
  cat("Registros:", length(serie_ts), "\n")
  
  return(serie_ts)
}

inegi.graficar <- function(st, pronostico, tendencia){
autoplot(st) +
  autolayer(pronostico, series = "Pronóstico") +
  autolayer(tendencia, series = "Tendencia ") +
  xlab("Año") +
  ylab("$") +
  ggtitle("Impuestos") +
  guides(colour = guide_legend(title = "Pronóstico"))
}
