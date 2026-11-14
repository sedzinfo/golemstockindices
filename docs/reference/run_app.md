# Launch the Stock Market Indices app

Starts an interactive 'shiny' application for exploring the major stock
market indices of the Americas, Europe, Africa and Asia-Pacific, with
daily prices from Yahoo Finance.

## Usage

``` r
run_app(analytics = FALSE, keep_alive = TRUE, ...)
```

## Arguments

- analytics:

  `TRUE` to add Google Analytics, through the cookie banner shared with
  the sites of sedzinfo.github.io, which loads it only after the visitor
  accepts. Meant for the public deployment (see `app.R`); off by
  default, so that running the app yourself sends nothing.

- keep_alive:

  `TRUE` (the default) to ping the server every 15 seconds while the
  page is open, so that proxies do not close idle connections. `FALSE`
  lets the app go to sleep when nobody uses it, as `app.R` does.

- ...:

  Further arguments passed to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html),
  for example `options = list(port = 8080)`.

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object. Printing it, or calling `run_app()` at the console, opens the
app in the browser.

## Details

The application has the following tabs:

- Overview:

  A table of all the indices: the last close, the change on the day,
  this year and over a year, and how far each is below its all-time
  high.

- Timeseries:

  Candlestick chart of the daily open, high, low and close of an index
  over its whole history, with its 50- and 200-day moving averages, and
  charts of the volume and of the drawdown (how far the index is below
  its all-time high) underneath.

- Compare:

  Closes of up to 10 indices, normalized to 100 on the first date all of
  them have data.

- Returns calendar:

  Monthly returns by year for the index selected in the Timeseries tab.

- Seasonality:

  The returns of the index selected in the Timeseries tab by day of the
  week, week of the year, month or year of the US presidential cycle,
  with a test of whether the differences could be chance.

- Volatility:

  Whether the volatility of the last weeks and the move of the last days
  of the index are normal, and a GARCH forecast of the next days with
  the value at risk.

- Drawdowns:

  How far the index is below its all-time high, and how deep its earlier
  falls went and how long they took to recover.

The prices are downloaded from Yahoo Finance when an index is first
picked and kept on disk between R sessions, so after the first download
only the last two weeks are fetched, at most once an hour. No API key is
needed, but an internet connection is.

## Examples

``` r
if (interactive()) run_app()

# on a fixed port
if (interactive()) run_app(options = list(port = 8080))
```
