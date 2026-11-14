# Performance module - server

Shows the change of every index over the period picked, in the money of
each index from the summary of the Overview tab, or in US dollars or
euros from its price histories, converted with
[`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md),
so the histories are downloaded once for both tabs. The CSV file, named
like `performance-ytd-2026-11-07.csv`, or
`performance-ytd-usd-2026-11-07.csv` in US dollars, holds the changes of
the chart from
[`performance_data()`](https://sedzinfo.github.io/golemstockindices/reference/performance_data.md),
unrounded.

## Usage

``` r
mod_performance_server(id, summary, history, indices, dark_mode)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_performance_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_performance_ui.md).

- summary:

  Reactive returning the
  [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
  of every index, as
  [`mod_overview_server()`](https://sedzinfo.github.io/golemstockindices/reference/mod_overview_server.md)
  returns it.

- history:

  Reactive returning the whole price history of every index, as
  [`mod_overview_server()`](https://sedzinfo.github.io/golemstockindices/reference/mod_overview_server.md)
  returns it, to convert.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- dark_mode:

  Reactive returning `"light"` or `"dark"`, the mode of the app.

## Value

None. Called for its side effect of registering the module server.

## Examples

``` r
if (FALSE) { # \dontrun{
# inside app_server():
function(input, output, session) {
  overview <- mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
  mod_performance_server("performance", overview$summary, overview$history, get_indices(), reactive(input$dark_mode))
}
} # }
```
