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
    br(),
    fluidRow(
      mod_caseBoxes_ui(ns("boxes"))
    )
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

  # Data ----
  counts <- reactive({data.frame(mean_today = 1, mean_week = 2, mean_month = 3)})

  # Boxes ----
  callModule(mod_caseBoxes_server, "boxes", counts, param)

}

## To be copied in the UI
# mod_single_measure_module_ui("single_measure_module_ui_1")

## To be copied in the server
# callModule(mod_single_measure_module_server, "single_measure_module_ui_1")

