##########################################################################################
#
##########################################################################################
#' @title Performance module - UI
#' @description A choice of the period, a button that downloads the changes
#' as CSV, and the chart of the performance of the indices from
#' [plot_performance()], the best at the top.
#' @param id Character. Module namespace id.
#' @return A `tagList` of Shiny UI elements.
#' @keywords internal
#' @examples
#' \dontrun{
#' shiny::fluidPage(golemstockindices:::mod_performance_ui("performance"))
#' }
mod_performance_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "d-flex flex-wrap align-items-center gap-3 inline-controls",
      tags$label(`for` = ns("period"), class = "form-label mb-0", "Performance over"),
      radioButtons(ns("period"), NULL,
        choices = c("the day" = "day", "a week" = "week", "a month" = "month", "this year" = "ytd", "a year" = "year"),
        selected = "ytd", inline = TRUE
      ),
      downloadButton(ns("csv"), "CSV", class = "btn-sm")
    ),
    # a bar per index, each tall enough for its name
    shinycssloaders::withSpinner(
      plotly::plotlyOutput(ns("plot"), width = "100%", height = "780px")
    )
  )
}
##########################################################################################
#
##########################################################################################
#' @title Performance module - server
#' @description Shows the change of every index over the period picked, from
#' the summary of the Overview tab, so the histories are downloaded once for
#' both tabs. The CSV file, named like `performance-ytd-2026-11-07.csv`, holds
#' the changes of the chart from [performance_data()], unrounded.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_performance_ui()].
#' @param summary Reactive returning the [index_summary()] of every index,
#'   as [mod_overview_server()] returns it.
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return None. Called for its side effect of registering the module server.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   summary <- mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
#'   mod_performance_server("performance", summary, get_indices(), reactive(input$dark_mode))
#' }
#' }
mod_performance_server <- function(id, summary, indices, dark_mode) {
  moduleServer(id, function(input, output, session) {
    period <- reactive(if (is.null(input$period)) "ytd" else input$period)

    output$plot <- plotly::renderPlotly(plot_performance(summary(), indices, period(), dark_mode()))

    output$csv <- csv_download(
      reactive(performance_data(summary(), indices, period())),
      function() paste0("performance-", period())
    )
  })
}
