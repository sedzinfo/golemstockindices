##########################################################################################
#
##########################################################################################
#' @title Launch the Stock Market Indices app
#' @description Starts an interactive 'shiny' application for exploring the
#'   major stock market indices of the Americas, Europe, Africa and Asia-Pacific, with daily prices
#'   from Yahoo Finance.
#' @details The application has the following tabs:
#'   \describe{
#'     \item{Overview}{Which exchanges are open, and a table of all the
#'       indices: the last close, the change on the day, this year and over a
#'       year, the current run of rises or falls, how far each is from its
#'       200-day average and its 52-week low and high, and how far it is below
#'       its all-time high.}
#'     \item{Performance}{The change of every index over a day, a week, 1, 3,
#'       6 or 9 months, this year or a year, side by side, the best at the
#'       top, in its own currency, US dollars or euros.}
#'     \item{Timeseries}{Candlestick chart of the daily open, high, low and
#'       close of an index over its whole history, with its 50- and 200-day
#'       moving averages, optional Bollinger bands and relative strength
#'       index, and charts of the volume and of the drawdown (how far the
#'       index is below its all-time high) underneath.}
#'     \item{Compare}{Closes of up to 10 indices, normalized to 100 on the
#'       first date all of them have data, or relative to one of them.}
#'     \item{Returns calendar}{Monthly returns by year for the index selected
#'       in the Timeseries tab.}
#'     \item{Seasonality}{The returns of the index selected in the Timeseries
#'       tab by day of the week, week of the year, month or year of the US
#'       presidential cycle, or a calendar effect against the rest (the turn
#'       of the month, the days before a holiday, the Santa rally or Sell in
#'       May), with a test of whether the differences could be chance.}
#'     \item{Volatility}{Whether the volatility of the last weeks and the move
#'       of the last days of the index are normal, and a GARCH forecast of the
#'       next days with the value at risk.}
#'     \item{Drawdowns}{How far the index is below its all-time high, and how
#'       deep its earlier falls went and how long they took to recover.}
#'     \item{About}{What each index measures, and how every number of the
#'       app is calculated.}
#'   }
#'   The prices are downloaded from Yahoo Finance when an index is first
#'   picked and kept on disk between R sessions, so after the first download
#'   only the last two weeks are fetched, at most once an hour. No API key is
#'   needed, but an internet connection is.
#' @param analytics `TRUE` to add Google Analytics, through the cookie banner
#'   shared with the sites of sedzinfo.github.io, which loads it only after the
#'   visitor accepts. Meant for the public deployment (see `app.R`); off by
#'   default, so that running the app yourself sends nothing.
#' @param keep_alive `TRUE` (the default) to ping the server every 15 seconds
#'   while the page is open, so that proxies do not close idle connections.
#'   `FALSE` lets the app go to sleep when nobody uses it, as `app.R` does.
#' @param ... Further arguments passed to [shiny::shinyApp()], for example
#'   `options = list(port = 8080)`.
#' @return A [shiny::shinyApp()] object. Printing it, or calling `run_app()`
#'   at the console, opens the app in the browser.
#' @import shiny
#' @importFrom plotly %>%
#' @keywords stocks indices timeseries
#' @export
#' @examples
#' if (interactive()) run_app()
#'
#' # on a fixed port
#' if (interactive()) run_app(options = list(port = 8080))
run_app <- function(analytics = FALSE, keep_alive = TRUE, ...) {
  indices <- get_indices()
  shinyApp(
    # a function, so that the page is built at each visit: the dates it holds, such as the start
    # date of the Compare tab, are then those of the visit, not of the day the app started
    ui = function(request) app_ui(indices, analytics, keep_alive),
    server = app_server(indices),
    ...
  )
}
