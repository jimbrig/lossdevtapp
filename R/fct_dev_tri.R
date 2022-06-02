#' Development Triangle Class
#'
#' @param origin,age,value columns necessary to generate a `dev_tri`
#' @param value_label optional label for the values (i.e. paid, incurred)
#' @param latest_eval_date optional - specify latest val date
#'
#' @export
#'
#' @importFrom tibble tibble
#'
#' @example examples/dev_tri.R
#'
#' @importFrom dplyr arrange ungroup summarise group_by
#' @importFrom tibble tibble
dev_tri <- function(origin, age, value, value_label = NULL, latest_eval_date = NULL) {

  tib <- tibble::tibble(origin = origin, age = age, value = value) |>
    dplyr::group_by(origin, age) |>
    dplyr::summarise(value = sum(value, na.rm = TRUE)) |>
    dplyr::ungroup() |>
    dplyr::arrange(origin, age)

  structure(tib, class = c("dev_tri", class(tib)),
            col_specs = list(
              "origin_col" = "origin",
              "age_col" = "age",
              "value_col" = "value"),
            value_label = value_label,
            latest_eval_date = latest_eval_date)
}

#' @export
print.dev_tri <- function(x, ...) {
  out <- spread_tri(x)
  msg_done("Loss Development Triangle: ")
  out
}

#' @export
#' @importFrom tibble view
view.dev_tri <- function(x) {
  tibble::view(spread_tri(x))
  invisible(x)
}

