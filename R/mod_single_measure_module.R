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

  data_param <- reactive({
    data() %>% # data_param <- data %>%
      mutate(value = get(param)) %>%
      filter(value != 0 ) %>%
      select(date, value) %>%
      group_by(date) %>%
      mutate(mean_day = mean(value),
             mean_week = zoo::rollapply(value, 7, mean, align = 'right', fill = 0),
             mean_month = zoo::rollapply(value,
                                         lubridate::days_in_month(lubridate::month(.$date)),
                                         mean, align = 'right', fill = 0)) %>%
    ungroup()
  })

  # Data ----
  counts <- reactive({data.frame(mean_today = 1, mean_week = 2, mean_month = 3)})

  # Boxes ----
  callModule(mod_caseBoxes_server, "boxes", counts, param)

}

## To be copied in the UI
# mod_single_measure_module_ui("single_measure_module_ui_1")

## To be copied in the server
# callModule(mod_single_measure_module_server, "single_measure_module_ui_1")

