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
