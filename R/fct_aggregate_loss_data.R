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
aggregate_loss_data <- function(claim_dat, limit = NA) {

  if (!is.na(limit)) {
    claim_dat <- claim_dat %>%
      dplyr::mutate(
        paid = pmin(limit, .data$paid),
        reported = pmin(limit, .data$reported),
        case = reported - paid
      )
  }

  claim_dat %>%
    dplyr::group_by(accident_year, devt) %>%
    dplyr::summarise(
      paid = sum(.data$paid, na.rm = TRUE),
      reported = sum(.data$reported, na.rm = TRUE),
      n_claims = dplyr::n()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(case = reported - paid)
}
