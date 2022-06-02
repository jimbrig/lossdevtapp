fit_dist <- function(x,
                     distributions = NULL,
                     discrete = NULL,
                     plot = TRUE,
                     ...) {

  dists_cont = c("unif", "norm", "lnorm", "exp", "gamma", "beta", "weibull")
  dists_disc = c("binom", "pois", "nbinom", "geom", "hyper")

  x <- x[is.finite(x)]

  if(is.null(distributions)) {
    if(is.null(discrete)) discrete <- ifelse(all(x == floor(x)), TRUE, FALSE)
    if(discrete) distributions <- dists_disc
    else distributions <- dists_cont
  }

  msg_info("Fitting {paste(distributions, collapse = ', ')}")

  # fit distributions
  f <- lapply(distributions, function(d) {
    try(fitdistrplus::fitdist(x, d, ...), silent = FALSE)
  })

  names(f) <- distributions
  f <- f[!sapply(f, is, "try-error")]

  # create plots
  if(plot) {
    oldpar <- par(mfrow = c(1, 2))
    fitdistrplus::denscomp(f, legendtext = names(f))
    fitdistrplus::qqcomp(f, legendtext = names(f))
    #cdfcomp(f, legendtext = names(f))
    #ppcomp(f, legendtext = names(f))
    graphics::par(oldpar)
  }

  # calculate goodness-of-fit statistics
  # Note: if is for a bug in gofstat
  gof <- fitdistrplus::gofstat(if(length(f)<2) f[[1]] else f, fitnames = names(f))
  attr(f, "gof") <- gof

  if(is.null(gof$kstest)) gof$kstest <- rep(NA, times = length(gof$aic))
  if(is.null(gof$cvmtest)) gof$cvmtest <- rep(NA, times = length(gof$aic))
  if(is.null(gof$adtest)) gof$adtest <- rep(NA, times = length(gof$aic))
  if(is.null(gof$chisqpvalue)) gof$chisqpvalue <- rep(NA, times = length(gof$aic))

  msg_done("Test results:")
  print(data.frame(
    "Kolmogorov-iSmirnov test" = gof$kstest,
    "Cramer-von Mises test" = gof$cvmtest,
    "Anderson-Darling test" = gof$adtest,
    "Chi-Square p-value" = gof$chisqpvalue))

  msg_info(paste("\n*** Best fit using the AIC is:",
            names(which.min(gof$aic)),"***\n"))
  msg_info(paste("*** Best fit using the BIC is:",
            names(which.min(gof$bic)),"***\n\n"))

  f
}

fit_dist(log(x))
