# Timeseries module - server

Gets the whole price history of the selected index, renders its
candlestick chart and serves it as a CSV file named like
`s-p-500-history-2026-11-07.csv`, with the columns `date`, `label`,
`open`, `high`, `low`, `close` and `volume`.

## Usage

``` r
mod_timeseries_server(id, indices, dark_mode)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_timeseries_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_timeseries_ui.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- dark_mode:

  Reactive returning `"light"` or `"dark"`, the mode of the app.

## Value

A reactive returning the price history of the selected index, from
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
which the Returns calendar, Seasonality, Volatility and Drawdowns tabs
reuse.

## Examples

``` r
if (FALSE) { # \dontrun{
# inside app_server():
function(input, output, session) {
  history <- mod_timeseries_server("timeseries", indices, reactive(input$dark_mode))
}
} # }
```
