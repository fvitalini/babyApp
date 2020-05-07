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

  today <- reactive({data %>%
      select(date) %>%
      max() %>%
      pull()
    })

  data_param <- reactive({
    data() %>% # data_param <- data %>%
      mutate(value = get(param),
             week = lubridate::week(date),
             month = lubridate::month(date),
             ) %>%
      filter(value != 0 ) %>%
      group_by(date) %>%
      mutate(mean_day = mean(value)) %>%
      ungroup() %>%
      group_by(week) %>%
      mutate(mean_week = mean(value)) %>%
      ungroup() %>%
      group_by(month) %>%
      mutate(mean_month = mean(value)) %>%
      ungroup()
  })

  # Data ----
  counts <- reactive({
    data_param() %>% # counts <- data_param %>%
      filter(date == max(date)) %>%
      mutate(mean_today = mean_day) %>%
      select(mean_today, mean_week, mean_month) %>%
      distinct()
  })

  # Boxes ----
  callModule(mod_caseBoxes_server, "boxes", counts, param)

}

## To be copied in the UI
# mod_single_measure_module_ui("single_measure_module_ui_1")

## To be copied in the server
# callModule(mod_single_measure_module_server, "single_measure_module_ui_1")

