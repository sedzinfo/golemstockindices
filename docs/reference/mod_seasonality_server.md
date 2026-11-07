# Seasonality module - server

Analyses the returns of the index selected in the Timeseries tab by day
of the week, week of the year, month or year of the US presidential
cycle with
[`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md),
and shows them in words, as a chart and as a table. The CSV file, named
like `s-p-500-seasonality-month-2026-11-07.csv`, holds
[`seasonality_csv()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_csv.md):
a row per group.

## Usage

``` r
mod_seasonality_server(id, history, dark_mode)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_seasonality_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_seasonality_ui.md).

- history:

  Reactive returning the price history of the selected index, from
  [`mod_timeseries_server()`](https://sedzinfo.github.io/golemstockindices/reference/mod_timeseries_server.md).

- dark_mode:

  Reactive returning `"light"` or `"dark"`, the mode of the app.

## Value

None. Called for its side effect of registering the module server.

## Examples

``` r
if (FALSE) { # \dontrun{
# inside app_server():
function(input, output, session) {
  dark_mode <- reactive(input$dark_mode)
  history <- mod_timeseries_server("timeseries", indices, dark_mode)
  mod_seasonality_server("seasonality", history, dark_mode)
}
} # }
```
