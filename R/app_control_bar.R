#' App Controlbar
#'
#' @description
#' Shinydashboard Application control bar (right-sidebar) User Interface
#'
#' @inheritDotParams shinydashboardPlus::dashboardControlbar
#'
#' @return HTML for the UI sidebar
#' @export
#' @importFrom shiny icon
#' @importFrom shinydashboardPlus dashboardControlbar controlbarMenu controlbarItem
app_control_bar <- function(...) {
  shinydashboardPlus::dashboardControlbar(
    id = "controlbar",
    shinydashboardPlus::controlbarMenu(
      id = "controlbar_menu",
      shinydashboardPlus::controlbarItem(
        title = "Settings",
        value = "Settings",
        icon = shiny::icon("user-gear")
      ),
      shinydashboardPlus::controlbarItem(
        title = "Logs",
        value = "Logs",
        icon = shiny::icon("terminal")
      ),
      shinydashboardPlus::controlbarItem(
        title = "Tools",
        value = "Tools",
        icon = shiny::icon("wrench")
      )
    )
  )
}
