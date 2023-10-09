#' tri UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tri_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' tri Server Functions
#'
#' @noRd 
mod_tri_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_tri_ui("tri_1")
    
## To be copied in the server
# mod_tri_server("tri_1")
