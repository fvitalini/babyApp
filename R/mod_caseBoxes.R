#' caseBoxes UI Function
#'
#' @description A shiny Module for displaying the number by type as colored boxes.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @example man-roxygen/ex-mod_caseBoxes.R
#'
#' @name mod_caseBoxes
#' @keywords internal

#' @rdname mod_caseBoxes
#' @import shiny
mod_caseBoxes_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(3, shiny::uiOutput(ns("today"))),
      column(3, shiny::uiOutput(ns("week"))),
      column(3, shiny::uiOutput(ns("month")))
    )
  )
}

#' caseBoxes Server Function
#'
#' @param counts Reactive expression yielding the named vector of cases by type.
#' @param param type of measure: weight, temperature, length
#'
#' @rdname mod_caseBoxes
mod_caseBoxes_server <- function(input, output, session, counts, param){
  ns <- session$ns


  output$today <- renderUI({
    countBox(paste0("Today's ", param),
             counts()[["mean_today"]],
             color = "white",
             background = colors_param[[param]]
    )
  })

  output$week <- renderUI({
    countBox(paste0("Week's ", param),
             counts()[["mean_week"]],
             color = "white",
             background = colors_param[[param]]
    )
  })

  output$month <- renderUI({
    countBox(paste0("Month's ", param),
             counts()[["mean_month"]],
             color = "white",
             background = colors_param[[param]]
    )
  })

}

countBox <- function(title, subtitle, color, background, width = "100%") {
  div(
    class = "count-box",
    shiny::h4(title),
    shiny::p(subtitle),
    style = sprintf(
      "color: %s; background-color: %s; width: %s;",
      color, background, width
    )
  )
}
