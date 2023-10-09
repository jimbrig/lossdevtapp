
#' App Sidebar
#'
#' @description
#' Shinydashboard Application Sidebar User Interface
#'
#' @inheritDotParams shinydashboardPlus::dashboardSidebar
#'
#' @return HTML for the UI sidebar
#' @export
#' @importFrom shiny icon selectInput
#' @importFrom shinydashboard sidebarUserPanel sidebarSearchForm sidebarMenu menuItem
#' @importFrom shinydashboardPlus dashboardSidebar
#' @importFrom shinyWidgets airYearpickerInput
app_sidebar <- function(...) {

  maturity_choices <- c(1:12) |> set_names(month.name)

  shinydashboardPlus::dashboardSidebar(
    id = "sidebar",
    shinydashboard::sidebarUserPanel(
      get_shiny_current_user(),
      subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
      image = "www/img/userimage.png" #   get_shiny_current_user_img()
    ),

    shinydashboard::sidebarSearchForm(
      textId = "search_bar_txt",
      buttonId = "search_bar_bttn",
      label = "Search: ",
      icon = shiny::icon("magnifying-glass")
    ),

    shiny::selectInput(
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

    shinydashboard::sidebarMenu(
      id = "menu",
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

}

set_shiny_current_user <- function(
    user = "",
    session = shiny::getDefaultReactiveDomain()
) {

  session$userData$user <- user

}

get_shiny_current_user <- function(
    session = shiny::getDefaultReactiveDomain(),
    unset = get_default_shiny_user(),
    ...
) {

  # browser()

  usr <- unset

  # check session$user
  if (!is.null(session$user)) {
    usr <- session$user
  }

  # check session$userData$user
  if (!is.null(session$userData$user)) {
    usr <- session$userData$user
  }

  return(usr)

}

#' @importFrom fs file_exists
get_shiny_current_user_img <- function(
    session = shiny::getDefaultReactiveDomain(),
    unset = get_default_shiny_user_img(),
    ...
) {

  # browser()

  usr <- get_shiny_current_user()
  usr_img <- unset
  usr_img_tmp <- paste0("img/", usr, ".png")

  if (fs::file_exists(system.file(paste0("app/www/", usr_img_tmp), package = "lossdevtapp"))) {

    usr_img <- usr_img_tmp

  }

  return(usr_img)

}

get_default_shiny_user <- function() {

  Sys.getenv("FULLNAME")

}

get_default_shiny_user_img <- function() {

  system.file("app/www/img/userimage.png", package = "lossdevtapp")

}

# app_sidebar <- function(id = "",
#                         user_panel = app_sidebar_user_panel(),
#                         search_form = app_sidebar_search_form(),
#                         maturity_selector = app_sidebar_maturity_selector(),
#                         maturity_choices = maturity_choices,
#                         loss_data = loss_data_all,
#                         ...) {
#
#   shinydashboardPlus::dashboardSidebar(
#     shinydashboard::sidebarUserPanel(
#       get_shiny_current_user(),
#       subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
#       image = get_shiny_current_user_img()
#     ),
#
#     shinydashboard::sidebarSearchForm(
#       textId = "search_bar_txt",
#       buttonId = "search_bar_bttn",
#       label = "Search: ",
#       icon = shiny::icon("search")
#     ),
#
#     shiny::selectInput(
#       "maturity_month",
#       "Select Month of Maturity",
#       choices = maturity_choices,
#       selected = 12,
#       selectize = FALSE,
#       multiple = FALSE
#     ),
#
#     shinyWidgets::airYearpickerInput(
#       "valuation_year",
#       "Select Latest Evaluation Year:",
#       minDate = min(loss_data_all$eval_date),
#       maxDate = max(loss_data_all$eval_date),
#       value = "2019-12-31",
#       autoClose = TRUE,
#       # update_on = "close",
#       addon = "none",
#       width = "100%"
#     ),
#
#     shinydashboard::sidebarMenu(
#       id = "menu",
#       shinydashboard::menuItem(
#         text = " Triangles",
#         tabName = "triangles",
#         icon = shiny::icon("triangle-exclamation")
#       ),
#       shinydashboard::menuItem(
#         text = " AvE",
#         tabName = "ave",
#         icon = shiny::icon("scale-balanced"),
#         badgeLabel = "Coming Soon!",
#         badgeColor = "green"
#       ),
#       shinydashboard::menuItem(
#         text = " Ultimate",
#         tabName = "ult",
#         icon = shiny::icon("dollar-sign"),
#         badgeLabel = "Coming Soon!",
#         badgeColor = "green"
#       )
#     )
#   )
# }


