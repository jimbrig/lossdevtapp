
#' App Sidebar
#'
#' @description
#' Shinydashboard Application body User Interface
#'
#' @inheritDotParams shinydashboard::dashboardBody
#'
#' @return HTML for the UI sidebar
#' @export
#' @importFrom shinydashboard dashboardBody tabItems tabItem
app_body <- function(...) {
  shinydashboard::dashboardBody(
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
}
