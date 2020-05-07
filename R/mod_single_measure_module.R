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
    ),
    fluidRow(
      plotOutput(ns("plot_output"), width = "100%", height = 600),
      tableOutput(ns("table_output")),
      downloadButton(ns("downloadCsv"), "Download as CSV")
    )
  )
}

#' single_measure_module Server Function
#'
#' @param param type of measure: weight, temperature, length
#' @param data reactive dataset. as dataframe
#'
#' @import ggplot2
#'
#' @noRd
mod_single_measure_module_server <- function(input, output, session, param, data){
  ns <- session$ns

  # Data ----

  data_param <- reactive({
    data() %>% # data_param <- data %>%
      mutate(value = get(param),
             date = lubridate::date(time),
             week = lubridate::week(time),
             month = lubridate::month(time),
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

  counts <- reactive({
    data_param() %>% # counts <- data_param %>%
      filter(date == max(date)) %>%
      mutate(mean_today = mean_day) %>%
      select(mean_today, mean_week, mean_month) %>%
      distinct()
  })

  data_plot <- reactive({
    data_param() %>% #data_plot <- data_param %>%
      select(-names(colors_param), -date, -week,-month) %>%
      as.data.frame()
  })

  # Boxes ----
  callModule(mod_caseBoxes_server, "boxes", counts, param)

  # Plot ----
  output$plot_output <- renderPlot(
    ggplot(data_plot(), aes(x = time, y = param)) +
      geom_line() +
      geom_point()
  )

  # Table ----
  output$table_output <- renderTable({data_plot()})

  output$downloadCsv <- downloadHandler(
    filename = function() {
      paste('data-', Sys.time(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(data_plot(), con)
    }
  )

}
