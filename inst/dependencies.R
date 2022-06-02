# No Remotes ----
# Attachments ----
to_install <- c("checkmate", "cli", "config", "crayon", "dplyr", "DT", "fs", "glue", "golem", "here", "lubridate", "purrr", "randomNames", "rlang", "shiny", "shinycssloaders", "shinydashboard", "shinyjs", "shinyWidgets", "tibble", "tidyr", "usethis")
  for (i in to_install) {
    message(paste("looking for ", i))
    if (!requireNamespace(i)) {
      message(paste("     installing", i))
      install.packages(i)
    }
  }
