#' Shiny User Interface Functions
#'
#' @name shiny-ui
#'
#' @description
#' Functions that build the Shiny App's UI:
#'
#'   - `app_ui`: Main UI function
#'
#'   - `app_header`: wrapper around [shinydashboard::dashboardHeader()]
#'
#'   - `app_sidebar`: wrapper around [shinydashboard::dashboardSidebar()]
#'
#'   - `app_body`: wrapper around [shinydashboard::dashboardBody()]
NULL

#' The Shiny Application User-Interface - `app_ui()`
#'
#' @description
#' Shiny App's User Interface Function.
#'
#' @rdname shiny-ui
#'
#' @param request Internal parameter for `{shiny}`.
#' @param ... For potential future use.
#'
#' @return The user interface definition, without modifications or side effects.
#'
#' @seealso [shiny::shinyUI], [shinydashboard::dashboardPage()]
#'
#' @importFrom shinydashboardPlus dashboardPage
#' @importFrom waiter spin_1
app_ui <- function(request, ...) {

  header <- app_header()
  sidebar <- app_sidebar()
  body <- app_body()
  control_bar <- app_control_bar()
  footer <- NULL

  ui <- shinydashboardPlus::dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body,
    controlbar = control_bar,
    footer = footer,
    title = "Loss Development",
    skin = "black",
    # freshTheme = ,
    preloader = list(html = waiter::spin_1(), color = "#333e48"),
    # md = ,
    # options = ,
    scrollToTop = TRUE
  )

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    ui
  )
}



#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyWidgets useShinydashboardPlus
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    # tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "lossdevtapp"
    ),
    shinyjs::useShinyjs(),
    shinyWidgets::useShinydashboardPlus()#,
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
