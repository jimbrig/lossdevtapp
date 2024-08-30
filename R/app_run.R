#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom polished polished_config
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  secure = FALSE,
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {

  if (secure) {

    app_config <- config::get(
      file = system.file("config.yml", package = "lossdevtapp")
    )

    polished::polished_config(
      app_name = app_config$app_name,
      api_key = app_config$api_key
    )

    ui <- app_ui_secure
    server <- app_server_secure

  } else {

    ui <- app_ui
    server <- app_server

  }

  with_golem_options(
    app = shinyApp(
      ui = ui,
      server = server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
