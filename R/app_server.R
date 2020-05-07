#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  callModule(mod_single_measure_module_server, "single_measure_module_weight", param = "weight", data = data_reactive())
  callModule(mod_single_measure_module_server, "single_measure_module_length", param = "length", data = data_reactive())
  callModule(mod_single_measure_module_server, "single_measure_module_temperature", param = "temperature", data = data_reactive())
  callModule(mod_journal_server, "mod_journal")
}
