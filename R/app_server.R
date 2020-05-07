#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import dplyr
#' @noRd
app_server <- function(input, output, session) {

  # path to save data
  dataset_name <- file.path("inst","data_tracking", "fagiolina.rds")

  # define data_reactive
  data_reactive <- reactive({
    if (file.exists(dataset_name)) {
      data <- readRDS(dataset_name)
    } else {
      # data <- NULL
      data <- reactive({
        data <- data.frame(
          time = rep(format(Sys.time(), format = "%H %M"), 4),
          date = Sys.Date(),
          weight = sample.int(1000, 4),
          temperature = sample.int(1000, 4),
          length = sample.int(1000, 4)
        )
      })
    }
    data
  })

  observeEvent(input$abtn_submit, {
    print("submit")

    # New data
    new_data <- data.frame(time = Sys.time(), weight = input$num_weight, temperature = input$num_temperature, length = input$num_length)

    # append data
    if (!is.null(data_reactive())) {
      data <- data_reactive() %>%
        bind_rows(new_data)
    } else {
      data <- new_data
    }

    # save data
    saveRDS(data, dataset_name)

    #return reactive
    data_reactive <- reactive(data)
  })


  # List the first level callModules here
  callModule(mod_single_measure_module_server, "single_measure_module_weight", param = "weight", data = data_reactive())
  callModule(mod_single_measure_module_server, "single_measure_module_length", param = "length", data = data_reactive())
  callModule(mod_single_measure_module_server, "single_measure_module_temperature", param = "temperature", data = data_reactive())
  callModule(mod_journal_server, "mod_journal")
}
