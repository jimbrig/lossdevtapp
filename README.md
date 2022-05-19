
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lossdevtapp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/jimbrig/lossdevtapp/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jimbrig/lossdevtapp?branch=main)
[![R-CMD-check](https://github.com/jimbrig/lossdevtapp/workflows/R-CMD-check/badge.svg)](https://github.com/jimbrig/lossdevtapp/actions)
<!-- badges: end -->

The goal of lossdevtapp is to provide an intuitive actuarial application for a typical Property Casualty loss development workflow.

Check out the repo's [Changelog](CHANGELOG.md) for progression details on the development of the R package and its features over time.

## Installation

You can install the development version of `lossdevtapp` like so:

``` r
pak::pak("jimbrig/lossdevtapp")
```

or pull the [Docker Image](https://github.com/jimbrig/lossdevtapp/pkgs/container/lossdevtapp) hosted on GitHub Container Registry via:

```bash
# pull base image
docker pull ghcr.io/jimbrig/lossdevtapp:latest

# run container image locally
docker run -d -it -p 8080:80 ghcr.io/jimbrig/lossdevtapp:latest
```

and view the corresponding [Dockerfile](Dockerfile) for reference on how the image was built.


## Code of Conduct

Please note that the lossdevtapp project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
