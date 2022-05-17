#' Derive Triangles
#'
#' @param loss_dat loss data
#' @param type paid, reported, case, or n_claims
#' @param limit optinal limit
#'
#' @return list of triangle data
#'
#' @importFrom dplyr rename filter mutate
#' @importFrom purrr map2_dfr
#' @importFrom rlang set_names
#' @importFrom tidyr pivot_wider
derive_triangles <- function(loss_dat, type = c("paid", "reported", "case", "n_claims"), limit = NULL) {

  agg_dat <- loss_dat %>% aggregate_loss_data(limit = limit)

  tri_dat <- dev_tri(
    origin = agg_dat$accident_year,
    age = agg_dat$devt,
    value = agg_dat[[type]]
  )

  tri <- tri_dat %>%
    spread_tri() %>%
    dplyr::rename(AYE = origin)

  if (type == "case") {
    return(
      list(
        "aggregate_data" = agg_dat,
        "triangle_data" = tri_dat,
        "triangle" = tri
      )
    )
  }

  ata_dat <- tri_dat %>%
    ata_tri(loss_dat) %>%
    dplyr::filter(!is.na(value))

  ata_tri <- ata_dat %>%
    spread_tri() %>%
    dplyr::rename(AYE = origin) %>%
    dplyr::mutate(AYE = as.character(AYE))

  # ata_tri <- triangle_data[[input$type]]$age_to_age_triangle %>%
  #   mutate(AYE = as.character(AYE))

  ldf_avg <- idf(ldf_avg(tri_dat)$idfs)

  ldf_avg_wtd <- idf(ldf_avg_wtd(tri_dat)$idfs)

  sel <- ldf_avg_wtd

  cdf <- idf2cdf(sel)

  params <- list("Straight Average:" = ldf_avg,
                 "Weighted Average:" = ldf_avg_wtd,
                 "Selected:" = sel,
                 "CDF:" = cdf)

  hold <- purrr::map2_dfr(params, names(params), function(dat, type_ ) {
    dat %>%
      tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) %>%
      rlang::set_names(names(ata_tri)) %>%
      dplyr::mutate(AYE = type_)
  })

  list(
    "aggregate_data" = agg_dat,
    "triangle_data" = tri_dat,
    "triangle" = tri,
    "age_to_age_data" = ata_dat,
    "age_to_age_triangle" = ata_tri,
    "averages" = hold
  )

}
