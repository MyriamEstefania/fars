#' Lee un archivo de datos csv
#'
#' Esta funcion permite leer un archivo de datos csv y mostrar en la consola
#'
#' @param filename nombre del archivo que se quiere leer
#'
#' @return Esta función regresa en la consola los datos leidos del archivo seleccionado
#'    por el usuario como data frame tbl
#'
#' @details Debe escribir el nombre del archivo junto con la extensión .csv y todo esto
#' entre comillas.
#' Si ingresa un nombre incorrecto me devolverá que el archivo no existe : does not exist
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv")
#' fars_read(filename= "accident_2013.csv")
#' }
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}



#' Imprime "accident_year.csv.bz2"
#'
#' Esta funcion imprime un vector de caracteres con la variable year ingresada
#'
#' @param year un valor entero (año)
#'
#' @return Esta función regresa un vector de caracteres junto con
#'   el año ingresado por el usuario de la siquiente manera:"accident_year.csv.bz2"
#'
#' @details Es importante ingresar un valor entero o que pueda ser convertido
#'   a entero mediante coerción, de lo contrario la función regresara un mensaje de advertencia
#'
#' @examples
#' make_filename(2013)
#' make_filename(year= 2013)
#'
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}



#' Lee años
#'
#' Esta funcion permite aplicar a varios años la función anterior
#'
#' @param years vector entero que indica los años
#'
#' @return regresa variables añadidas a un conjunto de datos, se muestran solo las
#'   seleccionadas MONTH and year
#'
#' @details Si no se introduce correctamente el argumento me regresa un mensaje de adevertencia:
#'   invalid year:year
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013:2015)
#' fars_read_years(list(2013, 2014))
#'
#' # Results in a warning
#' fars_read_years(2016)
#' }
#'
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}


#' Obtener un par clave-valor
#'
#' Esta funcion permite obtener una par clave-valor entre agrupaciones
#'
#' @param years vector entero que indica los años
#'
#' @return Esta función regresa un par clave-valor, en este caso el año y las agrupaciones
#'
#' @details Se debe ingresar correctamente el argumento, sinoo se obtendrá una mensaje de error
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013:2016)
#' }
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}




#' Crear un mapa de eventos
#'
#' Esta funcion permite crear un mapa de eventos dado years
#'
#' @param state.num valor entero que indica el estado
#' @param year valor entero que indica un año
#'
#' @return Esta funcion regresa un mapa con los datos proporcionados
#'
#' @details Debe escribir un numero de estado existente, sino generará un mensaje de advertencia
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' fars_map_state(1,2013)
#' fars_map_state(state.num=1,2013)
#' fars_map_state(state.num=1,year=2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}

