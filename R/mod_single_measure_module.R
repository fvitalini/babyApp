#' single_measure_module UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param param type of measure: weight, temperature, length
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_single_measure_module_ui <- function(id, param){
  ns <- NS(id)
  tagList(

  )
}

#' single_measure_module Server Function
#'
#' @param param type of measure: weight, temperature, length
#' @param data reactive dataset. as dataframe
#'
#' @noRd
mod_single_measure_module_server <- function(input, output, session, param, data){
  ns <- session$ns

}

## To be copied in the UI
# mod_single_measure_module_ui("single_measure_module_ui_1")

## To be copied in the server
# callModule(mod_single_measure_module_server, "single_measure_module_ui_1")

