##########################################################################################
#
##########################################################################################
#' @title Compare module - UI
#' @description A picker for up to 10 indices, a start date, a button that
#' downloads the normalized closes as CSV, and a chart of the indices'
#' closes normalized to 100.
#' @param id Character. Module namespace id.
#' @param indices Data frame of indices from [get_indices()], whose labels
#'   fill the picker.
#' @param selected The indices selected at start: the S&P 500, the Euro
#'   Stoxx 50 and the Nikkei 225, one for each region.
#' @return A `tagList` of Shiny UI elements.
#' @keywords internal
#' @examples
#' \dontrun{
#' shiny::fluidPage(golemstockindices:::mod_compare_ui("compare", get_indices()))
#' }
mod_compare_ui <- function(id, indices, selected = c("S&P 500", "Euro Stoxx 50", "Nikkei 225")) {
  ns <- NS(id)
  tagList(
    div(
      class = "d-flex flex-wrap align-items-end gap-3",
      selectizeInput(ns("indices"),
        label = "Indices",
        choices = index_choices(indices),
        selected = intersect(selected, indices$label),
        multiple = TRUE,
        width = "28rem",
        options = list(maxItems = 10, plugins = list("remove_button"))
      ),
      dateInput(ns("start"), label = "Start date", value = Sys.Date() - 365, max = Sys.Date() - 1),
      div(class = "mb-3 csv-beside-inputs", downloadButton(ns("csv"), "CSV", class = "btn-sm"))
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
#' @title Compare module - server
#' @description Gets the price history of the selected indices from the start
#' date, renders their closes normalized to 100, and serves them as a CSV
#' file named like `compare-2026-11-07.csv`, with the columns `date`,
#' `label`, `close` and `index`. The download waits until the selection
#' has not changed for 1.5 seconds, instead of starting on every click in the
#' picker.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_compare_ui()].
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return None. Called for its side effect of registering the module server.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   mod_compare_server("compare", indices, reactive(input$dark_mode))
#' }
#' }
mod_compare_server <- function(id, indices, dark_mode) {
  moduleServer(id, function(input, output, session) {
    selected <- debounce(reactive(input$indices), 1500)
    history <- reactive({
      req(selected(), input$start)
      get_history(selected(), input$start, indices)
    })
    prices <- reactive({
      validate(need(history(), "Data not available for the selected indices"))
      normalize_prices(history())
    })

    output$plot <- plotly::renderPlotly(plot_compare(prices(), dark_mode()))

    output$csv <- csv_download(
      reactive(data.frame(
        date = prices()$timestamp,
        label = prices()$label,
        close = prices()$close,
        index = prices()$index
      )),
      "compare"
    )
  })
}
