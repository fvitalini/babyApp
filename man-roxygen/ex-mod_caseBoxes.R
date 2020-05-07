if (interactive()) {
  library(shiny)
  ui <- fluidPage(
    tagList(
      babyApp:::mod_caseBoxes_ui("boxes")
    )
  )
  server <- function(input, output, session) {
    counts <- reactive({
      # invalidateLater(2000)
      stats::setNames(sample.int(1000, 3), c("mean_today", "mean_week", "mean_month"))
    })
    callModule(babyApp:::mod_caseBoxes_server, "boxes", counts = counts, param = "weight")
  }
  runApp(shinyApp(ui = ui, server = server), launch.browser = TRUE)
}
