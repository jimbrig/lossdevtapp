FROM rocker/verse:4.4.1
RUN apt-get update && apt-get install -y  git gsfonts imagemagick libcurl4-openssl-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libgit2-dev libharfbuzz-dev libicu-dev libjpeg-dev libmagick++-dev libpng-dev libssl-dev libtiff-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("crayon",upgrade="never", version = "1.5.3")'
RUN Rscript -e 'remotes::install_version("tibble",upgrade="never", version = "3.2.1")'
RUN Rscript -e 'remotes::install_version("rlang",upgrade="never", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.7.0")'
RUN Rscript -e 'remotes::install_version("cli",upgrade="never", version = "3.6.3")'
RUN Rscript -e 'remotes::install_version("fs",upgrade="never", version = "1.6.4")'
RUN Rscript -e 'remotes::install_version("purrr",upgrade="never", version = "1.0.2")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.48")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.28")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.9.1")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.2.1.1")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.3.1")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.9.3")'
RUN Rscript -e 'remotes::install_version("checkmate",upgrade="never", version = "2.3.2")'
RUN Rscript -e 'remotes::install_version("usethis",upgrade="never", version = "3.0.0")'
RUN Rscript -e 'remotes::install_version("waiter",upgrade="never", version = "0.2.5")'
RUN Rscript -e 'remotes::install_version("shinydashboard",upgrade="never", version = "0.7.2")'
RUN Rscript -e 'remotes::install_version("here",upgrade="never", version = "1.0.1")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("summarytools",upgrade="never", version = NA)'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.3.0")'
RUN Rscript -e 'remotes::install_version("kableExtra",upgrade="never", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("fplot",upgrade="never", version = NA)'
RUN Rscript -e 'remotes::install_version("devtools",upgrade="never", version = "2.4.5")'
RUN Rscript -e 'remotes::install_version("actuar",upgrade="never", version = NA)'
RUN Rscript -e 'remotes::install_version("shinyWidgets",upgrade="never", version = "0.8.6")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("shinydashboardPlus",upgrade="never", version = "2.0.5")'
RUN Rscript -e 'remotes::install_version("shinycssloaders",upgrade="never", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("randomNames",upgrade="never", version = "1.6-0.0")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.5.1")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.33")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');library(lossdevtapp);lossdevtapp::run_app()"
