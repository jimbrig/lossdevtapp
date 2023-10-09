#' ldf_modal UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ldf_modal_ui <- function(id){
  ns <- NS(id)
  tagList(



  )
}

#' ldf_modal Server Functions
#'
#' @noRd
mod_ldf_modal_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_ldf_modal_ui("ldf_modal_1")

## To be copied in the server
# mod_ldf_modal_server("ldf_modal_1")
