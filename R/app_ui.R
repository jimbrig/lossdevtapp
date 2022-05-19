#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {

  maturity_choices <- c(1:12) |> set_names(month.name)

  header <- shinydashboard::dashboardHeader(
    title = "Loss Development"
  )

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
        icon = shiny::icon("arrow-down-wade-short")
      ),
      shinydashboard::menuItem(
        text = " AvE",
        tabName = "ave",
        icon = shiny::icon("balance-scale"),
        badgeLabel = "Coming Soon!",
        badgeColor = "green"
      ),
      shinydashboard::menuItem(
        text = " Ultimate",
        tabName = "ult",
        icon = shiny::icon("search-dollar"),
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
