#' fars_read reads a csv file into a tibble.  This function is not exported
#'
#' @param filename takes the filename to be read.  Include the full path of the file
#' @return this function returns a tibble with the file read
#' @import readr
#' @importFrom dplyr tbl_df %>%

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' this function creates the file name.  The filename is "accident_year.csv.bz2
#' this function is not exported
#'
#' @param year this is for the year of accidents
#' @return returns the file name.

make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' this function is not exported either
#'
#' @param years select years to be plotted
#' @return a list with month year
#' @importFrom dplyr mutate select

fars_read_years <- function(years){
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

#' this function provides a data frame that summarizes the accidents per month for each year.
#' The function will produce and error when the year selected does not exist in the data
#'
#' @param years a vector indicating the years we want to see
#' @return returns a tibble with total cases by month and year
#' @export
#' @importFrom tidyr spread
#' @importFrom dplyr group_by summarize bind_rows

fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' this function creates a map by State of the cases in that State.  It takes into
#' account the longitud and latitud of the case.  The function produces an error
#' when the state is invalid
#'
#' @param state.num  a number representing the state to be graphed
#' @param year the year to be graphed
#' @return returns a map showing the accidents in the state
#' @import maps
#' @export
#' @examples \dontrun{fars_map_state(1, 2013)}  will produce a map of accidents for state 1 in 2013

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
