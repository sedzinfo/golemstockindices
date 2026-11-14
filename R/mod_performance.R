##########################################################################################
#
##########################################################################################
#' @title Performance module - UI
#' @description A choice of the period and of the currency, a button that
#' downloads the changes as CSV, a line on the indices without exchange rates
#' when there are any, and the chart of the performance of the indices from
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
        choices = c(
          "day" = "day", "week" = "week", "month" = "month", "3 months" = "month3",
          "6 months" = "month6", "9 months" = "month9", "this year" = "ytd", "a year" = "year"
        ),
        selected = "ytd", inline = TRUE
      ),
      div(
        class = "d-flex align-items-center gap-2",
        tags$label(`for` = ns("currency"), class = "form-label mb-0", "in"),
        selectInput(ns("currency"), NULL, choices = currency_choices, selected = "local", selectize = FALSE, width = "11rem")
      ),
      downloadButton(ns("csv"), "CSV", class = "btn-sm")
    ),
    uiOutput(ns("note")),
    shinycssloaders::withSpinner(
      # the rest of the window below the controls, with a minimum in styles.css for a bar per index
      plotly::plotlyOutput(ns("plot"), width = "100%", height = "calc(100vh - 130px)")
    )
  )
}
##########################################################################################
#
##########################################################################################
#' @title Performance module - server
#' @description Shows the change of every index over the period picked, in
#' the money of each index from the summary of the Overview tab, or in US
#' dollars or euros from its price histories, converted with
#' [convert_prices()], so the histories are downloaded once for both tabs.
#' The CSV file, named like `performance-ytd-2026-11-07.csv`, or
#' `performance-ytd-usd-2026-11-07.csv` in US dollars, holds the changes of
#' the chart from [performance_data()], unrounded.
#' @param id Character. Module namespace id, must match the id used in
#'   [mod_performance_ui()].
#' @param summary Reactive returning the [index_summary()] of every index,
#'   as [mod_overview_server()] returns it.
#' @param history Reactive returning the whole price history of every index,
#'   as [mod_overview_server()] returns it, to convert.
#' @param indices Data frame of indices from [get_indices()].
#' @param dark_mode Reactive returning `"light"` or `"dark"`, the mode of the
#'   app.
#' @return None. Called for its side effect of registering the module server.
#' @keywords internal
#' @examples
#' \dontrun{
#' # inside app_server():
#' function(input, output, session) {
#'   overview <- mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
#'   mod_performance_server("performance", overview$summary, overview$history, get_indices(), reactive(input$dark_mode))
#' }
#' }
mod_performance_server <- function(id, summary, history, indices, dark_mode) {
  moduleServer(id, function(input, output, session) {
    period <- reactive(if (is.null(input$period)) "ytd" else input$period)
    currency <- reactive(if (is.null(input$currency)) "local" else input$currency)

    # the summary in the currency picked: that of the Overview tab in the money of each index, or
    # one of the last 400 days of each history converted, enough for the longest period, a year
    converted <- reactive({
      if (currency() == "local") {
        return(summary())
      }
      all <- history()
      last <- stats::ave(as.numeric(all$timestamp), all$label, FUN = max)
      prices <- convert_prices(all[as.numeric(all$timestamp) >= last - 400, ], currency(), indices)
      validate(need(nrow(prices) > 0, "The exchange rates cannot be downloaded right now"))
      index_summary(prices)
    })

    output$note <- renderUI({
      req(currency() != "local")
      text <- missing_rates_text(summary()$label, converted()$label)
      if (!is.null(text)) helpText(text)
    })

    output$plot <- plotly::renderPlotly(plot_performance(converted(), indices, period(), dark_mode(), currency()))

    output$csv <- csv_download(
      reactive(performance_data(converted(), indices, period(), currency())),
      function() paste0("performance-", period(), if (currency() != "local") paste0("-", tolower(currency())))
    )
  })
}
