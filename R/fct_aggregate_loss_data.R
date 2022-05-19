#' Aggregate Loss data
#'
#' @param claim_dat claims data
#' @param limit optional limit
#'
#' @return df
#'
#' @export
#'
#' @importFrom dplyr mutate group_by summarise n ungroup
#' @importFrom rlang .data .env
aggregate_loss_data <- function(claim_dat, limit = NA) {

  if (!is.na(limit)) {
    claim_dat <- claim_dat |>
      dplyr::mutate(
        paid = pmin(.env$limit, .data$paid),
        reported = pmin(.env$limit, .data$reported),
        case = .data$reported - .data$paid
      )
  }

  claim_dat |>
    dplyr::group_by(.data$accident_year, .data$devt) |>
    dplyr::summarise(
      paid = sum(.data$paid, na.rm = TRUE),
      reported = sum(.data$reported, na.rm = TRUE),
      n_claims = dplyr::n()
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(case = .data$reported - .data$paid)
}
