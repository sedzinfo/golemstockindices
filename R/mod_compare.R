##########################################################################################
#
##########################################################################################
#' @title Compare module - UI
#' @description A picker for up to 10 indices, a start date, a currency, an
#' index to show the others relative to, a button that downloads the
#' normalized closes as CSV, a line on what the
#' conversion to another currency changed when it changed something, and a
#' chart of the indices' closes normalized to 100.
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
      selectInput(ns("currency"), label = "Currency", choices = currency_choices, selected = "local", selectize = FALSE, width = "11rem"),
      # filled with the selected indices by the server
      selectInput(ns("base"), label = "Relative to", choices = c("None" = ""), selectize = FALSE, width = "14rem"),
      div(class = "mb-3 csv-beside-inputs", downloadButton(ns("csv"), "CSV", class = "btn-sm"))
    ),
    uiOutput(ns("note")),
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
#' date, converts it to the currency picked with [convert_prices()], renders
#' the closes normalized to 100, and serves them as a CSV file named like
#' `compare-2026-11-07.csv`, or `compare-usd-2026-11-07.csv` in US dollars,
#' with the columns `date`, `label`, `currency`, `close` and `index`. With an
#' index picked under "Relative to", the chart shows the others relative to
#' it with [relative_prices()], and the CSV file, named like
#' `compare-vs-s-p-500-2026-11-07.csv`, adds `base` and `relative`. The
#' download waits until the selection has not changed for 1.5 seconds,
#' instead of starting on every click in the picker. In another currency, a
#' line above the chart says which indices have no exchange rates, and when
#' the rates, which start between 1996 and 2006, make the comparison start
#' later than the prices would.
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
    currency <- reactive(if (is.null(input$currency)) "local" else input$currency)
    history <- reactive({
      req(selected(), input$start)
      get_history(selected(), input$start, indices)
    })
    converted <- reactive({
      validate(need(history(), "Data not available for the selected indices"))
      converted <- convert_prices(history(), currency(), indices)
      validate(need(nrow(converted) > 0, "The exchange rates cannot be downloaded right now"))
      converted
    })
    prices <- reactive(normalize_prices(converted()))

    # the base can be any selected index; it stays picked while it is selected
    observeEvent(selected(), ignoreNULL = FALSE, {
      keep <- if (isTRUE(input$base %in% selected())) input$base else ""
      updateSelectInput(session, "base", choices = c("None" = "", selected()), selected = keep)
    })
    base <- reactive({
      base <- input$base
      if (is.null(base) || !nzchar(base) || !base %in% selected()) NULL else base
    })
    relative <- reactive({
      req(base())
      validate(need(base() %in% prices()$label, paste("No prices of", base(), "to compare with")))
      validate(need(length(unique(prices()$label)) >= 2, "Select another index to compare with the base"))
      relative_prices(prices(), base())
    })

    output$note <- renderUI({
      req(currency() != "local")
      # the first day every index has a price, before the conversion
      start_prices <- max(tapply(as.numeric(history()$timestamp), history()$label, min))
      start <- min(prices()$timestamp)
      text <- c(
        missing_rates_text(history()$label, converted()$label),
        if (as.numeric(start) > start_prices) {
          sprintf("The exchange rates start later than the prices, so the comparison starts on %s.", long_date(start))
        }
      )
      if (length(text) > 0) helpText(paste(text, collapse = " "))
    })

    output$plot <- plotly::renderPlotly({
      if (is.null(base())) {
        plot_compare(prices(), dark_mode(), indices, currency())
      } else {
        plot_compare(relative(), dark_mode(), indices, currency(), base = base())
      }
    })

    output$csv <- csv_download(
      reactive({
        rows <- if (is.null(base())) prices() else relative()
        local <- indices$currency[match(rows$label, indices$label)]
        csv <- data.frame(
          date = rows$timestamp,
          label = rows$label,
          # the VIX keeps no currency
          currency = if (currency() == "local") local else ifelse(is.na(local), NA, currency()),
          close = rows$close,
          index = if (is.null(base())) rows$index else rows$index * rows$base_index / 100
        )
        if (!is.null(base())) {
          csv$base <- rows$base
          csv$relative <- rows$index
        }
        csv
      }),
      function() {
        paste0(
          "compare",
          if (currency() != "local") paste0("-", tolower(currency())),
          if (!is.null(base())) paste0("-vs-", file_stem(base()))
        )
      }
    )
  })
}
