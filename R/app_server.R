#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  selected_eval <- shiny::reactiveVal(lubridate::ymd("2019-12-31"))

  shiny::observeEvent(input$maturity_month, {

    years <- loss_data_all |>
      dplyr::filter(lubridate::month(.data$eval_date) == input$maturity_month) |>
      dplyr::pull(.data$eval_date) |>
      lubridate::year() |>
      unique()

    hold <- paste0(years, "-", input$maturity_month, "-20")
    choices_ <- end_of_month(hold)

    shinyWidgets::updateAirDateInput(
      session = session,
      "valuation_year",
      "Select Latest Evaluation Year:",
      value = max(choices_)
    )

    selected_eval(max(choices_))

  }, ignoreInit = TRUE)

  shiny::observeEvent(input$valuation_year, {
    hold <- end_of_month(lubridate::ymd(input$valuation_year))
    selected_eval(hold)
  }, ignoreInit = TRUE)

  shiny::observe({
    print(list("Selected Eval: ", selected_eval()))
  })

  # adjust loss data
  loss_data <- shiny::reactive({
    msg <- shiny::showNotification("Filtering loss data...")
    on.exit(shiny::removeNotification(msg), add = TRUE)

    # browser()

    loss_data_all |>
      dplyr::filter(lubridate::month(.data$eval_date) == input$maturity_month, .data$eval_date <= selected_eval())
  })

   triangle_data <- mod_triangles_server("triangles_1", loss_data = loss_data, selected_eval = selected_eval)
}
