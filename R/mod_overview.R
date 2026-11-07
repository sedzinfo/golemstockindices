##########################################################################################
#
##########################################################################################
#' @title Overview module - UI
#' @description A line with the date of the last closes, a button that
#' downloads the table as CSV, and the table of all the indices from
#' [overview_table()].
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
    div(
      class = "d-flex align-items-center gap-3",
      helpText(textOutput(ns("updated"), inline = TRUE)),
      downloadButton(ns("csv"), "CSV", class = "btn-sm")
    ),
    shinycssloaders::withSpinner(DT::DTOutput(ns("table")))
  )
}
##########################################################################################
#
##########################################################################################
#' @title Overview module - server
#' @description Gets the whole history of every index, sums it up with
#' [index_summary()] and shows it as a table. The histories are brought up to
#' date when they are more than an hour old, and the table follows while the
#' page stays open. The CSV file, named like `overview-2026-11-07.csv`, holds
#' the summary unrounded.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_overview_ui()].
#' @param indices Data frame of indices from [get_indices()].
#' @return None. Called for its side effect of registering the module server.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   mod_overview_server("overview", get_indices())
#' }
#' }
mod_overview_server <- function(id, indices) {
  moduleServer(id, function(input, output, session) {
    summary <- reactive({
      invalidateLater(history_minutes * 60 * 1000)
      history <- get_history(indices$label, as.Date("1900-01-01"), indices)
      validate(need(history, "The prices cannot be downloaded right now"))
      index_summary(history)
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

    output$table <- DT::renderDT(overview_table(summary(), indices))

    output$csv <- csv_download(summary, "overview")
  })
}
