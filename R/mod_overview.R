##########################################################################################
#
##########################################################################################
#' @title Overview module - UI
#' @description The strip of the exchanges that are open, a line with the
#' date of the last closes, a button that downloads the table as CSV, the
#' table of all the indices from [overview_table()], and at the bottom the
#' table of the exchanges and their trading hours from [market_table()]. The
#' chart of their performance is in the Performance tab.
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
      id = ns("exchanges"),
      class = "mt-4 mb-4",
      tags$h2(class = "h5", "Exchanges"),
      helpText("Local times. Only the regular weekday sessions are known: on a holiday an exchange shows as open."),
      uiOutput(ns("exchange_table"))
    )
  )
}
##########################################################################################
#
##########################################################################################
#' @title Overview module - server
#' @description Gets the whole history of every index, sums it up with
#' [index_summary()] and shows it as a table, with a small line of each
#' index's last year. The histories are brought up to date when they are more
#' than an hour old, and the table follows while the page stays open; the strip and
#' the table of the exchanges follow the clock every minute. The CSV file, named
#' like `overview-2026-11-07.csv`, holds the summary unrounded.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_overview_ui()].
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return A reactive returning the [index_summary()] of every index, for
#'   [mod_performance_server()].
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   summary <- mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
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

    status <- reactive({
      invalidateLater(60 * 1000)
      market_status()
    })

    output$markets <- renderUI(market_strip(status(), session$ns("exchanges")))

    output$exchange_table <- renderUI(market_table(status()))

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

    output$csv <- csv_download(summary, "overview")

    summary
  })
}
