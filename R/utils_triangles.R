#' @importFrom dplyr mutate
#' @importFrom tibble tibble
idf <- function(idfs, first_age = 12) {

  l <- length(idfs)
  last_age <- first_age + l - 1
  stopifnot(is.numeric(first_age) && length(first_age) == 1L)
  stopifnot(first_age > 0)
  stopifnot(is.numeric(idfs) && l > 0)
  tib <- tibble::tibble(age = first_age:last_age, idfs = idfs)
  tib <- tib |> dplyr::mutate(earned_ratio = pmin(age/1, 1))
  out <- structure(tib, tail_first_age = NA, dev_tri = NA,
                   class = c("idf_", class(tib)))
}

#' @importFrom dplyr select ungroup mutate group_by lead
ata_tri <- function(tri, ...) {

  stopifnot(inherits(tri, "dev_tri"))

  out <- tri |>
    dplyr::group_by(.data$origin) |>
    dplyr::mutate(value_lead = dplyr::lead(.data$value, by = .data$age),
                  value = value_lead / value) |>
    dplyr::ungroup() |>
    dplyr::select(origin, age, value)

  out <- out |> mutate(value = ifelse(value == Inf, NA_real_, value))

  structure(out, class = c("ata", class(out)))

}



#' @importFrom tidyr pivot_wider
spread_tri <- function(tri) {

  checkmate::assert(
    checkmate::check_class(tri, "dev_tri"),
    checkmate::check_class(tri, "ata")
  )

  tri |>
    tidyr::pivot_wider(names_from = age, values_from = value)
}

#' @importFrom dplyr group_by summarise
ldf_avg <- function(tri) {
  ata <- ata_tri(tri)
  out <- ata |> dplyr::group_by(age) |> dplyr::summarise(ldfs = mean(value,
                                                                       na.rm = TRUE))
  ldfs <- out$ldfs
  out <- idf(ldfs[-length(ldfs)], first_age = min(tri$age))
  attr(out, "dev_tri") <- tri
  out
}

#' @importFrom dplyr group_by mutate lead filter summarise
ldf_avg_wtd <- function(tri) {
  out <- tri |>
    dplyr::group_by(origin) |>
    dplyr::mutate(value_lead = dplyr::lead(value, by = age)) |>
    dplyr::filter(!is.na(value), !is.na(value_lead)) |>
    dplyr::group_by(age) |>
    dplyr::summarise(value_total = sum(value),
                     value_lead_total = sum(value_lead)) |>
    dplyr::mutate(ldfs = value_lead_total/value_total)

  ldfs <- out$ldfs

  out <- idf(ldfs, first_age = min(tri$age))

  attr(out, "dev_tri") <- tri

  out
}

#' @importFrom dplyr mutate
#' @importFrom tibble tibble
cdf <- function(cdfs, first_age = 12) {
  l <- length(cdfs)
  last_age <- first_age + l - 1
  stopifnot(is.numeric(first_age) && length(first_age) == 1L)
  stopifnot(first_age > 0)
  stopifnot(is.numeric(cdfs) && l > 0)
  tib <- tibble::tibble(age = first_age:last_age, cdfs = cdfs)
  tib <- tib |> dplyr::mutate(earned_ratio = pmin(age/1, 1))
  out <- structure(tib, tail_first_age = NA, dev_tri = NA,
                   class = c("cdf_", class(tib)))
  out
}

#' @importFrom dplyr mutate
idf2cdf <- function(idf_) {
  stopifnot(inherits(idf_, "idf_"))
  cdf_new <- idf_
  cdf_new$cdfs <- cdf_new$idfs |> rev() |> cumprod() |>
    rev()
  cdf_new <- cdf_new |> dplyr::mutate(cdfs = cdfs * earned_ratio)
  out <- cdf(cdfs = cdf_new$cdfs, first_age = cdf_new$age[1])
  attr(out, "tail_first_age") <- attr(idf_, "tail_first_age")
  attr(out, "dev_tri") <- attr(idf_, "dev_tri")
  out
}
