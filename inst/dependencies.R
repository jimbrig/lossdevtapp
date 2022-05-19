# No Remotes ----
# Attachments ----
to_install <- c("config", "dplyr", "DT", "golem", "lubridate", "purrr", "rlang", "shiny", "shinycssloaders", "shinydashboard", "shinyjs", "shinyWidgets", "tibble", "tidyr")
  for (i in to_install) {
    message(paste("looking for ", i))
    if (!requireNamespace(i)) {
      message(paste("     installing", i))
      install.packages(i)
    }
  }
