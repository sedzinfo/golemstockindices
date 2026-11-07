##########################################################################################
#
##########################################################################################
#' @title The index pickers' choices, grouped by region
#' @param indices Data frame of indices from [get_indices()].
#' @return A named list of index labels, one element per region, for the
#'   `choices` of [shiny::selectInput()].
#' @keywords internal
#' @examples
#' golemstockindices:::index_choices(get_indices())
index_choices <- function(indices) {
  split(indices$label, factor(indices$region, levels = unique(indices$region)))
}
##########################################################################################
#
##########################################################################################
#' @title Timeseries module - UI
#' @description An index picker, a button that downloads the index's daily
#' prices as CSV, and a candlestick chart of those prices, with the trading
#' volume underneath.
#' @param id Character. Module namespace id.
#' @param indices Data frame of indices from [get_indices()], whose labels
#'   fill the picker.
#' @return A `tagList` of Shiny UI elements.
#' @keywords internal
#' @examples
#' \dontrun{
#' shiny::fluidPage(golemstockindices:::mod_timeseries_ui("timeseries", get_indices()))
#' }
mod_timeseries_ui <- function(id, indices) {
  ns <- NS(id)
  tagList(
    div(
      class = "d-flex flex-wrap align-items-end gap-3",
      selectInput(ns("index"), label = "Index", choices = index_choices(indices), selectize = FALSE, width = "14rem"),
      div(class = "mb-3", downloadButton(ns("csv"), "CSV"))
    ),
    shinycssloaders::withSpinner(
      # the rest of the window below the controls, with a minimum in styles.css
      plotly::plotlyOutput(ns("plot"), width = "100%", height = "calc(100vh - 170px)")
    )
  )
}
##########################################################################################
#
##########################################################################################
#' @title Timeseries module - server
#' @description Gets the whole price history of the selected index, renders
#' its candlestick chart and serves it as a CSV file named like
#' `s-p-500-history-2026-11-07.csv`, with the columns `date`, `label`,
#' `open`, `high`, `low`, `close` and `volume`.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_timeseries_ui()].
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return A reactive returning the price history of the selected index, from
#'   [get_history()], which the Returns calendar, Seasonality, Volatility and
#'   Drawdowns tabs reuse.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   history <- mod_timeseries_server("timeseries", indices, reactive(input$dark_mode))
#' }
#' }
mod_timeseries_server <- function(id, indices, dark_mode) {
  moduleServer(id, function(input, output, session) {
    # downloads live in reactives, so toggling dark mode re-draws without re-downloading;
    # the whole history, which starts in 1927 for the S&P 500
    history <- reactive(get_history(input$index, as.Date("1900-01-01"), indices))

    output$plot <- plotly::renderPlotly({
      validate(need(history(), "Data not available for this index"))
      plot_timeseries(history(), dark_mode())
    })

    output$csv <- csv_download(
      reactive({
        req(history())
        data.frame(date = history()$timestamp, history()[c("label", "open", "high", "low", "close", "volume")])
      }),
      reactive({
        req(history())
        paste0(file_stem(unique(history()$label)), "-history")
      })
    )

    history
  })
}
