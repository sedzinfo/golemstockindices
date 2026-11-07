##########################################################################################
#
##########################################################################################
#' @title The application server logic
#' @description Wires up the module of each tab. The price history of the
#' index picked in the Timeseries tab is shared with the Returns calendar,
#' Seasonality, Volatility and Drawdowns tabs.
#' @param indices Data frame of indices from `get_indices()`.
#' @return A shiny server function, with the usual `input`, `output` and
#'   `session` arguments.
#' @noRd
#' @examples
#' \dontrun{
#' indices <- get_indices()
#' shiny::shinyApp(ui = app_ui(indices), server = app_server(indices))
#' }
app_server <- function(indices) {
  function(input, output, session) {
    dark_mode <- reactive(input$dark_mode)

    mod_overview_server("overview", indices)
    history <- mod_timeseries_server("timeseries", indices, dark_mode)
    mod_compare_server("compare", indices, dark_mode)
    mod_returns_calendar_server("returns_calendar", history, dark_mode)
    mod_seasonality_server("seasonality", history, dark_mode)
    mod_volatility_server("volatility", history, dark_mode)
    mod_drawdowns_server("drawdowns", history, dark_mode)
    mod_about_server("about", dark_mode)

    output$keep_alive <- renderText({
      req(input$count)
      paste("keep alive", input$count)
    })
  }
}
