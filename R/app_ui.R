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
#' @importFrom shiny icon
#' @importFrom shinydashboard dashboardHeader dashboardSidebar sidebarMenu
#' @importFrom shinydashboard menuItem dashboardBody tabItems tabItem dashboardPage
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyWidgets airYearpickerInput
#'
#' @return The user interface definition, without modifications or side effects.
#'
#' @seealso [shiny::shinyUI], [shinydashboard::dashboardPage()]
app_ui <- function(request, ...) {

  maturity_choices <- c(1:12) |> set_names(month.name)

  header <- app_header()

  sidebar <- shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      id = "menu",
      selectInput(
        "maturity_month",
        "Select Month of Maturity",
        choices = maturity_choices,
        selected = 12,
        selectize = FALSE,
        multiple = FALSE
      ),
      shinyWidgets::airYearpickerInput(
        "valuation_year",
        "Select Latest Evaluation Year:",
        minDate = min(loss_data_all$eval_date),
        maxDate = max(loss_data_all$eval_date),
        value = "2019-12-31",
        autoClose = TRUE,
        # update_on = "close",
        addon = "none",
        width = "100%"
      ),
      shinydashboard::menuItem(
        text = " Triangles",
        tabName = "triangles",
        icon = shiny::icon("triangle-exclamation")
      ),
      shinydashboard::menuItem(
        text = " AvE",
        tabName = "ave",
        icon = shiny::icon("scale-balanced"),
        badgeLabel = "Coming Soon!",
        badgeColor = "green"
      ),
      shinydashboard::menuItem(
        text = " Ultimate",
        tabName = "ult",
        icon = shiny::icon("dollar-sign"),
        badgeLabel = "Coming Soon!",
        badgeColor = "green"
      )
    )
  )

  body <- shinydashboard::dashboardBody(
    tags$head(
      tags$link(
        rel = "shortcut icon",
        type = "image/png",
        href = "images/pwc-logo.png"
      ),
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    shinyjs::useShinyjs(),
    shinydashboard::tabItems(
      shinydashboard::tabItem(
        tabName = "triangles",
        mod_triangles_ui("triangles_1", loss_data = loss_data_all)
      ),
      shinydashboard::tabItem(
        tabName = "ave"#,
        # ave_module_ui("ave")
      ),
      shinydashboard::tabItem(
        tabName = "ult"#,
        # ult_module_ui("ave")
      )
    )
  )

  ui <- shinydashboard::dashboardPage(
    header, sidebar, body,
    title = "Loss Development",
    skin = "black"
  )

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    ui
  )
}

#' App Header
#'
#' @description
#' Shiny App Dashboard's Header Function
#'
#' @rdname shiny-ui
#'
#' @param title App title to be placed in the header, above the sidebar.
#' @inheritDotParams shinydashboardPlus::dashboardHeader
#'
#' @return a [shinydashboard::dashboardHeader()]
#'
#' @export
#'
#' @importFrom shinydashboardPlus dashboardHeader
app_header <- function(title = "Loss Development",
                       ...) {

  shinydashboardPlus::dashboardHeader(
    title = title,
    ...
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
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "lossdevtapp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
