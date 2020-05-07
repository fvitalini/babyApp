if (interactive()) {
  library(shiny)
  ui <- fluidPage(
    tagList(
      babyMeasure:::mod_caseBoxes_ui("boxes")
    )
  )
  server <- function(input, output, session) {
    counts <- reactive({
      # invalidateLater(2000)
      stats::setNames(sample.int(1000, 3), c("today", "week", "month"))
    })
    callModule(babyMeasure:::mod_caseBoxes_server, "boxes", counts = counts)
  }
  runApp(shinyApp(ui = ui, server = server), launch.browser = TRUE)
}
