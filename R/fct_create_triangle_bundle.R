#' Create Triangle Bundle
#'
#' @description
#' Create a "bundle" of triangle related items from an input loss dataset. The function
#' returns a list of class "triangle_bundle" and an attribute describing which metric the
#' bundle describes (i.e. paid, reported, counts, etc.).
#'
#' The resulting list contains:
#'
#'   - aggregated data filtered for ages of maturity from the `age_increment` argument
#'
#'   - triangle data derived off the aggregated data
#'
#'   - the actual spread out triangle
#'
#'   - age_to_age data
#'
#'   - the age_to_age spread out triangle
#'
#'   - averages (currently only straight and weighted)
#'
#'   - initial selections for the LDF's and derived CDF's.
#'
#'
#' @param loss_data initial aggregated loss data as a `data.frame`
#' @param age_increment increment in months between subsequent maturity periods
#' @param origin_col,age_col,value_col column names as strings
#'
#' @return list of class "triangle_bundle" with an added attribute describing
#'   which metric the bundle describes (i.e. paid, reported, counts, etc.)
#' @export
#'
#'
#' @importFrom dplyr filter rename mutate
#' @importFrom purrr map2_dfr
#' @importFrom rlang set_names
#' @importFrom tidyr pivot_wider
#'
#' @example examples/triangle_bundle.R
create_triangle_bundle <- function(loss_data, age_increment = 12, origin_col = "accident_year", age_col = "devt", value_col = "paid") {

  dat <- loss_data |> aggregate_loss_data() |> filter(devt %% age_increment == 0)

  tri_dat <- dev_tri(origin = dat[[origin_col]], age = dat[[age_col]], value = dat[[value_col]])

  tri <- spread_tri(tri_dat)

  ata_dat <- tri_dat |>
    ata_tri() |>
    dplyr::filter(!is.na(value))

  ata_tri <- spread_tri(ata_dat)

  avgs <- ldf_avg(tri_dat)

  avgs_wtd <- ldf_avg_wtd(tri_dat)

  ldf_avgs <- idf(ldf_avg(tri_dat)$idfs)

  ldf_avgs_wtd <- idf(ldf_avg_wtd(tri_dat)$idfs)

  init_sel <- ldf_avgs_wtd

  init_cdf <- idf2cdf(init_sel)

  params <- list("Straight Average:" = ldf_avgs,
                 "Weighted Average:" = ldf_avgs_wtd,
                 "Selected:" = init_sel,
                 "CDF:" = init_cdf)

  hold <- purrr::map2_dfr(params, names(params), function(dat, type) {
    dat |>
      tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) |>
      rlang::set_names(names(ata_tri)) |>
      dplyr::mutate(origin = type) |>
      dplyr::rename(" " = origin)
  })

  tri_bundle <-  list(
    "aggregate_data" = dat,
    "triangle_data" = tri_dat,
    "triangle" = tri,
    "age_to_age_data" = ata_dat,
    "age_to_age_triangle" = ata_tri,
    "averages" = hold[1:2, ],
    "selections" = hold[3:4, ]
  )

  class(tri_bundle) <- c("tri_bundle", class(tri_bundle))
  attr(tri_bundle, "type") <- value_col

  tri_bundle

}
