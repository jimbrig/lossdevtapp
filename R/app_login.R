
#' @importFrom polished sign_in_ui_default
login_page_ui <- function() {

  polished::sign_in_ui_default(
    color = "#006CB5",
    company_name = "No Clocks, LLC",
    logo_top = tags$img(
      src = "logo.png",
      alt = "No Clocks Logo",
      style = "width: 125px; margin-top: 30px; margin-bottom: 30px;"
    ),
    logo_bottom = tags$div(
      style = "background-color: #FFF; width: 300px;",
      tags$img(
        src = "images/noclocks-logo-wordmark-black.png",
        alt = "No Clocks Logo",
        style = "width: 200px; margin-bottom: 15px; padding-top: 15px;"
      )
    ),
    icon_href = "logo.png",
    background_image = "images/milky_way.jpeg"
  )
}
