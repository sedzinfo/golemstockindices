##########################################################################################
#
##########################################################################################
#' @title Overview module - UI
#' @description The strip of the exchanges that are open, a line with the
#' date of the last closes, a button that downloads the table as CSV, the
#' table of all the indices from [overview_table()], and the chart of their
#' performance from [plot_performance()] with a choice of the period.
#' @param id Character. Module namespace id.
#' @return A `tagList` of Shiny UI elements.
#' @keywords internal
#' @examples
#' \dontrun{
#' shiny::fluidPage(golemstockindices:::mod_overview_ui("overview"))
#' }
mod_overview_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("markets")),
    div(
      class = "d-flex align-items-center gap-3",
      helpText(textOutput(ns("updated"), inline = TRUE)),
      downloadButton(ns("csv"), "CSV", class = "btn-sm")
    ),
    shinycssloaders::withSpinner(DT::DTOutput(ns("table"))),
    div(
      class = "d-flex flex-wrap align-items-center gap-3 inline-controls mt-4",
      tags$label(`for` = ns("period"), class = "form-label mb-0", "Performance over"),
      radioButtons(ns("period"), NULL,
        choices = c("the day" = "day", "a week" = "week", "a month" = "month", "this year" = "ytd", "a year" = "year"),
        selected = "ytd", inline = TRUE
      )
    ),
    plotly::plotlyOutput(ns("performance"), width = "100%", height = "560px")
  )
}
##########################################################################################
#
##########################################################################################
#' @title Overview module - server
#' @description Gets the whole history of every index, sums it up with
#' [index_summary()] and shows it as a table, with a small line of each
#' index's last year, and as a chart of the performance over the period
#' picked. The histories are brought up to date when they are more than an
#' hour old, and the table follows while the page stays open; the strip of
#' the open exchanges follows the clock every minute. The CSV file, named
#' like `overview-2026-11-07.csv`, holds the summary unrounded.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_overview_ui()].
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return None. Called for its side effect of registering the module server.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
#' }
#' }
mod_overview_server <- function(id, indices, dark_mode) {
  moduleServer(id, function(input, output, session) {
    history <- reactive({
      invalidateLater(history_minutes * 60 * 1000)
      history <- get_history(indices$label, as.Date("1900-01-01"), indices)
      validate(need(history, "The prices cannot be downloaded right now"))
      history
    })
    summary <- reactive(index_summary(history()))
    period <- reactive(if (is.null(input$period)) "ytd" else input$period)

    output$markets <- renderUI({
      invalidateLater(60 * 1000)
      market_strip(market_status())
    })

    output$updated <- renderText({
      dates <- summary()$date
      newest <- max(dates)
      older <- summary()$label[dates < newest]
      paste0(
        "Daily closes from Yahoo Finance, up to ", long_date(newest),
        if (length(older) > 0) paste0("; ", and_list(older), " closed last on an earlier day") else ""
      )
    })

    output$table <- DT::renderDT(overview_table(summary(), indices, history()))

    output$performance <- plotly::renderPlotly(plot_performance(summary(), indices, period(), dark_mode()))

    output$csv <- csv_download(summary, "overview")
  })
}
