#' Date Utility Functions
#'
#' @description
#' Date utility helpers for deriving start/end dates.
#'
#' @name date_utils
#'
#' @param date Character string or Date representing the date to manipulate.
#'
#' @return Returns the Start or End Date as a Date.
#'
#' @importFrom lubridate is.Date ceiling_date floor_date
#'
#' @example examples/date_utils.R
NULL

#' End of Month
#'
#' @export
#' @rdname date_utils
end_of_month <- function(date) {
  if (is.character(date)) date <- as.Date(date)
  stopifnot(lubridate::is.Date(date))
  lubridate::ceiling_date(date, unit = "months") - 1
}

#' Beginning of Month
#'
#' @export
#' @rdname date-utils
beg_of_month <- function(date) {
  if (is.character(date)) date <- as.Date(date)
  stopifnot(lubridate::is.Date(date))
  lubridate::floor_date(date, unit = "months")
}

#' Start of Month
#'
#' @export
#' @rdname date-utils
start_of_month <- function(date) {
  beg_of_month(date)
}
